//
//  YLAddBankCardController.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLAddBankCardController.h"

@interface YLAddBankCardController ()
@property (weak, nonatomic) IBOutlet UITextField *ownerTF;

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *ownerPhoneTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property(nonatomic,strong)NSString *code_id;
@end

@implementation YLAddBankCardController

- (IBAction)getCodeAction:(UIButton *)sender {
    
    if (self.ownerPhoneTF.text.length > 0) {
        
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetcode withParams:@{@"nc_phone":self.ownerPhoneTF.text} withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"data%@",data);
            
            NSDictionary *dic = data[@"data"];
            self.code_id = [dic objectForKey:@"code_id"];
            
            [self openCountdown:sender];
            
        } isWithSign:YES];
        
    }else{
        
        [YLMBProgressHUD initWithString:@"请填写手机号" inSuperView:self.view afterDelay:2];
        
    }
    
}

// 开启倒计时效果
-(void)openCountdown:(UIButton *)btn{
    
    __block NSInteger time = 59;
    //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer); dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#ff5000"] forState:UIControlStateNormal];
                
                btn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            
            dispatch_async(dispatch_get_main_queue(), ^{
        
                //设置按钮显示读秒效果
                [btn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                
                [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
                
                btn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //用户手机号
    self.ownerPhoneTF.text = [WoDeModel sharedWoDeModel].user_phone;
    
    if ([self.actionType isEqual: @"add"]) {
        
        self.title = @"添加银行卡";
        
    }else{
        
        self.title = @"编辑银行卡";
        
        self.ownerTF.text = self.cardOwner;
        
        self.cardNumberTF.text = self.cardNumber;
        
        self.bankNameTF.text = self.cardName;
    
    }
    
}

- (IBAction)commiteDataAction:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.ownerTF.text.length > 0 && self.cardNumberTF.text.length > 0 && self.bankNameTF.text.length > 0 && self.ownerPhoneTF.text.length > 0 ) {
        
        if ([self.actionType isEqual: @"add"]) {
            
            NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                                 @"handle":@(2),
                                 @"default":@(0),
                                 @"cardholder":self.ownerTF.text,
                                 @"bankcard_code":self.cardNumberTF.text,
                                 @"bank":self.bankNameTF.text,
                                 @"phone":self.ownerPhoneTF.text
                                 };
            
            [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                
                NSLog(@"%@----%@",data[@"data"],error);
                
                if (data && [data [@"status_code"] integerValue] == 10000) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    //提示框
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } isWithSign:YES];
            
            
        }else{
            
            NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                                 @"handle":@(5),
                                 @"default":self.isdefault,
                                 @"cardholder":self.ownerTF.text,
                                 @"bankcard_code":self.cardNumberTF.text,
                                 @"bank":self.bankNameTF.text,
                                 @"phone":self.ownerPhoneTF.text,
                                 @"id":self.cardid
                                 };
            
            [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KFundManage_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                
                NSLog(@"%@----%@",data[@"data"],error);
                
                if (data && [data [@"status_code"] integerValue] == 10000) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    //提示框
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } isWithSign:YES];
            
        }
    }else{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [YLMBProgressHUD initWithString:@"信息填写不完整" inSuperView:self.view afterDelay:1];
        
    }

}



@end
