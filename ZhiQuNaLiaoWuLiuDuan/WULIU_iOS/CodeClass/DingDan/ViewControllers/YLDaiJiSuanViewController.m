//
//  YLDaiJiSuanViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDaiJiSuanViewController.h"
//#import "YLDaiJieSuanCell.h"
#import "YLDingDanDetailViewController.h"

@interface YLDaiJiSuanViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _pageNum;
    NSInteger _size;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation YLDaiJiSuanViewController

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
    
    
//    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLDaiJieSuanCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDaiJieSuanCell class])
//     ];
    self.myTableView.separatorColor = [UIColor clearColor];
    
}
#pragma mark------刷新请求数据-----------------------
/*
- (void)refreshAllData {
    _pageNum = 0;
    _size = 10;
    //个人信息
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = @{@"uid":mine.user_id,@"slug":@(self.slug),@"pageNum":@(_pageNum),@"size":@(_size)};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetstraightorder_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@%@",data,errorMsg);
        NSMutableArray *array = data[@"data"];
        if (data && [data[@"status_code"] integerValue] == 10000) {
            if (_pageNum == 0) {
                [self.dataArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in array) {
            ZYZhiXiaoModel *zhixiao = [ZYZhiXiaoModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:zhixiao];
        }
        
        [self.allTableView.mj_header endRefreshing];
        [self.allTableView reloadData];
        
        
        
    } isWithSign:YES];
}

- (void)refreshAllMoreData{
    ++ _pageNum ;
    _size = 10;
    
    NSDictionary *dic = @{@"uid":KUID,@"slug":@(self.slug),@"pageNum":@(_pageNum),@"size":@(_size)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KGetstraightorder_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@%@",data,errorMsg);
        NSMutableArray *array = data[@"data"];
        
        for (NSDictionary *dic in array) {
            ZYZhiXiaoModel *zhixiao = [ZYZhiXiaoModel mj_objectWithKeyValues:dic];
            [self.dataArray addObject:zhixiao];
        }
        [self.allTableView reloadData];
        if (array.count == 0) {
            [self.allTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.allTableView.mj_footer endRefreshing];
        }
    } isWithSign:YES];
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200*MLHeight;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    UITableViewCell *cell = nil;
////    cell = (YLDaiJieSuanCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDaiJieSuanCell class]) forIndexPath:indexPath];
//    
////    cell.selectionStyle = 0;
//    
////    return cell;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLDingDanDetailViewController *detailVC = [[YLDingDanDetailViewController alloc] init];
    detailVC.index = 2;
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
