//
//  YLFaBuDetailController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/24.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLFaBuDetailController.h"
#import "YLAddFaBuController.h"
#import "YLFaBuDetailCell.h"
#import "YLFaBuDetailModel.h"

@interface YLFaBuDetailController ()
//标题arr
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)NSMutableArray *modelArr;

//弹窗视图
@property (strong, nonatomic) UIView *contentView;

@end

@implementation YLFaBuDetailController
- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.title = @"可接单路线";
 
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"daohang_bianji"] style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    
    
    //控制器根据所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的inset
    self.tableView.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLFaBuDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLFaBuDetailCell class])];
  
}

-(void)initData{
    
     self.titleArr = @[@"起始",@"目的地",@"车承载量",@"可接单日期"];
    NSString *dateString = [NSString stringWithFormat:@"%@吨",self.fabuModel.ldr_capacity];
 
    self.modelArr = [@[self.fabuModel.depart_address,self.fabuModel.dest_address,dateString,self.fabuModel.ldr_can_tack_date] mutableCopy];
//     self.model = [YLFaBuDetailModel getDefaultDataArray];
    
}

//-(void)editAction{
//    
//    YLAddFaBuController *avc = [[YLAddFaBuController alloc]init];
//    avc.title = @"发布可接单路线";
//    avc.model = self.fabuModel;
//    [self.navigationController pushViewController:avc animated:YES];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLFaBuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLFaBuDetailCell class]) forIndexPath:indexPath];
    cell.leftLabel.text = self.titleArr[indexPath.row];
    cell.rightlabel.text = self.modelArr[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT * 0.1;
}

@end
