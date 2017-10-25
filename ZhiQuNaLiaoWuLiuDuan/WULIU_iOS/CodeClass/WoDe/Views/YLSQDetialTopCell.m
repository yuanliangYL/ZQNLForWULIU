//
//  YLSQDetialTopCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLSQDetialTopCell.h"
@interface YLSQDetialTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *stateIcon;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateDetail;
@end

@implementation YLSQDetialTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setState:(NSString *)state{
    _state = state;
    
//    1 ：0:待处理 1：拒绝 2：同意 3:超时4：已取消
//    2:  0:待处理 1：拒绝 2：同意 3:超时4：已取消
    if ([self.SQtype isEqualToString:@"打包站"]) {
        if ([state isEqualToString:@"0"]) {
            
            self.stateIcon.image = [UIImage imageNamed:@"icon_daichuli"];
            self.stateLabel.text = @"待处理";
            self.stateDetail.text = @"信息在2小时内为处理。申请将作废，请及时处理";
            
        }else if ([state isEqualToString:@"1"]) {
            
            self.stateIcon.image = [UIImage imageNamed:@"icon_yijujue"];
            self.stateLabel.text = @"已拒绝";
            self.stateDetail.text = @"您拒绝了对方的物流申请";
            
        }else if ([state isEqualToString:@"2"]) {
            
            self.stateIcon.image = [UIImage imageNamed:@"icon_yiwancheng"];
            self.stateLabel.text = @"已同意";
            self.stateDetail.text = @"您同意了对方的物流申请";
            
        }else{
            
            self.stateIcon.image = [UIImage imageNamed:@"icon_yizuofe"];
            self.stateLabel.text = @"已作废";
            self.stateDetail.text = @"您的物流申请已作废";
            
        }
        
    }else{
        
        if ([state isEqualToString:@"0"]) {

            self.stateIcon.image = [UIImage imageNamed:@"icon_daichuli"];
            self.stateLabel.text = @"等待对方处理";
            self.stateDetail.text = @"信息在2小时内为处理。申请将作废，请及时处理";

        }else if ([state isEqualToString:@"1"]) {

            self.stateIcon.image = [UIImage imageNamed:@"icon_yijujue"];
            self.stateLabel.text = @"已拒绝";
            self.stateDetail.text = @"对方拒绝了您的物流申请";

        }else if ([state isEqualToString:@"2"]) {

            self.stateIcon.image = [UIImage imageNamed:@"icon_yiwancheng"];
            self.stateLabel.text = @"已同意";
            self.stateDetail.text = @"对方同意了您的物流申请";

        }else{

            self.stateIcon.image = [UIImage imageNamed:@"icon_yizuofe"];
            self.stateLabel.text = @"已作废";
            self.stateDetail.text = @"您的物流申请已作废";

        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
