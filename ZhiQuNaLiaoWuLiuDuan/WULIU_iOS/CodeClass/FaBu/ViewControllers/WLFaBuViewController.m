//
//  WLFaBuViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLFaBuViewController.h"
#import "FaBuModel.h"
#import "YLFaBuCell.h"
#import "YLAddFaBuController.h"
#import "YLFaBuDetailController.h"
#import "FaBuModel.h"
#import "YLTiShiView.h"
#import "YLAddFaBuController.h"


@interface WLFaBuViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _pageNum;
    NSInteger _size;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *modalArr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YLTiShiView *tishiView;
@end

@implementation WLFaBuViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshData];
    [self networkAnomalyWithView:self.view refresh:^{
        [self refreshData];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
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
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    self.tableView.mj_footer.automaticallyHidden = YES;

    [self setupUI];
    
}
- (void)refreshData {
    _pageNum = 0;
    _size = 10;
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    
    NSDictionary *dic = @{@"uid":mine.user_id,@"handle":@(2),@"pageNum":@(_pageNum),@"size":@(_size)};
    [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KSendlogisticrequire_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"发布%@",data);
        if (_pageNum == 0) {
            [self.dataArray removeAllObjects];
            [self.tableView.mj_footer endRefreshing];
        }
        if ([data[@"status_code"] integerValue] == 10000) {
            if (_pageNum == 0) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array = data[@"data"];
            for (NSDictionary *modelDic in array) {
                FaBuModel *model = [FaBuModel mj_objectWithKeyValues:modelDic];
                [self.dataArray addObject:model];
                
            }
        }
        //有无数据
        if (self.dataArray.count==0) {
            Reachability *netWorkReachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            if ([netWorkReachable currentReachabilityStatus] == NotReachable) {
                [self hasOrderViewWithView:self.view];
            }else {
                [self nullOrderViewWithView:self.view withFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:FABU];
            }
        }else {
            [self hasOrderViewWithView:self.view];
        }
        //加载数据完毕
        [self loadSuccessDataWithView:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
        
    } isWithSign:YES];
}
- (void)requestMoreData {
    
    ++ _pageNum;
    _size = 10;
    
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    
    NSDictionary *dic = @{@"uid":mine.user_id,@"handle":@(2),@"pageNum":@(_pageNum),@"size":@(_size)};
    [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KSendlogisticrequire_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@",data);
        if ([data[@"status_code"] integerValue] == 10000) {
            NSArray *array = data[@"data"];
            for (NSDictionary *modelDic in array) {
                FaBuModel *model = [FaBuModel mj_objectWithKeyValues:modelDic];
                [self.dataArray addObject:model];
                
            }
            [self.tableView.mj_footer endRefreshing];
            
        }else{
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } isWithSign:YES];
    
}

-(void)initData{
    self.modalArr = [FaBuModel getDefaultDataArray];
}

- (void)setupUI{
    
    //控制器根据所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableView.showsVerticalScrollIndicator = NO;
 

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLFaBuCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLFaBuCell class])];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(AddNew)];

}

/**
 添加新的发布
 */
-(void)AddNew{
    
    YLAddFaBuController *afbvc = [ YLAddFaBuController new];
    
    [self.navigationController pushViewController:afbvc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FaBuModel *model = self.dataArray[indexPath.row];
    YLFaBuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLFaBuCell class]) forIndexPath:indexPath];
    cell.selectionStyle = 0;
//    cell.model = self.modalArr[indexPath.row];
    cell.model = model;
    
    [[[cell.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
        
        NSLog(@"%ld",(long)indexPath.row);
        
        YLAddFaBuController *fabuVC = [[YLAddFaBuController alloc] init];
        fabuVC.pagesouce = @"编辑";
        fabuVC.model = model;
        [self.navigationController pushViewController:fabuVC animated:YES];
        
    }];
    
    [[[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
  
        [self deleteFabuDataWithIndexPath:indexPath];
   
    }];
    

    return cell;
}

- (void)deleteFabuDataWithIndexPath:(NSIndexPath *)indexPath {
    self.tishiView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YLTiShiView class]) owner:nil options:nil].firstObject;
    self.tishiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : self.tishiView] ;
    self.tishiView.tishiLabel.text = @"您是否删除该路线";
    [self.tishiView.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [[[self.tishiView.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] distinctUntilChanged] subscribeNext:^(id x) {
        [self.tishiView removeFromSuperview];
    }];
     [self.tishiView.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [[[self.tishiView.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] distinctUntilChanged] subscribeNext:^(id x) {
        [self.tishiView removeFromSuperview];
        FaBuModel *model = self.dataArray[indexPath.row];
        WoDeModel *mine = [WoDeModel sharedWoDeModel];
        NSDictionary *dic = @{@"uid":mine.user_id,@"handle":@(3),@"id":model.ldr_id};
        
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KSendlogisticrequire_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            if ([data[@"status_code"] integerValue] == 10000) {
                //删除成功
                [self.dataArray removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self.tableView reloadData];
                
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                
                
            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
                
            }
            
            
        } isWithSign:YES];
        
        
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FaBuModel *model = self.dataArray[indexPath.row];
    YLFaBuDetailController *dvc = [[YLFaBuDetailController alloc]init];
    dvc.fabuModel = model;
    [self.navigationController pushViewController:dvc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return SCREEN_HEIGHT * 0.23;
}

@end
