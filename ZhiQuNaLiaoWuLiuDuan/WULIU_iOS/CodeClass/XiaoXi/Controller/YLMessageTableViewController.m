//
//  YLMessageTableViewController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/7/28.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLMessageTableViewController.h"
#import "YLMessageCell.h"
#import "YLMessageListController.h"

@interface YLMessageTableViewController ()

@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)NSString *ordercount;
@property(nonatomic,strong)NSString *wuliucount;
@property(nonatomic,strong)NSString *gerencount;
@property(nonatomic,strong)NSString *systemcount;
@end

static NSString *cellIndentifier = @"messagecell";

@implementation YLMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载视图
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self setupNavi];
    
    [self setUItableView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self initData];
    
}

-(void)initData{
    
    NSDictionary *dic =@{@"uid":[WoDeModel sharedWoDeModel].user_id,
                         @"handle":@(5),
                         };
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KDrivergetNews withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {

        NSLog(@"%@",data);

        if (data && [data [@"status_code"] integerValue] == 10000) {

            self.ordercount = data[@"wuliu_order_msg"];

            self.wuliucount = data[@"wuliu_apply_msg"];

            self.gerencount = data[@"personal_msg"];

            self.systemcount = data[@"system_msg"];

        }else{

            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];

        }

        [self.tableView reloadData];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } isWithSign:YES];
}



-(void)setupNavi{
    
    self.title = @"消息中心";

}

//返回按钮
-(void)backAction:(UIBarButtonItem* )btn {
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)setUItableView{
    
     [self.tableView registerNib:[UINib nibWithNibName:@"YLMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    
    //隐藏原有的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.scrollEnabled = NO;

}

#pragma mark - lazy
-(NSArray *)items{
    
    if (!_items) {
    
        _items = [[NSMutableArray alloc]init];
        
        //从文件中读取plist文件的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messageItems" ofType:@"plist"];
        
        NSArray * arr = [NSArray arrayWithContentsOfFile:path];
        
        for (NSDictionary *dic in arr) {
            
            [_items addObject:dic];
            
        }
    }
//    NSLog(@"%@",_items);
    return _items;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftIv.image = [UIImage imageNamed:self.items[indexPath.row][@"leftiv"]];
        cell.title.text = self.items[indexPath.row][@"title"];
    
    if (indexPath.row == 0) {
        
        cell.messgeCount = self.ordercount.intValue;
        
    }else if (indexPath.row == 1){
        
        cell.messgeCount = self.wuliucount.intValue;
        
    }else if (indexPath.row == 2){
        
        cell.messgeCount = self.gerencount.intValue;
        
    }else{
        
        cell.messgeCount = self.systemcount.intValue;
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT * 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YLMessageListController *mevc = [YLMessageListController new];
    
    if (0 == indexPath.row) {
        
        mevc.handle = @"2";
       
    }else if (1 == indexPath.row){
        
        mevc.handle = @"1";
        
    }else if (2 == indexPath.row){
        
        mevc.handle = @"3";
        
    }else{

       mevc.handle = @"4";
    }
    
    [self.navigationController pushViewController:mevc animated:YES];
}
@end
