//
//  YLCustomerServices.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/7.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLCustomerServices.h"

@implementation YLCustomerServices

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height * 0.2)];
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtn setImage:[UIImage imageNamed:@"daohang_close"] forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:closebtn];
        [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(topView.mas_centerY);
            make.right.equalTo(topView.mas_right).offset(-10);
            
        }];
        
        
        UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height * 0.2, self.width, self.height * 0.4)];
        
        NSArray * itemArr = [NSArray arrayWithObjects:@"40069999990", @"客服热线： 工作日9:00-20:00",nil];
        
        for (int i = 0; i < itemArr.count; i ++) {
            
            UIView * itemView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height * 0.2 * i, self.width, self.height * 0.2)];
            
            UILabel *itemlabel = [[UILabel alloc]init];
            [itemlabel setSetFontByDevice:15];
            [itemlabel sizeToFit];
            itemlabel.text = itemArr[i];
            if (i == 0) {
                itemlabel.textColor = [UIColor yl_toUIColorByStr:@"#ff5000"];
                itemlabel.font = [UIFont adjustFont:[UIFont fontWithName:FontType size:16]];
            }else{
                itemlabel.textColor = [UIColor yl_toUIColorByStr:@"#666666"];
                itemlabel.font = [UIFont adjustFont:[UIFont fontWithName:FontType size:15]];
            }
            [itemView addSubview:itemlabel];
            
            [itemlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(itemView.mas_centerY);
                make.centerX.equalTo(itemView.mas_centerX);
            }];
            
            [centerView addSubview:itemView];
        }
        
        
        UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height * 0.6, self.width, self.height * 0.4)];
        
        UIButton *closeConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeConfirm setTitle:@"取消" forState:UIControlStateNormal];
        [closeConfirm setTintColor:[UIColor whiteColor]];
        [closeConfirm setBackgroundImage:[UIImage imageNamed:@"tanchaung_btn_n"] forState:UIControlStateNormal];
        [closeConfirm addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [closeConfirm setSetFontByDevice:15];
        [closeConfirm sizeToFit];
        [bottonView addSubview:closeConfirm];
        [closeConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottonView.mas_centerY);
            make.left.equalTo(bottonView.mas_left).offset(20);
            make.width.mas_equalTo(self.width * 0.4);
        }];
        
        UIButton *callphone = [UIButton buttonWithType:UIButtonTypeCustom];
        [callphone setTitle:@"拨打电话" forState:UIControlStateNormal];
        [callphone setTintColor:[UIColor whiteColor]];
        [callphone setBackgroundImage:[UIImage imageNamed:@"tanchaung_btn_p"] forState:UIControlStateNormal];
        [callphone addTarget:self action:@selector(callPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [callphone sizeToFit];
        [bottonView addSubview:callphone];
        [callphone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottonView.mas_centerY);
            make.right.equalTo(bottonView.mas_right).offset(-20);
            make.width.mas_equalTo(self.width * 0.4);
        }];
        
    
        [self addSubview:topView];
        [self addSubview:centerView];
        [self addSubview:bottonView];
    }
    
    return self;
}

//关闭
-(void)closeAction:(UIButton *)btn{
    
    self.closeblock();
    
}

//拨打电话
-(void)callPhoneAction:(UIButton *)btn{
    
    self.callphoneblock();
    
}
@end
