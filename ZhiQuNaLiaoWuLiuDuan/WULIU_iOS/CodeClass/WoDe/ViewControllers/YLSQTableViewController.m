//
//  YLSQTableViewController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/26.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLSQTableViewController.h"
#import "YLDaoBaoSQCell.h"
#import "YLWoDeSQCell.h"

#import "YLShenQingModel.h"
#import "YLShenQingDetailController.h"
#import "YLSQDetailController.h"

@interface YLSQTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITableView *tableview;
//数组
@property(nonatomic,strong)NSMutableArray <YLShenQingModel *> *dataArr;

@property(nonatomic,strong)YLMBProgressHUD *hud;
@end

static int pageNum = 0;
static int size = 10;

@implementation YLSQTableViewController

-(YLMBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [YLMBProgressHUD initProgressInViewbystateShow:self.tableview];
    }
    return _hud;
}

-(void)viewWillAppear:(BOOL)animated{
    
      [self initData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupUI];
}

-(void)initData{
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"pageNum":@(pageNum),
                         @"size":@(size),
                         @"slug":@(self.ShenQingStatusType),};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        if (pageNum == 0) {
            [self.dataArr removeAllObjects];
            [self.tableview.mj_footer endRefreshing];
        }
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            self.dataArr = [YLShenQingModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
            [self.view bringSubviewToFront:self.tableview];
            
        }else if (data && [data [@"status_code"] integerValue] == 10005){
            
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.tableview afterDelay:1];
        }
        
        //有无数据
        if (self.dataArr.count==0) {
            
            Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            
            if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                
                [self hasOrderViewWithView:self.view];
                
            }else {
                
                [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) type:SHENQING];
                
                //添加手势
                UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshData)];
                doubleRecognizer.numberOfTapsRequired = 2; // 双击
                //关键语句，给self.view添加一个手势监测；
                [self.view addGestureRecognizer:doubleRecognizer];
            }
            
        }
//        else {
//
//            [self hasOrderViewWithView:self.view];
//
//        }
//        //加载数据完毕
//        [self loadSuccessDataWithView:self.view];
        
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
        
    } isWithSign:YES];
}

-(void)setupUI{
    
    //控制器根据所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的inset
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - 64 - 44) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.bounces = YES;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableview.showsVerticalScrollIndicator = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YLDaoBaoSQCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDaoBaoSQCell class])];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YLWoDeSQCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLWoDeSQCell class])];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    
    self.tableview.mj_header  = [YLRefreshHeader initRefreshViewForTableView:self.tableview withBlock:^{
        
        [weakSelf refreshData];
        
    }];
    [self.tableview.mj_header beginRefreshing];
    
    //默认block方法：设置上拉加载更多
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMore];
    }];
    
    
    [self.view addSubview:self.tableview];
}

//刷新数据
-(void)refreshData{
    
    pageNum = 0;
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"pageNum":@(pageNum),
                         @"size":@(size),
                         @"slug":@(self.ShenQingStatusType),};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (pageNum == 0) {
            
            [self.dataArr removeAllObjects];
            
            [self.tableview.mj_footer endRefreshing];
            
        }
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            self.dataArr = [YLShenQingModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
        
            [self.view bringSubviewToFront:self.tableview];
            
        }else if (data && [data [@"status_code"] integerValue] == 10005){
            
            [self.dataArr removeAllObjects];
    
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.tableview afterDelay:2];
            
        }
        //有无数据
        if (self.dataArr.count==0) {
            
            Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            
            if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                
                [self hasOrderViewWithView:self.view];
                
            }else {
                
                [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) type:SHENQING];
                
                //添加手势
                UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshData)];
                doubleRecognizer.numberOfTapsRequired = 2; // 双击
                //关键语句，给self.view添加一个手势监测；
                [self.view addGestureRecognizer:doubleRecognizer];
            }
        }
        
//        else {
//
//            [self hasOrderViewWithView:self.view];
//
//        }
        
        [self.tableview reloadData];
        
        [self.tableview.mj_header endRefreshing];
    } isWithSign:YES];
}

