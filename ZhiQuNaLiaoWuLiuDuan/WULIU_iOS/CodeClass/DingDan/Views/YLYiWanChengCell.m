//
//  YLYiWanChengCell.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLYiWanChengCell.h"

@implementation YLYiWanChengCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(DingDanListModel *)model {
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
