//
//  YLTopPromptCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLTopPromptCell.h"

@interface YLTopPromptCell ()


@end

@implementation YLTopPromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-(void)setInfoArr:(NSArray *)infoArr{
    
    _infoArr = infoArr;
    
    //设置cell的信息
    self.iconImg.image = [UIImage imageNamed:infoArr[0]];
    self.stepLabel.text = infoArr[1];
    self.indecatorLabel.text = infoArr[2];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
