//
//  YLImageSlecteCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLImageSlecteCell.h"

@implementation YLImageSlecteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.image LFLHeadimageBrowser];
}

-(void)setItemArr:(NSDictionary *)itemArr{
    
    _itemArr = itemArr;
    
    self.image.image = itemArr[@"image"];
        
    self.indecatorLabel.text = itemArr[@"imageLabel"];
   
}

-(void)setHaveinfoArr:(NSDictionary *)haveinfoArr{
    
    _haveinfoArr = haveinfoArr;
    
    self.addBtn.enabled = NO;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,haveinfoArr[@"image"]]]];
    
    self.indecatorLabel.text = haveinfoArr[@"imageLabel"];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
