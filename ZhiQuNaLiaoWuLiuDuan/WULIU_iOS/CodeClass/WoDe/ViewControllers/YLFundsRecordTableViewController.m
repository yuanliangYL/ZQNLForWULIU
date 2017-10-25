//
//  YLFundsRecordTableViewController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLFundsRecordTableViewController.h"
#import "YLFundsRecordCell.h"

@interface YLFundsRecordTableViewController ()
@property(nonatomic,strong)NSMutableArray *allArr;
@end

static NSString *fundsrecordCell = @"FundsRecordCell";

static int pageNum = 0;
static int size = 5;

@implementation YLFundsRecordTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];
    
    [self setupUI];

}

-(void)initData{
    
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"handle":@(8),@"pageNum":@(pageNum),@"size":@(size)};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"资金：%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //数据处理
            

        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2.0];
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } isWithSign:YES];
    
}

-(void)setupUI{
    
    self.title = @"资金流水";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YLFundsRecordCell" bundle:nil] forCellReuseIdentifier:fundsrecordCell];
    self.tableView .bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLFundsRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:fundsrecordCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT * 0.2;
}
@end