//加载更多
-(void)loadMore{
    
    pageNum ++;
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"pageNum":@(pageNum),
                         @"size":@(size),
                         @"slug":@(self.ShenQingStatusType),};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            [self.dataArr arrayByAddingObjectsFromArray:[YLShenQingModel mj_objectArrayWithKeyValuesArray:data[@"data"]]];
            
            [self.tableview reloadData];
            
        }else{
            
        }
        
        [self.tableview.mj_footer endRefreshingWithNoMoreData];
        
    } isWithSign:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    /******************************************打包站申请******************************************/
    if (self.orderType == 2) {

        YLDaoBaoSQCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDaoBaoSQCell class])];
        cell.selectionStyle = 0;
        cell.model = self.dataArr[indexPath.row];
   
        //同意
        [[[cell.aggrenBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            [self aggrenAction:indexPath withType:@"4"];
        }];
        
        //拒绝
        [[[cell.refuseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            
            [self refuseAction:indexPath withType:@"3"];
            
        }];
        
        //联系打包站
        [[[cell.contentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            [self contactAction:indexPath];
        }];
        
        //删除
        [[[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            [self deleteAction:indexPath withType:@"5" andID:self.dataArr[indexPath.row].plg_id];
        }];
        
        return cell;
    
    }
    
     /******************************************我的申请******************************************/
    else{
    
        YLWoDeSQCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLWoDeSQCell class])];
        cell.selectionStyle = 0;
        cell.model = self.dataArr[indexPath.row];
        
        //联系打包站
        [[[cell.contentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            [self contactAction:indexPath];
        }];
        
        //删除
        [[[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            [self deleteAction:indexPath withType:@"4" andID:self.dataArr[indexPath.row].dla_id];
        }];
        
        //未回应重新申请
        [[[cell.rerequst rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            
            YLShenQingDetailController *vc = [YLShenQingDetailController new];
            vc.shenQingModel = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        //拒绝后重新申请
        [[[cell.rerequsetInFinish rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
            YLShenQingDetailController *vc = [YLShenQingDetailController new];
            vc.shenQingModel = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        //取消申请
        [[[cell.cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
           [self cancleAction:indexPath withType:@"3"];
        }];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPatha{
    
    return SCREEN_HEIGHT * 0.36;
    
}

#pragma mark - btnAction

//同意
-(void)aggrenAction:(NSIndexPath *)indexpath withType:(NSString *)type{
    
    NSLog(@"%@",self.dataArr[indexpath.row]);
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":type,
                         @"id":self.dataArr[indexpath.row].plg_id,
                         @"pack_id":self.dataArr[indexpath.row].pack_id,
                         @"order_id":self.dataArr[indexpath.row].order_id,
                         @"logistics_require_id":self.dataArr[indexpath.row].logistics_require_id,
                         @"plor_total":self.dataArr[indexpath.row].plg_offer_price,
                         @"plor_weight":self.dataArr[indexpath.row].capacity,
                         @"plor_send_address":self.dataArr[indexpath.row].start_area,
                         @"plor_take_address":self.dataArr[indexpath.row].end_area,
                         @"plor_send_date":self.dataArr[indexpath.row].plg_estimate_depart_date,
                         @"order_type":self.dataArr[indexpath.row].order_type,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
           
            [self refreshData];
            
            [YLMBProgressHUD initWithString:@"物流申请已同意" inSuperView:self.tableview afterDelay:1];
           
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.tableview afterDelay:1];
        }
    
    } isWithSign:YES];
}

//拒绝
-(void)refuseAction:(NSIndexPath *)indexpath withType:(NSString *)type{
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":type,
                         @"id":self.dataArr[indexpath.row].plg_id,
                         @"pack_id":self.dataArr[indexpath.row].pack_id
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //删除成功
            [YLMBProgressHUD initWithString:@"物流申请已同意" inSuperView:self.tableview afterDelay:1];
            
            [self refreshData];
            
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.tableview afterDelay:2];
            
        }
        
    } isWithSign:YES];
}

//联系
-(void)contactAction:(NSIndexPath *)indexpath{
    
    NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataArr[indexpath.row].pack_phone]];
    
    [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:nil];
    
}

//删除
-(void)deleteAction:(NSIndexPath *)indexpath withType:(NSString *)type andID:(NSString *)idNumber{
    
    [self.hud show:YES];
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":type,
                         @"id":idNumber,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //删除成功
            [self.dataArr removeObjectAtIndex:indexpath.row];
            
            [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableview reloadData];
            
            //有无数据
            if (self.dataArr.count==0) {
                
                Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
                
                if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                    
                    [self hasOrderViewWithView:self.view];
                    
                }else {
                    
                    [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) type:SHENQING];
                    
                    //添加手势
                    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refreshData)];
                    doubleRecognizer.numberOfTapsRequired = 2; // 双击
                    //关键语句，给self.view添加一个手势监测；
                    [self.view addGestureRecognizer:doubleRecognizer];
                }
            }else {
                
                [self hasOrderViewWithView:self.view];
                
            }
            
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.tableview afterDelay:2];
        }
        [self.hud hide:YES];
        
    } isWithSign:YES];
}

//取消
-(void)cancleAction:(NSIndexPath *)indexpath withType:(NSString *)type{
    
    [self.hud show:YES];
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":type,
                         @"id":self.dataArr[indexpath.row].dla_id,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            [self refreshData];
            
            [YLMBProgressHUD initWithString:@"物流申请已取消" inSuperView:self.tableview afterDelay:1];
            
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.tableview afterDelay:2];
        }
        [self.hud hide:YES];
        
    } isWithSign:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YLSQDetailController *sqdvc = [[YLSQDetailController alloc]init];
    //申请类型
    sqdvc.orderType = self.orderType;
    sqdvc.model = self.dataArr[indexPath.row];
    
    [self.navigationController pushViewController:sqdvc animated:YES];
    
}

@end

