//
//  YLInfoSelecteCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLInfoSelecteCell.h"

@implementation YLInfoSelecteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.seletedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
}

-(void)setInfoArr:(NSArray *)infoArr{
    _infoArr = infoArr;
    
    self.nameLabel.text = infoArr[0];
    
    [self.seletedBtn setTitle:infoArr[1] forState:UIControlStateNormal];
    
}


-(void)setHaveinfoArr:(NSArray *)haveinfoArr{
    _haveinfoArr = haveinfoArr;
    
    self.seletedBtn.enabled = NO;
    
    self.nameLabel.text = haveinfoArr[0];
    
    [self.seletedBtn setTitle:haveinfoArr[1] forState:UIControlStateNormal];
    [self.seletedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
