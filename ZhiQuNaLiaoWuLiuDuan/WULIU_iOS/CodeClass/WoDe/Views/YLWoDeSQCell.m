//
//  YLWoDeSQCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLWoDeSQCell.h"
@interface YLWoDeSQCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *cellNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLbel;
@property (weak, nonatomic) IBOutlet UILabel *zhongliangLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabe;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
//待处理item
@property (weak, nonatomic) IBOutlet UIView *daiChuLiitem;
//已完成
@property (weak, nonatomic) IBOutlet UIView *yiWanChengitem;

@end


@implementation YLWoDeSQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.daiChuLiitem.hidden = YES;
    self.yiWanChengitem.hidden = YES;
}

-(void)setModel:(YLShenQingModel *)model{
    
    _model = model;
    
   [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,@""]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    self.cellNamelabel.text = model.pack_real_name;
    self.startLabel.text = model.start_area;
    self.endLabel.text = model.end_area;
    self.dateLbel.text = [self getdatefromstp:model.depart_time];
    self.zhongliangLabel.text = model.capacity;
    self.pricelabe.text = model.dla_offer_price;

    if ([model.dla_apply_state isEqualToString:@"0"]) {

        self.statusLabel.text = @"等待对方处理";
        self.daiChuLiitem.hidden = NO;

    }else if ([model.dla_apply_state isEqualToString:@"1"]){

        self.statusLabel.text = @"已完成";
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_jujue"];
        self.yiWanChengitem.hidden = NO;

    }else if ([model.dla_apply_state isEqualToString:@"2"]){

        self.statusLabel.text = @"已完成";
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_agree"];
        self.yiWanChengitem.hidden = NO;
        self.rerequsetInFinish.hidden = YES;

    }else if ([model.dla_apply_state isEqualToString:@"3"]){

        self.statusLabel.text = @"已完成";
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_yizuofei"];
        self.yiWanChengitem.hidden = NO;

    }else{
        
        self.statusLabel.text = @"已完成";
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_yizuofei"];
        self.yiWanChengitem.hidden = NO;
        self.daiChuLiitem.hidden = YES;
        
    }
}


-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
