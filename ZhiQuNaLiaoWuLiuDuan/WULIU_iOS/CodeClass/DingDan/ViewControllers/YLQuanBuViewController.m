//
//  YLQuanBuViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLQuanBuViewController.h"
#import "DingDanListModel.h"
#import "YLDingDanListCell.h"
//#import "YLDaiJieSuanCell.h"
#import "YLDaiShouHuoCell.h"
#import "YLYiWanChengCell.h"
#import "YLDingDanDetailViewController.h"
#import "YLTiShiView.h"
#import "YLZhiFuView.h"
#import "DingDanListModel.h"

@interface YLQuanBuViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageNum;
    NSInteger _size;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//@property (nonatomic, strong)  NSMutableArray<DingDanListModel*>* dataArray;
@property (nonatomic, strong) YLTiShiView *tishiView;
@property (nonatomic, strong) YLZhiFuView *zhifuView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YLQuanBuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshAllData];
    [self networkAnomalyWithView:self.view refresh:^{
        [self refreshAllData];
    }];
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)makeData {
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:0];
    [dataSource addObjectsFromArray:@[
  @{@"imageView":@"order_touxiang",
                    @"name":@"张三",
                    @"status":@"待提货",
                    @"qujian":@"地球——————火星——————金星",
                    @"zhongliang":@"2w亿吨",
                    @"baojia":@"十万亿",
                    @"leftBtnTitle":@"取消",
                    @"rightBtnTitle":@"联系打包站",
    @"type":@0
                            },
  @{@"imageView":@"order_touxiang",
                    @"name":@"张三",
                    @"status":@"待收货",
                    @"qujian":@"地球——————火星——————金星",
                    @"zhongliang":@"2w亿吨",
                    @"baojia":@"十万亿",
                    @"leftBtnTitle":@"联系打包站",
                    @"rightBtnTitle":@"确认收货",
     @"type":@1
                                },
  @{@"imageView":@"order_touxiang",
                    @"name":@"张三",
                    @"status":@"已完成",
                    @"qujian":@"地球——————火星——————金星",
                    @"zhongliang":@"2w亿吨",
                    @"baojia":@"十万亿",
                    @"rightBtnTitle":@"删除",
     @"type":@4
                    },
  @{@"imageView":@"order_touxiang",
                    @"name":@"张三",
                    @"status":@"待结算",
                    @"qujian":@"地球——————火星——————金星",
                    @"zhongliang":@"2w亿吨",
                    @"baojia":@"十万亿",
     @"type":@3
                    },
  @{@"imageView":@"order_touxiang",
                    @"name":@"张三",
                    @"status":@"待结算",
                    @"qujian":@"地球——————火星——————金星",
                    @"zhongliang":@"2w亿吨",
                    @"baojia":@"十万亿",
     @"type":@3
                    },
  @{@"imageView":@"order_touxiang",
                @"name":@"张三",
                @"status":@"待结算",
                @"qujian":@"地球——————火星——————金星",
                @"zhongliang":@"2w亿吨",
                @"baojia":@"十万亿",
     @"type":@3
    }]];
  
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in dataSource) {
          DingDanListModel *dingdan = [[DingDanListModel alloc] init];
       dingdan.hiddenBottomBtn=(dingdan.type==3);
        dingdan.hiddenLeftBtn=(dingdan.type==4);
        [dingdan mj_setKeyValues:dic];
        [self.dataArray addObject:dingdan];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAllData)];
    NSMutableArray *idleImages = [NSMutableArray arrayWithCapacity:0]; ;
    UIImage *image1 = [UIImage imageNamed:@"shuaxin1"];
    [idleImages addObject:image1];
    UIImage *image2 = [UIImage imageNamed:@"shuaxin2"];
    [idleImages addObject:image2];
    // Set the ordinary state of animated images
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:idleImages forState:MJRefreshStatePulling];
    // Set the refreshing state of animated images
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    // Set header
    self.myTableView.mj_header = header;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshAllMoreData)];
    self.myTableView.mj_footer.automaticallyHidden = YES;
    

    [self registerXIBCell];
 
}

- (void)registerXIBCell {
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLDingDanListCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDingDanListCell class])
     ];

    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLDaiShouHuoCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDaiShouHuoCell class])
     ];
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLYiWanChengCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLYiWanChengCell class])
     ];
    
    self.myTableView.separatorColor = [UIColor clearColor];
}
#pragma mark------刷新请求数据-----------------------
- (void)refreshAllData {
    _pageNum = 0;
    _size = 10;
    //个人信息
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"slug":@(self.slug),@"pageNum":@(_pageNum),@"size":@(_size),@"handle":@(1)};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"订单%@%@",data,errorMsg);
        
        if (_pageNum == 0) {
            
            [self.dataArray removeAllObjects];
            [self.myTableView.mj_header endRefreshing];
            
        }
        
        if (data && [data[@"status_code"] integerValue] == 10000) {
            
            NSMutableArray *array = data[@"data"];
            for (NSDictionary *modelDic in array) {
                DingDanListModel *model = [DingDanListModel mj_objectWithKeyValues:modelDic];
                [self.dataArray addObject:model];
            }
        }else{
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.myTableView afterDelay:1.5];
        }
        //有无数据
        if (self.dataArray.count==0) {
            Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                [self hasOrderViewWithView:self.view];
            }else {
                [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:ORDER];
            }
        }else {
            [self hasOrderViewWithView:self.view];
        }
        //加载数据完毕
        [self loadSuccessDataWithView:self.view];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
    } isWithSign:YES];
}

