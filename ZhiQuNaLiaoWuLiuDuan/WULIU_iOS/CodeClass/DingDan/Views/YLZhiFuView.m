//
//  YLZhiFuView.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLZhiFuView.h"
#import "YLZhiFuTitleCell.h"
#import "YLZhiFuSelectCell.h"
#import "YLZhiFuSelectMoreCell.h"
#import "YLZhiFuQiTaView.h"
@interface YLZhiFuView()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation YLZhiFuView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.zhifuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLZhiFuTitleCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLZhiFuTitleCell class])
     ];
    [self.zhifuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLZhiFuSelectCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLZhiFuSelectCell class])
     ];
    [self.zhifuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLZhiFuSelectMoreCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLZhiFuSelectMoreCell class])
     ];
    self.zhifuTableView.separatorColor = [UIColor clearColor];
    self.zhifuTableView.delegate = self;
    self.zhifuTableView.dataSource = self;
//    self.zhifuTableView.tableFooterView = [self createfooterBtn];
}

- (UIButton *)createfooterBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = YLNaviColor;
    [button setTitle:@"去支付196.00元" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@33);
        make.right.equalTo(@33);
        make.height.equalTo(@40);
        make.bottom.equalTo(@20);
    }];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    return button;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0==indexPath.row) {
        YLZhiFuTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLZhiFuTitleCell class]) forIndexPath:indexPath];
        [[[cell.quxiaobtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            [self removeFromSuperview];
        }];
        cell.backBtn.hidden = YES;
        cell.selectionStyle = 0;
        return cell;
    }else if (2==indexPath.row) {
        
        YLZhiFuSelectMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLZhiFuSelectMoreCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        return cell;
    
    }else {
       
        YLZhiFuSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLZhiFuSelectCell class]) forIndexPath:indexPath];
        if (1==indexPath.row) {
            cell.kaNameLabel.text = @"招商银行储蓄卡",
            cell.kaHaoLabel.text = @"(7128)";
            cell.leftImageView.image = [UIImage imageNamed:@"zhifu_kuaijie"];
        }else {
        
        
        NSArray *imageArray = @[@"zhifu_zhifubao",@"zhifu_weixin"];
        NSArray *titleArray = @[@"支付宝支付",@"微信支付"];
        cell.kaHaoLabel.text = @"";
            cell.leftImageView.image = [UIImage imageNamed:imageArray[indexPath.row-3]];
            cell.kaNameLabel.text = titleArray[indexPath.row - 3];
        
        
        }
        cell.selectionStyle = 0;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[YLZhiFuSelectCell class]]) {
        YLZhiFuSelectCell *selectCell = (YLZhiFuSelectCell *)cell;
        selectCell.xuanzeBtn.hidden = NO;
    }else if (indexPath.row == 2) {
        [self removeFromSuperview ];
        YLZhiFuQiTaView *qitaView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YLZhiFuQiTaView class]) owner:nil options:nil].lastObject;
       [[[UIApplication  sharedApplication ]  keyWindow ] addSubview : qitaView] ;
    }else {
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[YLZhiFuSelectCell class]]) {
        YLZhiFuSelectCell *selectCell = (YLZhiFuSelectCell *)cell;
        selectCell.xuanzeBtn.hidden = YES;
    }
}

@end
