//
//  YLNoDataCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/29.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLNoDataCell.h"
@interface YLNoDataCell()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation YLNoDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.bounds = self.window.bounds;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
