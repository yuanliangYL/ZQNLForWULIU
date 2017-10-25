//
//  YLMessageModel.h
//  ZQNLForPackagingStation
//
//  Created by 袁亮 on 2017/9/13.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLMessageModel : NSObject

@property(nonatomic,strong)NSString *updated_at;
@property(nonatomic,strong)NSString *created_at;

//订单消息
@property(nonatomic,strong)NSString *dlo_content;
@property(nonatomic,strong)NSString *dlo_id;
@property(nonatomic,strong)NSString *dlo_read_state;
@property(nonatomic,strong)NSString *dlo_state;
@property(nonatomic,strong)NSString *dlo_title;
@property(nonatomic,strong)NSString *dlo_type;
@property(nonatomic,strong)NSString *driver_id;

//物流消息
@property(nonatomic,strong)NSString *dam_content;
@property(nonatomic,strong)NSString *dam_id;
@property(nonatomic,strong)NSString *dam_read_state;
@property(nonatomic,strong)NSString *dam_title;
@property(nonatomic,strong)NSString *dam_type;
@property(nonatomic,strong)NSString *driver_apply_id;

//个人消息
@property(nonatomic,strong)NSString *dpm_content;
@property(nonatomic,strong)NSString *dpm_id;
@property(nonatomic,strong)NSString *dpm_info;
@property(nonatomic,strong)NSString *dpm_read_state;
@property(nonatomic,strong)NSString *dpm_title;
@property(nonatomic,strong)NSString *dpm_type;
@property(nonatomic,strong)NSString *logistics_order_id;

//系统消息
@property(nonatomic,strong)NSString *sm_content;
@property(nonatomic,strong)NSString *sm_id;
@property(nonatomic,strong)NSString *sm_info;
@property(nonatomic,strong)NSString *sm_slug;
@property(nonatomic,strong)NSString *sm_title;

//created_at" = 1505208259;
//"order_type" = 2;
//"pack_id" = 28;
//"pack_order_id" = 12;
//"po_content" = "\U7f8e\U56fd\U675c\U90a6\U5df2\U652f\U4ed8\U8d27\U6b3e\Uff0c\U8ba2\U5355\U53f7\U4e3aP20170907040433281116230,\U8bf7\U524d\U5f80\U67e5\U770b\U8ba2\U5355\U8be6\U60c5\Uff01";
//"po_id" = 5;
//"po_read_state" = 1;
//"po_state" = 1;
//"po_title" = "\U7eb8\U5382\U652f\U4ed8\U8d27\U6b3e\U6d88\U606f";
//"updated_at" = 1505271109;

@end
