//
//  Https.h
//  LOG_iOS
//
//  Created by Miaomiao Dai on 2017/8/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#ifndef Https_h
#define Https_h
/****************网络相关设置*****************/
//主机地址
//#define kBase_URL  @"http://192.168.0.181:8888/"

#define kBase_URL @"https://api.zhiqunale.cn"
#define KGetcode  @"/api/common/getcode"

/*****图片上传*/
#define kLoadupImage_URL   @"https://admin.zhiqunale.cn/index.php?g=Api&m=Img&a=receiveFile"
/*****图片下载*/
#define kDownImage_URL   @"https://admin.zhiqunale.cn/"



/*****注册*/
#define kRegister_URL  @"api/driver/drivertoregister"
/*****登录*/
#define kLogin_URL  @"api/driver/driverlogin"
/*****忘记密码*/
#define KForgetpwd_URL @"api/driver/forgetdriverpassword"

/*****个人信息*/
#define KUserInfo_URL @"api/driver/getandedituserinfo"
/*****地址管理*/
#define KAddress_URL @"api/driver/getandeditaddress"
/*****设置信息*/
#define KSetting_URL @"api/driver/drivertoset"
/*****资金管理*/
#define KFundManage_URL @"api/driver/driverfundmanage"
/*****我的认证*/
#define KConfirm_URL @"api/driver/firstdriverauthentication"
/*****认证车型*/
#define KCarType_URL @"api/driver/getcarcategory"
/*****物流申请*/
#define KLogistics_URL @"api/driver/driverapplylogistics"


/** 订单模块的api接口*/
#define KGetlogisticorderlist_URL @"api/driver/getlogisticorderlist"
/**	发布模块的api接口 */
#define  KSendlogisticrequire_URL @"api/driver/sendlogisticrequire"
/** 获取接单页面*/
#define KGetorderlogisticlist_URL @"api/driver/getorderlogisticlist"
/** 获取物流接单列表记录的详情*/
#define KGetdetailoforderlogistic_URL @"api/driver/getdetailoforderlogistic"
/** 司机接单*/
#define KDriverordertaking_URL @"api/driver/driverordertaking"
/** 确认提货*/
#define KDriversuretotake @"api/driver/driversuretotake"

/** 消息中心*/
#define KDrivergetNews @"api/driver/getnewslist"


#endif /* Https_h */
