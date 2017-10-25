//
//  YLMessageCell.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/7/28.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLMessageCell : UITableViewCell
/**
 左侧图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftIv;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *rightiv;

@property (weak, nonatomic) IBOutlet UIButton *messageBtn;


@property(nonatomic,assign)int messgeCount;

@end
