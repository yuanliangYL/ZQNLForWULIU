//
//  YLJieDanCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/25.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLJieDanCell.h"

@implementation YLJieDanCell{
    __weak IBOutlet UIImageView *headerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *qujianLabel;
    __weak IBOutlet UILabel *zhongliangLabel;
    __weak IBOutlet UILabel *riqiLabel;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = headerImageView.height/2.0;
}
- (void)setZhixiaoModel:(JieDanModel *)zhixiaoModel {
    _zhixiaoModel = zhixiaoModel;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,zhixiaoModel.pack_logo]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    nameLabel.text = zhixiaoModel.pack_name;
    
//    qujianLabel.text = [NSString stringWithFormat:@"%@%@%@%@-%@%@%@%@",zhixiaoModel.so_send_province,zhixiaoModel.so_send_city,zhixiaoModel.so_send_dist,zhixiaoModel.so_send_address,zhixiaoModel.so_take_province,zhixiaoModel.so_take_city,zhixiaoModel.so_take_dist,zhixiaoModel.so_take_address];
    qujianLabel.text = [NSString stringWithFormat:@"%@-%@",zhixiaoModel.so_send_city,zhixiaoModel.so_take_city];
    
    zhongliangLabel.text = [NSString stringWithFormat:@"%.2f吨",[zhixiaoModel.paper_estimate_num floatValue]];
    
    riqiLabel.text = [self getdatefromstp:zhixiaoModel.pack_send_time];
    [[[self.jieDanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",zhixiaoModel.pack_phone]];
        
        //版本判断，兼容
        if([UIDevice currentDevice].systemVersion.doubleValue >= 10.0){
            
            [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
            
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }

    }];
    
}

-(void)setCaigouModel:(CaiGouModel *)caigouModel {
    _caigouModel = caigouModel;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,caigouModel.pack_logo]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    nameLabel.text = caigouModel.pack_name;
    qujianLabel.text = [NSString stringWithFormat:@"%@-%@",caigouModel.pod_send_city,caigouModel.pod_take_city];
    
    zhongliangLabel.text = [NSString stringWithFormat:@"%.2f吨",[caigouModel.paper_estimate_num floatValue]];
    
    [[[self.jieDanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",caigouModel.pack_phone]];
        
        //版本判断，兼容
        if([UIDevice currentDevice].systemVersion.doubleValue >= 10.0){
            
            [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
            
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }];
    
    riqiLabel.text = [self getdatefromstp:caigouModel.pack_send_time];
}

-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
