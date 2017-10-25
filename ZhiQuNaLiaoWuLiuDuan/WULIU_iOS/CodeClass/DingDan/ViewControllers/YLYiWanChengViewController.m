//
//  YLYiWanChengViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLYiWanChengViewController.h"
#import "YLYiWanChengCell.h"
#import "YLDingDanDetailViewController.h"

@interface YLYiWanChengViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation YLYiWanChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLYiWanChengCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLYiWanChengCell class])];
    self.myTableView.separatorColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 260*MLHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = (YLYiWanChengCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLYiWanChengCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = 0;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLDingDanDetailViewController *detailVC = [[YLDingDanDetailViewController alloc] init];
    detailVC.index = 3;
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
