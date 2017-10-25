//
//  YLShenQingDetailController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLShenQingDetailController.h"

@interface YLShenQingDetailController ()<UITextFieldDelegate>
//弹窗视图
@property (strong, nonatomic) UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *qishiLabel;
@property (weak, nonatomic) IBOutlet UILabel *mudiLabel;
@property (weak, nonatomic) IBOutlet UILabel *riqiLabel;
@property (weak, nonatomic) IBOutlet UITextField *zhongliangTF;
@property (weak, nonatomic) IBOutlet UITextField *jiageTF;

@end

@implementation YLShenQingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zhongliangTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.jiageTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.jiageTF.delegate = self;
    self.zhongliangTF.placeholder = [NSString stringWithFormat:@"不能超过%.2f",[self.zhixiaoModel.paper_estimate_num floatValue]];
    self.title = @"商议接单";
    
    [self setValue];
    
}

#pragma mark - UITextFieldDelegatex
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string; {
    
    NSInteger newlength = textField.text.length + string.length - range.length;
 
     return  newlength <= 5;
}

- (void)setValue{
    
    if (self.zhixiaoModel) {
        
        self.qishiLabel.text =[NSString stringWithFormat:@"%@%@%@%@",self.zhixiaoModel.so_send_province,self.zhixiaoModel.so_send_city,self.zhixiaoModel.so_send_dist,self.zhixiaoModel.so_send_address] ;
        self.mudiLabel.text =[NSString stringWithFormat:@"%@%@%@%@",self.zhixiaoModel.so_take_province,self.zhixiaoModel.so_take_city,self.zhixiaoModel.so_take_dist,self.zhixiaoModel.so_take_address];
        self.riqiLabel.text = [self getdatefromstp:self.zhixiaoModel.pack_send_time];
//        self.zhongliangLael.text = [NSString stringWithFormat:@"%@",self.zhixiaoModel.paper_estimate_num];
        
    }
    
    if (self.caigouModel) {
        
        self.qishiLabel.text = self.caigouModel.pod_send_address;
        self.mudiLabel.text = self.caigouModel.pod_take_address;
        self.riqiLabel.text = [self getdatefromstp:self.caigouModel.pack_send_time];
//        self.zhongliangLael.text = [NSString stringWithFormat:@"%@",self.caigouModel.paper_estimate_num];
    }
   
    if (self.shenQingModel) {
        
        self.qishiLabel.text = self.shenQingModel.start_area;
        
        self.mudiLabel.text = self.shenQingModel.end_area;
        
        self.riqiLabel.text = [self getdatefromstp:self.shenQingModel.depart_time];
        
//        self.zhongliangLael.text = [NSString stringWithFormat:@"%@",self.shenQingModel.capacity];
    }
    
    NSLog(@"A%@-- B%@ -- C%@",self.zhixiaoModel,self.caigouModel,self.shenQingModel);
    
}
-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}

