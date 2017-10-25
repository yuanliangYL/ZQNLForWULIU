//
//  YLInfoInputCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLInfoInputCell.h"

@interface YLInfoInputCell ()



@end

@implementation YLInfoInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setInfoArr:(NSArray *)infoArr{
    _infoArr = infoArr;
    
    self.nameLabel.text = infoArr[0];
    
    self.InfoTF.placeholder = infoArr[1];
    
}


-(void)setHaveinfoArr:(NSArray *)haveinfoArr{
    _haveinfoArr = haveinfoArr;
    
    self.InfoTF.enabled = NO;
    
    self.nameLabel.text = haveinfoArr[0];
    
    self.InfoTF.text = haveinfoArr[1];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
