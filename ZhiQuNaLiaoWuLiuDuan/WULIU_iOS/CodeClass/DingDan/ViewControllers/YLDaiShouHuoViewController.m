//
//  YLDaiShouHuoViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDaiShouHuoViewController.h"
#import "YLDaiShouHuoCell.h"
#import "YLDingDanDetailViewController.h"

@interface YLDaiShouHuoViewController ()<UITableViewDataSource,UITableViewDataSource>{
    NSInteger _pageNum;
    NSInteger _size;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation YLDaiShouHuoViewController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLDaiShouHuoCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDaiShouHuoCell class])
     ];
    self.myTableView.separatorColor = [UIColor clearColor];
    
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

}
#pragma mark------刷新请求数据-----------------------
- (void)refreshAllData {
    _pageNum = 0;
    _size = 10;
    //个人信息
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"slug":@(1),@"pageNum":@(_pageNum),@"size":@(_size),@"handle":@(1)};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@%@",data,errorMsg);
        
        NSMutableArray *array = data[@"data"];
        if (data && [data[@"status_code"] integerValue] == 10000) {
            if (_pageNum == 0) {
                [self.dataArray removeAllObjects];
            }
        }
//        for (NSDictionary *dic in array) {
//            ZYZhiXiaoModel *zhixiao = [ZYZhiXiaoModel mj_objectWithKeyValues:dic];
//            [self.dataArray addObject:zhixiao];
//        }
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
        
        
        
    } isWithSign:YES];
}

- (void)refreshAllMoreData{
    ++ _pageNum ;
    _size = 10;
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"slug":@(1),@"pageNum":@(_pageNum),@"size":@(_size),@"handle":@(1)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetlogisticorderlist_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@%@",data,errorMsg);
        NSMutableArray *array = data[@"data"];
        
//        for (NSDictionary *dic in array) {
//            ZYZhiXiaoModel *zhixiao = [ZYZhiXiaoModel mj_objectWithKeyValues:dic];
//            [self.dataArray addObject:zhixiao];
//        }
        [self.myTableView reloadData];
        if (array.count == 0) {
            [self.myTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.myTableView.mj_footer endRefreshing];
        }
    } isWithSign:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 260*MLHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = (YLDaiShouHuoCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDaiShouHuoCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = 0;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLDingDanDetailViewController *detailVC = [[YLDingDanDetailViewController alloc] init];
    detailVC.index = 1;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
