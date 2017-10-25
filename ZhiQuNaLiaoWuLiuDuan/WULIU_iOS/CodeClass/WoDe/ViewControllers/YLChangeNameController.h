//
//  YLChangeNameController.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/1.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLBaseViewController.h"
@class YLChangeNameController;


@protocol YLChangeNameControllerDelegate <NSObject>

-(void)didChangeName:(NSString *)newName;

@end




@interface YLChangeNameController : WLBaseViewController

@property(nonatomic,strong) id <YLChangeNameControllerDelegate> delegate;

@end
