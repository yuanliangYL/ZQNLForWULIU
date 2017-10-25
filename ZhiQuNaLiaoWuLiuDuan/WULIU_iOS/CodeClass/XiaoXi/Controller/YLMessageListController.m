//
//  YLMessageListController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/9/13.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLMessageListController.h"
#import "YLmessageTypeOneCell.h"
#import "YLMessageModel.h"
#import "YLmessageTypeTwoCell.h"
@interface YLMessageListController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray<YLMessageModel *> *dataArr;

@end

static int page = 0;
static int size = 10;

@implementation YLMessageListController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
//    [self networkAnomalyWithView:self.view refresh:^{
//        [self initData];
//    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.handle isEqualToString:@"2"]) {
        
        self.title = @"物流订单消息";
        
    }else if ([self.handle isEqualToString:@"1"]){
        
        self.title = @"物流申请消息";
        
    }else if ([self.handle isEqualToString:@"3"]){
        
        self.title = @"个人消息";
        
    }else{
        self.title = @"系统消息";
    }
    
    //取消cell中的线
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    //xib垂直边距自适应高度
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
 
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header  = [YLRefreshHeader initRefreshViewForTableView:self.tableView withBlock:^{
        
        [weakSelf refreshData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    //默认block方法：设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMore];
        
    }];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLmessageTypeOneCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLmessageTypeOneCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLmessageTypeTwoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLmessageTypeTwoCell class])];

    [self.view addSubview:self.tableView];
    
//    [self initData];
}

-(void)refreshData{
    page = 0;
    
    [self initData];
}
-(void)initData{

    NSDictionary *dic =@{@"uid":[WoDeModel sharedWoDeModel].user_id,
                         @"handle":self.handle,
                         @"size":@(size),
                         @"pageNum":@(page)};

    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KDrivergetNews withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"消息%@",data);
        if (page == 1) {
            [self.dataArr removeAllObjects];
            [self.tableView.mj_footer endRefreshing];
        }
       if (data && [data [@"status_code"] integerValue] == 10000) {

           self.dataArr = [YLMessageModel mj_objectArrayWithKeyValuesArray:data [@"data"]];
       }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
        }
        
        //有无数据
        if (self.dataArr.count==0) {
            
            Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            
            if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                
                [self hasOrderViewWithView:self.view];
                
            }else {
                
                [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height) type:XIAOXI];
                
                //添加手势
                UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(initData)];
                doubleRecognizer.numberOfTapsRequired = 2; // 双击
                //关键语句，给self.view添加一个手势监测；
                [self.view addGestureRecognizer:doubleRecognizer];
            }
        }else {
            
            [self hasOrderViewWithView:self.view];
            
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } isWithSign:YES];

}


-(void)loadMore{
   page ++;
    NSDictionary *dic =@{@"uid":[WoDeModel sharedWoDeModel].user_id,
                         @"handle":self.handle,
                         @"size":@(size),
                         @"pageNum":@(page)};

    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KDrivergetNews withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {

        NSLog(@"消息%@",data);

        if (data && [data [@"status_code"] integerValue] == 10000) {

            [self.dataArr addObjectsFromArray:[YLMessageModel mj_objectArrayWithKeyValuesArray:data [@"data"]]];
            
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else if (data && [data [@"status_code"] integerValue] == 10002) {

            //提示框
            [self.tableView.mj_footer endRefreshingWithNoMoreData];

        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } isWithSign:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.handle isEqualToString:@"2"] || [self.handle isEqualToString:@"1"]) {
        
        YLmessageTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLmessageTypeOneCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.model = self.dataArr[indexPath.row];
        
        return cell;
        
    }else{
        
        YLmessageTypeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLmessageTypeTwoCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        
        cell.model = self.dataArr[indexPath.row];
        
        return cell;
    }
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self readMessage:indexPath];
    
}

//信息读取操作
-(void)readMessage:(NSIndexPath *)indexPath{
    
    NSString *slug = nil;
    NSString *messageId = nil;
   
    if ([self.handle isEqualToString:@"2"]) {
        
        slug = @"2";
        messageId = self.dataArr[indexPath.row].dlo_id;
        
    }else if ([self.handle isEqualToString:@"1"]){
        
         slug = @"1";
         messageId = self.dataArr[indexPath.row].dam_id;
        
    }else if ([self.handle isEqualToString:@"3"]){
         slug = @"3";
         messageId = self.dataArr[indexPath.row].dpm_id;
        
    }else{
        
         slug = @"4";
         messageId = self.dataArr[indexPath.row].sm_id;
    }
    
    NSDictionary *dic =@{@"uid":[WoDeModel sharedWoDeModel].user_id,
                         @"handle":@(6),
                         @"slug":slug,
                         @"news_id":messageId
                         };
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KDrivergetNews withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@",data);
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            
            for (int i = 0; i < self.dataArr.count; i ++) {
                
                if (self.dataArr[i].dlo_read_state){
                    
                    if (i == indexPath.row) {
                        
                        self.dataArr[i].dlo_read_state = @"1";
                    }
                    
                    
                }else if(self.dataArr[i].dam_read_state) {
                    
                    if (i == indexPath.row) {
                        self.dataArr[i].dam_read_state = @"1";
                    }
                    
                }else if (self.dataArr[i].dpm_read_state){
                    
                    if (i == indexPath.row) {
                        self.dataArr[i].dpm_read_state = @"1";
                    }
                    
                }else{
                    
                    if (i == indexPath.row) {
                        self.dataArr[i].dlo_read_state = @"1";
                    }
                    
                }
            }
            [self.tableView reloadData];
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }
    } isWithSign:YES];
  
}
@end
