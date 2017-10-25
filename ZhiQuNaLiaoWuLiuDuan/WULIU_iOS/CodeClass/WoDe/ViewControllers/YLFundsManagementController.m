//
//  YLFundsManagementController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLFundsManagementController.h"
#import "YLFundsRecordTableViewController.h"
#import "YLBankCardManageController.h"

@interface YLFundsManagementController ()<YLBankCardManageControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLbale;

@property (weak, nonatomic) IBOutlet UILabel *allmoneylabel;

@property (weak, nonatomic) IBOutlet UILabel *ketixianlabel;

@property (weak, nonatomic) IBOutlet UILabel *tixiangzhonglabel;

@property (weak, nonatomic) IBOutlet UILabel *yitianxianlabel;

@property (weak, nonatomic) IBOutlet UILabel *yihangkehaolabel;

@property (weak, nonatomic) IBOutlet UITextField *jinerTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property(nonatomic,strong)NSString *backID;
@end

@implementation YLFundsManagementController

- (IBAction)bankCardSelected:(UITapGestureRecognizer *)sender {
    
    YLBankCardManageController *bvc = [YLBankCardManageController new];
    bvc.delegate = self;
    bvc.selected = @"yes";
    [self.navigationController pushViewController:bvc animated:YES];
}

#pragma mark - YLBankCardManageControllerDelegate
-(void)didSelectedCaed:(YLbankCardModel *)card{
    
    //NSLog(@"%@",card);
    
    self.yihangkehaolabel.text = card.ldb_bankcard_code;
    
    self.backID = card.ldb_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载视图
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self setNavi];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     [self initData];
}

-(void)setNavi{
    self.title = @"资金管理";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"资金流水" style:UIBarButtonItemStylePlain target:self action:@selector(buyRecord:)];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.nameLbale.text = [NSString stringWithFormat:@"%@的累计收入",[WoDeModel sharedWoDeModel].ld_realname];
    
}

-(void)initData{

    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"handle":@(6)};

    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {

        NSLog(@"资金：%@",data);

        if (data && [data [@"status_code"] integerValue] == 10000) {

            self.ketixianlabel.text = [NSString stringWithFormat:@"%@元",data[@"money_info"][@"has_cashed"]];

            self.tixiangzhonglabel.text = [NSString stringWithFormat:@"%@元",data[@"money_info"][@"is_cashing"]];

            self.yitianxianlabel.text = [NSString stringWithFormat:@"%@元",data[@"money_info"][@"ld_balance"]];

            self.allmoneylabel.text = [NSString stringWithFormat:@"%d元",self.ketixianlabel.text.intValue+self.tixiangzhonglabel.text.intValue+self.yitianxianlabel.text.intValue];

            if (![data[@"bankcard_num"] isEqual:[NSNull null]]) {

                self.yihangkehaolabel.text = data[@"bankcard_num"][@"ldb_bankcard_code"];
                
                self.backID = data[@"bankcard_num"][@"ldb_id"];
                
            }else{
                
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你暂未设置银行卡，无法进行提现操作，确认前往设置！" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    YLBankCardManageController *bvc = [[YLBankCardManageController alloc]init];
                    [self.navigationController pushViewController:bvc animated:YES];
                }]];
               [self presentViewController:alertController animated:YES completion:nil];
                
            }

        }else{

            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } isWithSign:YES];
    
}

- (void)buyRecord:(UIBarButtonItem *)btn{
    
    YLFundsRecordTableViewController *frvc = [[YLFundsRecordTableViewController alloc]init];
    
    [self.navigationController pushViewController:frvc animated:YES];
    
}

// 管理银行卡
- (IBAction)clickAction:(UIButton *)sender {
    
    YLBankCardManageController *bvc = [[YLBankCardManageController alloc]init];
    
    [self.navigationController pushViewController:bvc animated:YES];
}


//发起体现
- (IBAction)StartTixianAction:(UIButton *)sender {
    
    if (self.jinerTF.text.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入提现金额" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    if (self.codeTF.text.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入提现密码" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
//    if (self.backID.length == 0) {
//        [YLMBProgressHUD initWithString:@"请选择提现银行卡" inSuperView:self.view afterDelay:1.5];
//        return;
//    }
    
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(7),
                         @"money":self.jinerTF.text,
                         @"pay_pwd":self.codeTF.text,
                         @"bankcard_id":self.backID,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@----%@",data,error);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提现成功！" preferredStyle:UIAlertControllerStyleAlert];
          
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
           
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
        
    } isWithSign:YES];
    
}

@end

