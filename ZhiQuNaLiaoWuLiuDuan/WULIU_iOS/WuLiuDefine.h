//
//  WuLiuDefine.h
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#ifndef WuLiuDefine_h
#define WuLiuDefine_h
//设备尺寸
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//适配计算宽高
#define MLWidth    SCREEN_WIDTH / 375.0f
#define MLHeight   SCREEN_HEIGHT / 667.0f
/****判断屏幕尺寸*/
//设计标准
#define inch_47 ([[UIScreen mainScreen] bounds].size.height == 667.0f)

#define inch_4 ([[UIScreen mainScreen] bounds].size.height == 568.0f)
#define inch_55 ([[UIScreen mainScreen] bounds].size.height == 736.0f)
// 这里设置iPhone5缩小的字号数
#define inch4_INCREMENT 2
// 这里设置iPhone6Plus放大的字号数（现在是放大3号，也就是iPhone6是15时，iPhone6p上字号为18）
#define inch55_INCREMENT 2

//字体类型
#define FontType  @"PingFangSC-Regular"
//主色调
#define YLNaviColor [UIColor colorWithRed:(70)/255.0 green:(192)/255.0 blue:(27)/255.0 alpha:1.0]


#endif /* WuLiuDefine_h */