- (void)refreshAllMoreData{
    ++ _pageNum ;
    _size = 10;
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"slug":@(self.slug),@"pageNum":@(_pageNum),@"size":@(_size),@"handle":@(1)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@%@",data,errorMsg);
        if ([data[@"status_code"] integerValue] == 10000) {
            NSMutableArray *array = data[@"data"];
            
        for (NSDictionary *modeldic in array) {
            DingDanListModel *model = [DingDanListModel mj_objectWithKeyValues:modeldic];
            [self.dataArray addObject:model];
        }
            [self.myTableView.mj_footer endRefreshing];
            
        }else {
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            
             [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.myTableView afterDelay:1.5];
          
        }
        [self.myTableView reloadData];
    } isWithSign:YES];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (3>indexPath.row) {
        return 260*MLHeight;
//    }else {
//        return 200*MLHeight;
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DingDanListModel *model = self.dataArray[indexPath.row];
    if ([model.plor_order_state integerValue]==1) {
        YLDingDanListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDingDanListCell class]) forIndexPath:indexPath];
        cell.model = model;
        [[[cell.quxiaoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil: cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            WoDeModel *wode = [WoDeModel sharedWoDeModel];
            NSDictionary *dic = @{@"uid":wode.user_id,@"plor_id":model.plor_id};
            [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KDriversuretotake withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                if ([data[@"status_code"] integerValue] ==10000) {
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                    
                }else {
                    
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                }
                
            } isWithSign:YES];
        }];
        cell.selectionStyle = 0;
        return cell;
    }else if ([model.plor_order_state integerValue] == 2) {
        YLDaiShouHuoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDaiShouHuoCell class]) forIndexPath:indexPath];
        cell.model = model;
        [[[cell.QueRenShouHuoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            
            self.tishiView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YLTiShiView class]) owner:nil options:nil].firstObject;
            self.tishiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : self.tishiView] ;
            self.tishiView.tishiLabel.text = @"货物已达到目的地";
            [self.tishiView.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.tishiView.leftBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tishiView.rightBtn setTitle:@"确认" forState:UIControlStateNormal];
            [[self.tishiView.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self  quedingClickWithIndexPath:indexPath];
        }];
  }];
        cell.selectionStyle = 0;
        return cell;
      
    }else {
        YLYiWanChengCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLYiWanChengCell class]) forIndexPath:indexPath];
        

        [[[cell.ShanChuHuoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            [self deleteDingdanWithIndexPath:indexPath];
        }];
        cell.model = model;
        cell.selectionStyle = 0;
        return cell;
    }
}
- (void)deleteDingdanWithIndexPath:(NSIndexPath *)indexPath {
    DingDanListModel *model = self.dataArray[indexPath.row];
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"handle":@(3),@"plor_id":model.plor_id};
    [SD_NetAPIClient_CONFIG  requestJsonDataWithPath:KGetlogisticorderlist_URL  withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@%@",data,error);
        if ([data[@"status"] integerValue] == 10000) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_myTableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
                [self.myTableView reloadData];
            
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
       
        }else {
           [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }
    } isWithSign:YES];

}
- (void)cancleClick:(UIButton *)btn {
    [self.tishiView removeFromSuperview];
}

- (void)goNextClick:(UIButton *)btn {
    [self.tishiView removeFromSuperview];
    self.zhifuView = [[NSBundle mainBundle] loadNibNamed:@"YLZhiFuView" owner:nil options:nil].lastObject;
    self.zhifuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : self.zhifuView] ;
    
}

- (void)quedingClickWithIndexPath:(NSIndexPath *)indexPath {
    
    DingDanListModel *model = self.dataArray[indexPath.row];
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"handle":@(2),@"plor_id":model.plor_id,@"order_id":model.order_id,@"order_type":model.order_type,@"pack_id":model.pack_id,@"logistics_order_number":model.plor_number};
    [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"确认到货%@%@",data,error);
        if ([data[@"status_code"] integerValue] == 10000) {
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }else {
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }
    } isWithSign:YES];
    [self.tishiView removeFromSuperview];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YLDingDanDetailViewController *detailVC = [[YLDingDanDetailViewController alloc] init];
    DingDanListModel *model = self.dataArray[indexPath.row];
    if ([cell isKindOfClass:[YLDingDanListCell class]]) {
        detailVC.index = 0;
        detailVC.plor_id = model.plor_id;
        detailVC.pack_id = model.pack_id;
        detailVC.model = model;
    }else if ([cell isKindOfClass:[YLDaiShouHuoCell class]]) {
        detailVC.index = 1;
        detailVC.plor_id = model.plor_id;
        detailVC.pack_id = model.pack_id;
        detailVC.model = model;

    }else {
        detailVC.index = 3;
        detailVC.plor_id = model.plor_id;
        detailVC.pack_id = model.pack_id;
        detailVC.model = model;
    }
     [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
