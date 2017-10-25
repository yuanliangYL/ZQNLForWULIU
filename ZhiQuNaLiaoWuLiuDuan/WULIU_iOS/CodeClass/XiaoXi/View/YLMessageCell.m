//
//  YLMessageCell.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/7/28.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLMessageCell.h"

@interface YLMessageCell()


@end

@implementation YLMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setMessgeCount:(int)messgeCount{
    _messgeCount = messgeCount;
    
    if (messgeCount == 0) {
        
        self.messageBtn.hidden = YES;
        
    }else{
        
        if (messgeCount < 10) {
            
            [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"message_tishi_s"] forState:UIControlStateNormal];
            [self.messageBtn setTitle:[NSString stringWithFormat:@"%d",messgeCount] forState:UIControlStateNormal];
            
        }else if(messgeCount < 100){
            
            [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"message_tishi_m"] forState:UIControlStateNormal];
            [self.messageBtn setTitle:[NSString stringWithFormat:@"%d",messgeCount] forState:UIControlStateNormal];
            
        }else{
            
            [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"message_tishi_l"] forState:UIControlStateNormal];
            [self.messageBtn setTitle:@"99+" forState:UIControlStateNormal];
            
        }

        self.messageBtn.hidden = NO;
    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
