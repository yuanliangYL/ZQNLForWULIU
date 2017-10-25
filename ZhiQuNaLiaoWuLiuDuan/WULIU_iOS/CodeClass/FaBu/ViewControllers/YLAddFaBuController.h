//
//  YLAddFaBuController.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"
#import "FaBuModel.h"

@interface YLAddFaBuController : WLBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@property (weak, nonatomic) IBOutlet UILabel *stopLabel;

//日期btn
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

@property (weak, nonatomic) IBOutlet UITextField *zhongliangTF;

@property (nonatomic, strong) FaBuModel *model;

@property(nonatomic,strong)NSString *pagesouce;

@end
