//
//  WoDeModel.h
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/21.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoDeModel : NSObject

//用户单例
singleton_interface(WoDeModel)

/*****用户信息id*/
@property(nonatomic,strong)NSString * user_id;
/*****用户手机号*/
@property(nonatomic,strong)NSString * user_phone;
/*****用户认证状态*/
@property(nonatomic,assign)NSString *ld_auth_state;
/*****用户头像*/
@property(nonatomic,strong)NSString * ld_headurl;
/*****用户名字*/
@property(nonatomic,strong)NSString * ld_realname;

@end
