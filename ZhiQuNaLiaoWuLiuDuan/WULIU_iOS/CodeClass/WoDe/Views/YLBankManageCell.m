//
//  YLBankManageCell.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/4.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLBankManageCell.h"

@interface YLBankManageCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLbale;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@end

@implementation YLBankManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(YLbankCardModel *)model{
    _model = model;
    
    self.nameLbale.text = model.ldb_bank;
    
    self.numberLabel.text = model.ldb_bankcard_code;
    
    if ([model.ldb_is_default isEqualToString:@"0"]) {
        
        self.defaultBtn.selected = NO;
        
    }else{
        self.defaultBtn.selected = YES;
        
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