- (IBAction)confirmBtn:(UIButton *)sender {

    if (self.shenQingModel) {
        
        [self rerequst];
        
        
    }else if(self.zhixiaoModel){
        if (_zhongliangTF.text.length==0) {
            [YLMBProgressHUD initWithString:@"请输入重量" inSuperView:self.view afterDelay:2];
            return;
        }
       NSString *str = [NSString stringWithFormat:@"%.2f",[_zhongliangTF.text floatValue]];
        
        if (_zhongliangTF.text.length>0&&[str floatValue] > [self.zhixiaoModel.paper_estimate_num floatValue]) {
            [YLMBProgressHUD initWithString:@"重量超出，请重新输入" inSuperView:self.view afterDelay:2];
            return;
        }
        if (_jiageTF.text.length==0) {
            [YLMBProgressHUD initWithString:@"请输入价格" inSuperView:self.view afterDelay:2];
            return;
        }
        WoDeModel *mine = [WoDeModel sharedWoDeModel];
        NSDictionary *dic  = @{@"uid":mine.user_id,@"pack_id":self.zhixiaoModel.pack_id,@"order_id":self.zhixiaoModel.so_id,@"pack_real_name":self.zhixiaoModel.pack_name,@"start_area":self.zhixiaoModel.so_send_address,@"end_area":self.zhixiaoModel.so_take_address,@"depart_time":self.zhixiaoModel.pack_send_time,@"capacity":self.zhongliangTF.text,@"dla_offer_price":self.jiageTF.text,@"order_type":@(1),@"pack_phone":self.zhixiaoModel.pack_phone};
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KDriverordertaking_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",data);
            if ([data[@"status_code"] integerValue] == 10000) {
                _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35)];
                _contentView.layer.cornerRadius = 5;
                _contentView.layer.masksToBounds = YES;
                _contentView.backgroundColor = [UIColor whiteColor];
                
                UIView *passChangeView = [[NSBundle mainBundle] loadNibNamed:@"JieDanSuccessView" owner:nil options:nil].lastObject;
                passChangeView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35);
                [_contentView addSubview:passChangeView];
                
                
                [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
                
                [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
                
                [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:NO];
                [self closeAndBack];
                
            }else{
                
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
            }
        } isWithSign:YES];
        
    }else {
        if (_zhongliangTF.text.length==0) {
            [YLMBProgressHUD initWithString:@"请输入重量" inSuperView:self.view afterDelay:2];
            return;
        }
        if (_zhongliangTF.text.length>0||[_zhongliangTF.text floatValue] > [self.caigouModel.paper_estimate_num floatValue]) {
            [YLMBProgressHUD initWithString:@"重量超出，请重新输入" inSuperView:self.view afterDelay:2];
            return;
        }
        if (_jiageTF.text.length==0) {
            [YLMBProgressHUD initWithString:@"请输入价格" inSuperView:self.view afterDelay:2];
            return;
        }
        WoDeModel *mine = [WoDeModel sharedWoDeModel];
        NSDictionary *dic  = @{@"uid":mine.user_id,@"pack_id":self.caigouModel.pack_id,@"order_id":self.caigouModel.pod_id,@"pack_real_name":self.caigouModel.pack_name,@"pack_phone":self.caigouModel.pack_phone,@"start_area":self.caigouModel.pod_send_address,@"end_area":self.caigouModel.pod_take_address,@"depart_time":self.caigouModel.pack_send_time,@"capacity":self.zhongliangTF.text,@"dla_offer_price":self.jiageTF.text,@"order_type":@(1)};
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KDriverordertaking_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",data);
            if ([data[@"status_code"] integerValue] == 10000) {
                _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35)];
                _contentView.layer.cornerRadius = 5;
                _contentView.layer.masksToBounds = YES;
                _contentView.backgroundColor = [UIColor whiteColor];
                
                UIView *passChangeView = [[NSBundle mainBundle] loadNibNamed:@"JieDanSuccessView" owner:nil options:nil].lastObject;
                passChangeView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.75, SCREEN_HEIGHT * 0.35);
                [_contentView addSubview:passChangeView];
                
                
                [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
                
                [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
                
                [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:NO];
                [self closeAndBack];
                
            }
        } isWithSign:YES];
    }
    
}

- (void)closeAndBack {
    
    //避免循环强引用
    __weak typeof(self) weakSelf = self;
    
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    
        
    }];
}


/***********************物流申请中我的申请状态未回应时的重新申请*****************************************/
-(void)rerequst{
   
    if (self.jiageTF.text.length > 0) {
        NSDictionary *dic =@{
                             @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                             @"handle":@(1),
                             @"slug":@(5),
                             @"id":self.shenQingModel.dla_id,
                             @"money":self.jiageTF.text,
                             @"capacity":self.shenQingModel.capacity,
                             @"pack_id":self.shenQingModel.pack_id,
                             };
        
        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@",data);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                [YLMBProgressHUD initWithString:@"重新申请已提交" inSuperView:self.view afterDelay:1.5];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
            }
            
        } isWithSign:YES];
        
    }else{
        
        [YLMBProgressHUD initWithString:@"请输入重新申请的价格" inSuperView:self.view afterDelay:1];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
