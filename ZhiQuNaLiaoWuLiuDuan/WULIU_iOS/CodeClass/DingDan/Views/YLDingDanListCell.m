//
//  YLDingDanListCell.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDingDanListCell.h"
#import "DingDanListModel.h"

@interface YLDingDanListCell ()

@end

@implementation YLDingDanListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(DingDanListModel *)model {
    _model = model;
    if ([model.plor_order_state integerValue] == 1 ) {
        self.statusLabel.text = @"待提货";
    }else if ([model.plor_order_state integerValue] == 2) {
        self.statusLabel.text = @"待收货";
    }else {
        self.statusLabel.text = @"已完成";
    }
    self.qujianLabel.text = [NSString stringWithFormat:@"%@-%@",model.plor_send_address,model.plor_take_address];
    self.zhongliangLabel.text = [NSString stringWithFormat:@"%.2f吨",[model.plor_weight floatValue]];
    self.baojiaLabel.text = [NSString stringWithFormat:@"%.2f元",[model.plor_total floatValue] ];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,model.pk_headurl]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    self.nameLabel.text = model.pk_real_name;
    self.riqiLabel.text = [self getdatefromstp:model.plor_send_date];
    [[[self.quxiaoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil: self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        WoDeModel *wode = [WoDeModel sharedWoDeModel];
        NSDictionary *dic = @{@"uid":wode.user_id,@"plor_id":model.plor_id};
        [SD_NetAPIClient_CONFIG requestJsonDataWithPath:KDriversuretotake withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            if ([data[@"status_code"] integerValue] ==10000) {
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self afterDelay:1.5];
            }else {
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self afterDelay:1.5];
            }
            
        } isWithSign:YES];
    }];
    [[[self.LianXiDaBaoZhanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",model.pk_phone]];
        
        //版本判断，兼容
        if([UIDevice currentDevice].systemVersion.doubleValue >= 10.0){
            
            [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
            
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }];
    
}
-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}

@end
