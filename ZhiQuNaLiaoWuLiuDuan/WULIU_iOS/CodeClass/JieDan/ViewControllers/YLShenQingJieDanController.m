//
//  YLShenQingJieDanController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/26.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLShenQingJieDanController.h"
#import "YLShenQingDetailController.h"
#import "YLJiDanDetailModel.h"

@interface YLShenQingJieDanController ()
@property (weak, nonatomic) IBOutlet UILabel *qishiLabel;
@property (weak, nonatomic) IBOutlet UILabel *mudiLabel;
@property (weak, nonatomic) IBOutlet UILabel *riqiLabel;
@property (weak, nonatomic) IBOutlet UITextField *zhongliangTF;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *dizhiLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (nonatomic, strong) YLJiDanDetailModel *detailModel;
@end

@implementation YLShenQingJieDanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageview.layer.masksToBounds = YES;
    self.headerImageview.layer.cornerRadius = self.headerImageview.height/2.0;
    self.zhongliangTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.title = @"申请详情";
    [self requestData];
    [self setValue];
}

- (void)setValue {
    if (self.zhixiaoModel) {
        self.qishiLabel.text =[NSString stringWithFormat:@"%@%@%@%@",self.zhixiaoModel.so_send_province,self.zhixiaoModel.so_send_city,self.zhixiaoModel.so_send_dist,self.zhixiaoModel.so_send_address] ;
        self.mudiLabel.text =[NSString stringWithFormat:@"%@%@%@%@",self.zhixiaoModel.so_take_province,self.zhixiaoModel.so_take_city,self.zhixiaoModel.so_take_dist,self.zhixiaoModel.so_take_address] ;
        self.riqiLabel.text = [self getdatefromstp:self.zhixiaoModel.pack_send_time];
        self.zhongliangTF.text = [NSString stringWithFormat:@"%.2f吨",[self.zhixiaoModel.paper_estimate_num  floatValue]] ;
    }else {
        self.qishiLabel.text = self.caigouModel.pod_send_address;
        self.mudiLabel.text = self.caigouModel.pod_take_address;
        self.riqiLabel.text = [self getdatefromstp:self.caigouModel.pack_send_time];
        self.zhongliangTF.text = [NSString stringWithFormat:@"%.2f吨",[self.caigouModel.paper_estimate_num  floatValue]] ;
    }

}
-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}
- (void)requestData {
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic = nil;
    if (self.zhixiaoModel) {
        dic = @{@"uid":mine.user_id,@"pack_id":self.zhixiaoModel.pack_id};
    }else {
      dic = @{@"uid":mine.user_id,@"pack_id":self.caigouModel.pack_id};
    }
    
    [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KGetdetailoforderlogistic_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"接单详情%@",data);
        if ([data[@"status_code"] integerValue] == 10000) {
            NSDictionary *modeldic = data[@"data"];
            self.detailModel = [YLJiDanDetailModel mj_objectWithKeyValues:modeldic];
            self.nameLabel.text = self.detailModel.pk_real_name;
            self.fenshuLabel.text = [NSString stringWithFormat:@"%.1f分",[self.detailModel.pk_credit_score floatValue]];
            [self.headerImageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@%@",kDownImage_URL,self.detailModel.pk_headurl]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
            self.dizhiLabel.text = self.detailModel.pk_address;
          
            [[self.callBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                
                    NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",self.detailModel.pk_phone]];
                    
                    //版本判断，兼容
                    if([UIDevice currentDevice].systemVersion.doubleValue >= 10.0){
                        
                        [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                        
                    }else{
                        
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }];
            
        }
        
    } isWithSign:YES];
}
- (IBAction)JieDanAction:(UIButton *)sender {
    
    YLShenQingDetailController *svc = [[YLShenQingDetailController alloc]init];
    if (self.zhixiaoModel) {
        svc.zhixiaoModel = self.zhixiaoModel;
    }else {
        svc.caigouModel = self.caigouModel;
    }
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
