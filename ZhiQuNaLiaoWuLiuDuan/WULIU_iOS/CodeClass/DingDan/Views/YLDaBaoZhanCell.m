//
//  YLDaBaoZhanCell.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDaBaoZhanCell.h"

@implementation YLDaBaoZhanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.height/2.0;
}

-(void)setModel:(DingDanListModel *)model {
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,model.pk_headurl]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    self.nameLabel.text = model.pk_real_name;
//    self.fenshulabel.text = [NSString stringWithFormat:@"%@",model.]
    [[[self.lianXiDanBaoZhanBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
