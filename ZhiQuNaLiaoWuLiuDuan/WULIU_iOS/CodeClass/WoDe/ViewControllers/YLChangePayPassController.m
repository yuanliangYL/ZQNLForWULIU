//
//  YLChangePayPassController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/24.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLChangePayPassController.h"
#import "YLSettingController.h"

@interface YLChangePayPassController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topcons;

@property (weak, nonatomic) IBOutlet UITextField *oldpass;

@property (weak, nonatomic) IBOutlet UITextField *Passtf;
@property (weak, nonatomic) IBOutlet UITextField *repasstf;

@end

@implementation YLChangePayPassController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"修改支付密码";
    self.topcons.constant = SCREEN_HEIGHT;
    self.oldpass.secureTextEntry = YES;
    self.Passtf.secureTextEntry = YES;
    self.repasstf.secureTextEntry = YES;
    
    
}
- (IBAction)oldpasscomfirm:(UIButton *)sender {
    if (self.oldpass.text.length > 0) {
        
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"pay_pwd":self.oldpass.text,
                             @"handle":@(2),
                             @"type":@(1),
                             };
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KSetting_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                //变更页面
                [UIView animateWithDuration:1.0 animations:^{
                    self.topcons.constant = 0;
                }];
                
            }else{
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            }
        } isWithSign:YES];
    }else{
        //提示框
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
    }
}


- (IBAction)nextAction:(id)sender {
    
    if (self.Passtf.text.length>0 && self.repasstf.text.length>0) {
        
        NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"first_pay_pwd":self.Passtf.text,
                             @"second_pay_pwd":self.repasstf.text,
                             @"handle":@(5),
                             @"type":@(1)};
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KSetting_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                [self.navigationController popToViewController:self.settingvc animated:YES];
                
            }else{
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            }
            
        } isWithSign:YES];
        
    }else{
        
        //提示框
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1.5];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}



@end
