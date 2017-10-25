//
//  YLAddressGuanLiController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLAddressGuanLiController.h"
#import "YLAddressModal.h"
#import "YLDiZhiGuanLiCell.h"
#import "YLAddAddressController.h"

@interface YLAddressGuanLiController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property(strong, nonatomic) UITableView *MyTableView;

@property(nonatomic,strong)NSMutableArray <YLAddressModal * >*addressArr;

@end

static int pageNum = 0;
static int size = 50;

@implementation YLAddressGuanLiController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"管理收货地址";
    
    //加载视图
    [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initData];

}

-(void)setupUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.92 - 64) style:UITableViewStylePlain];
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    self.MyTableView.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
    self.MyTableView.bounces = NO;
    self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.MyTableView.showsVerticalScrollIndicator = NO;
    [self.containerView addSubview:self.MyTableView];
    
    [self.MyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLDiZhiGuanLiCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLDiZhiGuanLiCell class])];
    
}

/**
 初始化数据
 */
-(void)initData{
    
    NSString *uid = [WoDeModel sharedWoDeModel].user_id;
    
    NSDictionary *dic =@{@"uid":uid,@"type":@(1),@"pageNum":@(pageNum),@"size":@(size)};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KAddress_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //地址处理
            self.addressArr = [YLAddressModal  mj_objectArrayWithKeyValuesArray:data[@"data"]];
        
            //调整数组，将默认显示在最前端
            for (int i = 0; i < self.addressArr.count; i ++) {
                
                YLAddressModal *model = self.addressArr[i];
                
                if (model.lda_is_default == 1 && i != 0) {
                    
                    [self.addressArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                }
            }
        
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.containerView afterDelay:2];
            
        }
    
        [self setupUI];
        
        [MBProgressHUD hideHUDForView:self.containerView animated:YES];
        
    } isWithSign:YES];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.addressArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YLDiZhiGuanLiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLDiZhiGuanLiCell class])];
    
    cell.model = self.addressArr[indexPath.row];
    cell.selectionStyle = 0;
    
    //默认
    [[[cell.defaultBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^ (UIButton *x) {
        
        [self changeDefaultAddress:(indexPath)];
        
    }];
    
    //编辑
    [[[cell.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
        
        YLAddAddressController *addvc = [YLAddAddressController new];
        
        addvc.model = self.addressArr[indexPath.row];
        
        [self.navigationController pushViewController:addvc animated:YES];
    }];
    
    
    //删除
    [[[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^ (UIButton *x) {
        
        [self deleteListitemAction:(indexPath)];
    
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT * 0.18;
}

- (IBAction)addNewAction:(id)sender {
    
    YLAddAddressController *addvc = [YLAddAddressController new];
    
    [self.navigationController pushViewController:addvc animated:YES];
}

//删除操作
-(void)deleteListitemAction:(NSIndexPath *)indexPath{
    
    YLAddressModal *model = self.addressArr[indexPath.row];
  
    NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),@"id":@(model.lda_id),@"type":@(3)};
    
    //删除提示
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KAddress_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //删除成功
            [self.addressArr removeObjectAtIndex:indexPath.row];
            
            [self.MyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
            [self.MyTableView reloadData];
      
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.containerView afterDelay:1.5];
        
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
            
        }

    } isWithSign:YES];
    
}

/**
 修改默认地址
 */
-(void)changeDefaultAddress:(NSIndexPath *)indexPath{
    
    YLAddressModal *model = self.addressArr[indexPath.row];
    
    NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),@"id":@(model.lda_id),@"type":@(4)};
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KAddress_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            for (int i = 0; i < self.addressArr.count; i ++) {
               
                if (self.addressArr[i].lda_is_default == 1) {
                    
                    self.addressArr[i].lda_is_default = NO;
                }
                
                self.addressArr[indexPath.row].lda_is_default = YES;
            }
            
            [self.MyTableView reloadData];
            
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.containerView afterDelay:0.8];
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            
        }
        
    } isWithSign:YES];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate didFinishClickAdress:self.addressArr[indexPath.row]];
    
    if ([self.pageSource isEqualToString:@"发布"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
