//
//  YLmessageTypeOneCell.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/9/13.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLmessageTypeOneCell.h"

@interface YLmessageTypeOneCell ()
@property (weak, nonatomic) IBOutlet UIView *stateView;

@end

@implementation YLmessageTypeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.stateView.layer.cornerRadius = 5;
    self.stateView.layer.masksToBounds = YES;
    self.stateView.hidden = YES;
}

-(void)setModel:(YLMessageModel *)model{
    
    _model = model;
    
    
    if (model.dlo_content) {
        
        self.detailLabel.text = model.dlo_content;
        
        if ([model.dlo_read_state isEqualToString:@"1"]) {
            
            self.stateView.hidden = YES;
            
        }else{
            self.stateView.hidden = NO;
        }
    
    }else{
        
       self.detailLabel.text = model.dam_content;
        
        if ([model.dam_read_state isEqualToString:@"1"]) {
            
            self.stateView.hidden = YES;
            
        }else{
            
            self.stateView.hidden = NO;
        }
    }
    
    self.timeLabel.text =  [self getdatefromstp:model.updated_at];
}

-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
