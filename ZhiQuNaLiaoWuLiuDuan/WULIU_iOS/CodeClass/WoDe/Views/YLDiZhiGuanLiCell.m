//
//  YLDiZhiGuanLiCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDiZhiGuanLiCell.h"

@implementation YLDiZhiGuanLiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YLAddressModal *)model{
    _model = model;
    
    self.adressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.lda_province,model.lda_city,model.lda_dist];

   
    self.defaultBtn.selected = model.lda_is_default;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
