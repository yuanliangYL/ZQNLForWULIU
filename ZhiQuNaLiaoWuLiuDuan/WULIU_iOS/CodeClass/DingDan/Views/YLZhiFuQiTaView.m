//
//  YLZhiFuQiTaView.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLZhiFuQiTaView.h"
#import "YLZhiFuTitleCell.h"
#import "YLZhiFuSelectCell.h"
#import "YLZhiFuView.h"
#import "YLZhiFuQiTaView.h"



@interface YLZhiFuQiTaView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *zhifuTableView;
@property (nonatomic, strong) YLZhiFuView *zhifuView;
@end

@implementation YLZhiFuQiTaView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.zhifuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLZhiFuTitleCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLZhiFuTitleCell class])
     ];
    [self.zhifuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLZhiFuSelectCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLZhiFuSelectCell class])
     ];
   
    self.zhifuTableView.separatorColor = [UIColor clearColor];
    self.zhifuTableView.delegate = self;
    self.zhifuTableView.dataSource = self;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0==indexPath.row) {
        YLZhiFuTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLZhiFuTitleCell class]) forIndexPath:indexPath];
        cell.quxiaobtn.hidden = YES;
        
        [[[cell.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
//            [self.tishiView removeFromSuperview];
             [self removeFromSuperview];
            self.zhifuView = [[NSBundle mainBundle] loadNibNamed:@"YLZhiFuView" owner:nil options:nil].lastObject;
            self.zhifuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            [[[UIApplication  sharedApplication ]  keyWindow ] addSubview : self.zhifuView] ;
        }];
        cell.selectionStyle = 0;
        return cell;
    }else {
        
        YLZhiFuSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLZhiFuSelectCell class]) forIndexPath:indexPath];
        if (1==indexPath.row) {
            cell.kaNameLabel.text = @"招商银行储蓄卡",
            cell.kaHaoLabel.text = @"(7128)";
            cell.leftImageView.image = [UIImage imageNamed:@"zhifu_kuaijie"];
        }else {
            
            cell.kaHaoLabel.text = @"";
            cell.leftImageView.image = [UIImage imageNamed:@"zhifu_qita"];
            cell.kaNameLabel.text = @"添加新银行卡";
            
            
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
