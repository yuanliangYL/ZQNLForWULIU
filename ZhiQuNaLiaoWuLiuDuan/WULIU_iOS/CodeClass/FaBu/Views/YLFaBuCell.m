//
//  YLFaBuCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLFaBuCell.h"

@implementation YLFaBuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(FaBuModel *)model{
    _model = model;
    
    self.qujianLabel.text = [NSString stringWithFormat:@"%@-%@",model.depart_address,model.dest_address];
    
    self.riqiLabel.text = model.ldr_can_tack_date;
    
    self.zhongliangLabel.text = [NSString stringWithFormat:@"%.2f",[model.ldr_capacity floatValue]];
//    
//    NSLog(@"%s",model.hadBeenReceive ? "YES" : "NO");
    
    //状态显示
//    self.image.hidden = !model.hadBeenReceive;
    self.image.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
