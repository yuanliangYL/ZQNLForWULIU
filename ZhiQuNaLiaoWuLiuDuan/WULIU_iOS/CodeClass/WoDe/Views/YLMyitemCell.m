//
//  YLMyitemCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLMyitemCell.h"
@interface YLMyitemCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *itemName;

@end
@implementation YLMyitemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItemArr:(NSArray *)itemArr{
    _itemArr = itemArr;
    
    self.iconImg.image = [UIImage imageNamed:itemArr[0]];
    self.itemName.text = itemArr[1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
