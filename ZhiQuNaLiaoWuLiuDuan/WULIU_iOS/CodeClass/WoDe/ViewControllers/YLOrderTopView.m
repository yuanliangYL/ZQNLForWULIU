//
//  YLOrderTopView.m
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/8/1.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLOrderTopView.h"
@interface YLOrderTopView()
//直销按钮
@property(nonatomic,strong)UIButton *zbtn;
//采购按钮
@property(nonatomic,strong)UIButton *cbtn;
@end


@implementation YLOrderTopView

-(instancetype)initWiteFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *contentView = [[UIView alloc]initWithFrame:frame];
        contentView.backgroundColor = [UIColor whiteColor];
        
        self.zbtn = [self renderTitleBtnTitle:@"打包站申请" tag:1 selected:YES frame:CGRectMake(1, 1, contentView.bounds.size.width / 2 - 2, 34) insuperView:contentView];
        [self.zbtn setSetFontByDevice:14];
        
        self.cbtn = [self renderTitleBtnTitle:@"我的申请" tag:2 selected:NO frame:CGRectMake(contentView.bounds.size.width / 2 + 1, 1, contentView.bounds.size.width / 2 - 2, 34) insuperView:contentView];
        [self.cbtn setSetFontByDevice:14];
        
        [contentView addSubview:self.zbtn];
        [contentView addSubview:self.cbtn];
        
        [self addSubview:contentView];

    }
    
    return self;
}


//渲染订单头部视图
-(UIButton *)renderTitleBtnTitle:(NSString *)title tag:(NSInteger)tag selected:(BOOL)selected frame:(CGRect)frame insuperView:(UIView *)superView{
    
    NSLog(@"%@",title);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    btn.tag = tag;
    btn.selected = selected;
    btn.frame = frame;
    //    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:YLNaviColor forState:UIControlStateSelected];
    if (btn.selected) {
        btn.backgroundColor = [UIColor whiteColor];
    }else{
        btn.backgroundColor = YLNaviColor;
    }
    [btn addTarget:self action:@selector(typeSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

/**
 头部点击事件类型
 
 @param btn btn
 */
-(void)typeSelected:(UIButton *)btn{
    
    if (btn.tag == 1 ) {
        
        self.cbtn.selected = NO;
        self.cbtn.backgroundColor = YLNaviColor;
        
        self.zbtn.selected = YES;
        self.zbtn.backgroundColor = [UIColor whiteColor];
        
    }
    if (btn.tag == 2) {
        
        self.cbtn.selected = YES;
        self.cbtn.backgroundColor = [UIColor whiteColor];
        
        self.zbtn.selected = NO;
        self.zbtn.backgroundColor = YLNaviColor;
    }
    
    self.block(btn.tag);
}

@end
