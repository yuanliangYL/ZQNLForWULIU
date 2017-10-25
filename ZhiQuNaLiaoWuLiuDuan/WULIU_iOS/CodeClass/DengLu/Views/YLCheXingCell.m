//
//  YLCheXingCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLCheXingCell.h"

@implementation YLCheXingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YLCheXingModel *)model{
    
    _model = model;
    
    self.image.image = [UIImage imageNamed:model.imageName];
    
    [self.name setTitle:model.name forState:UIControlStateNormal];

}
@end
