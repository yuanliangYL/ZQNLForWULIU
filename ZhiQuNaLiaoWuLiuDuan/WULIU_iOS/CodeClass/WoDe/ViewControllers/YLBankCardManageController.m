//
//  YLBankCardManageController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLBankCardManageController.h"
#import "YLBankManageCell.h"
#import "YLAddBankCardController.h"
#import "YLbankCardModel.h"

@interface YLBankCardManageController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)YLMBProgressHUD *hud;

@property(nonatomic,strong)NSMutableArray <YLbankCardModel *>* model;

@end

static int pageNum = 0;
static int size = 50;
@implementation YLBankCardManageController

-(YLMBProgressHUD *)hud{
    if (!_hud) {
        _hud = [YLMBProgressHUD initProgressInViewbystateShow:self.tableView];
    }
    return  _hud;
}

-(void)viewWillAppear:(BOOL)animated{
    
     [self initdata];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self setupNaviAndUI];
    
    [self.hud show:YES];
}

-(void)initdata{
    
    
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(1),
                         @"size":@(size),
                         @"pagenum":@(pageNum)
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@----%@",data,error);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            self.model  = [YLbankCardModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
        
        [self.tableView reloadData];
        [self.hud hide:YES];
    } isWithSign:YES];
}


-(void)setupNaviAndUI{
    
    self.title = @"管理银行卡";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLBankManageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLBankManageCell class])];
    self.tableView .bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //取消cell中的线
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLBankManageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLBankManageCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model[indexPath.row];

    
    [[[cell.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
        
        YLAddBankCardController *vc = [YLAddBankCardController new];
        vc.actionType = @"edit";
        vc.cardName = self.model[indexPath.row].ldb_bank;
        vc.cardOwner = self.model[indexPath.row].ldb_cardholder;
        vc.cardNumber = self.model[indexPath.row].ldb_bankcard_code;
        vc.isdefault = self.model[indexPath.row].ldb_is_default;
        vc.cardid = self.model[indexPath.row].ldb_id;
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    [[[cell.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
        [self deleteAction:indexPath];
    }];
    
    [[[cell.defaultBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
        [self defaultActin:indexPath];
    }];
    
    
    return cell;
}

-(void)defaultActin:(NSIndexPath *)index{
    
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(4),
                         @"id":self.model[index.row].ldb_id
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@----%@",data,error);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            for (int i = 0; i < self.model.count; i ++) {
                
                if ([self.model[i].ldb_is_default isEqualToString:@"1"]) {
                    
                    self.model[i].ldb_is_default = @"0";
                }
            }
            self.model[index.row].ldb_is_default = @"1";
            
            [self.tableView reloadData];
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
        
        [self.tableView reloadData];
        [self.hud hide:YES];
    } isWithSign:YES];
}

-(void)deleteAction:(NSIndexPath *)index{
    
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(3),
                         @"id":self.model[index.row].ldb_id
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@----%@",data,error);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            [self.model removeObjectAtIndex:index.row];
            
            [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView reloadData];
            
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
        
        [self.tableView reloadData];
        [self.hud hide:YES];
    } isWithSign:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT * 0.2;
}
- (IBAction)ChangeBankCardInfo:(UIButton *)sender {
    
    YLAddBankCardController *addvc = [[YLAddBankCardController alloc]init];
    addvc.actionType = @"add";
    
    [self.navigationController pushViewController:addvc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.selected isEqualToString:@"yes"]) {
        
        [self.delegate didSelectedCaed:self.model[indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
