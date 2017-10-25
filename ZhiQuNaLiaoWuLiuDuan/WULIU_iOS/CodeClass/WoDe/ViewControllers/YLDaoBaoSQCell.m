//
//  YLDaoBaoSQCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/26.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLDaoBaoSQCell.h"
@interface YLDaoBaoSQCell()
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

@implementation YLDaoBaoSQCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
  
    self.daiChuLiitem.hidden = YES;
    self.yiWanChengitem.hidden = YES;
}

-(void)setModel:(YLShenQingModel *)model{
    
    _model = model;
#warning 服务端没有返回头像的url
//    NSLog(@"%@",model);
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,@""]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    self.cellNamelabel.text = model.pack_real_name;
    self.startLabel.text = model.start_area;
    self.endLabel.text = model.end_area;
    self.dateLbel.text = [self getdatefromstp:model.plg_estimate_depart_date];
    self.zhongliangLabel.text = model.capacity;
    self.pricelabe.text = model.plg_offer_price;

    if ([model.plg_apply_state isEqualToString:@"0"]) {
        
        self.statusLabel.text = @"待处理";
        self.daiChuLiitem.hidden = NO;
        
    }else if ([model.plg_apply_state isEqualToString:@"1"]){
        
        self.statusLabel.text = @"已完成";
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_jujue"];
        self.yiWanChengitem.hidden = NO;
        
    }else if ([model.plg_apply_state isEqualToString:@"2"]){
        
        self.statusLabel.text = @"已完成";
         self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_agree"];
        self.yiWanChengitem.hidden = NO;
        
    }else if ([model.plg_apply_state isEqualToString:@"3"]){
        
        self.statusLabel.text = @"已完成";
         self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_yizuofei"];
        self.yiWanChengitem.hidden = NO;
        
    }else{
        
        self.statusLabel.text = @"已完成";
         self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"wuliushenqing_yizuofei"];
        self.yiWanChengitem.hidden = NO;
        
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

@end
