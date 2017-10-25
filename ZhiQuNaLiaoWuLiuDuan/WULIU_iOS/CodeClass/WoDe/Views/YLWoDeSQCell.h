//
//  YLWoDeSQCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLShenQingModel.h"
@interface YLWoDeSQCell : UITableViewCell
@property(nonatomic,strong)YLShenQingModel *model;

@property (weak, nonatomic) IBOutlet UIButton *rerequst;

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *rerequsetInFinish;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end
