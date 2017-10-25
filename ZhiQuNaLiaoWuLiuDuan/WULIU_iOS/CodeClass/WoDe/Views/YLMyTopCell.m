//
//  YLMyTopCell.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLMyTopCell.h"

@implementation YLMyTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userImage.layer.cornerRadius = self.userImage.height * 0.5;
    self.userImage.layer.masksToBounds = YES;
    
}


-(void)setModel:(WoDeModel *)model{
    
    _model  =  model;
    
    NSLog(@"%@---%@----%@",model.ld_auth_state,model.ld_realname,model.ld_headurl);
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,model.ld_headurl]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
    //名称
    if (model.ld_realname != NULL) {
        self.nameLabel.text = model.ld_realname;
    }else{
        self.nameLabel.text = @"尚未认证实名";
    }
    
    //认证状态
    NSString *statusStr  = @"";
    if ([model.ld_auth_state isEqualToString:@"0"]){
         statusStr = @"认证失败";
    }else if ([model.ld_auth_state isEqualToString:@"1"]){
         statusStr = @"已实名认证";
    }else{
         statusStr = @"正在认证中...";
    }
    self.renzhengStatus.text = statusStr;
    
    
    //头像
    NSLog(@"------%@-------",model.ld_headurl);
    if (model.ld_headurl != NULL) {
        
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,model.ld_headurl]]];
        NSLog(@"AAAAAAAA%@",[NSString stringWithFormat:@"https://admin.zhiqunale.cn/%@",model.ld_headurl]);
        
    }else{
        
        self.userImage.image = [UIImage imageNamed:@"order_touxiang"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
