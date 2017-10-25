//
//  YLDaoBaoSQCell.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/26.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLShenQingModel.h"

@interface YLDaoBaoSQCell : UITableViewCell

@property(nonatomic,strong)YLShenQingModel *model;

@property (weak, nonatomic) IBOutlet UIButton *aggrenBtn;

@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
