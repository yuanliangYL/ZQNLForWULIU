//
//  YLWoDeRenZhengController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/31.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLWoDeRenZhengController.h"
#import "YLCheZhuController.h"
#import "YLCheZhuController.h"
#import "YLCheLiangController.h"
#import "YLBaoXianController.h"

#import "YLRenZhengList.h"

@interface YLWoDeRenZhengController ()
@property (weak, nonatomic) IBOutlet UILabel *stateone;
@property (weak, nonatomic) IBOutlet UILabel *stateTwo;
@property (weak, nonatomic) IBOutlet UILabel *stateThree;

@property(nonatomic,strong)YLMBProgressHUD *hud;

@property(nonatomic,strong)NSString *statestr;

@property(nonatomic,strong)YLJiaShiZhengList *jiashidata;
@property(nonatomic,strong)YLXingShiZhengList *xingshidata;
@property(nonatomic,strong)YLBaoXianZhengList *baoxiandata;

@end

@implementation YLWoDeRenZhengController

-(YLMBProgressHUD *)hud{
    if (!_hud) {
        _hud = [YLMBProgressHUD initProgressInViewbystateShow:self.view];
    }
    return _hud;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.hud show:YES];
    //已经认证
    [self initRenZhengList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的认证";
 
}

//获取认证猎豹
-(void)initRenZhengList{
    
    NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),
                         @"type":@(1),
                         @"handle":@(2),
                         };
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KConfirm_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@%@---%@",data,error,data[@"authentication_status"]);
        
        //记录登陆状态
        self.statestr = data[@"authentication_status"];
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            if ( [data[@"data"][@"authentication_status"] integerValue] == 1) {
                //全部信息通过审核
                self.stateone.text = @"已通过认证";
                self.stateTwo.text = @"已通过认证";
                self.stateThree.text = @"已通过认证";
            }else{
                //存在未审核的信息(某一项)
                if (![data[@"data"][@"0"][@"ld_licence_number"] isEqual:[NSNull null]] ) {
                    self.stateone.text = @"信息提交认证中";
                }else{
                    self.stateone.text = @"认证信息未通过";
                }
                
                if (![data[@"data"][@"1"][@"ld_licence_plate"] isEqual:[NSNull null]] ) {
                    self.stateTwo.text = @"信息提交认证中";
                }else{
                    self.stateTwo.text = @"认证信息未通过";
                }
                
                if (![data[@"data"][@"2"][@"ld_policy_number"] isEqual:[NSNull null]] ) {
                     self.stateThree.text = @"信息提交认证中";
                }else{
                     self.stateThree.text = @"认证信息未通过";
                }
            }
            
            self.jiashidata = [YLJiaShiZhengList mj_objectWithKeyValues:data[@"data"][@"0"]];
        
            self.xingshidata = [YLXingShiZhengList mj_objectWithKeyValues:data[@"data"][@"1"]];
            
            self.baoxiandata = [YLBaoXianZhengList mj_objectWithKeyValues:data[@"data"][@"2"]];
            
            
            
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
        }
        [self.hud hide:YES];
        
    } isWithSign:YES];
}

//驾驶证认证
- (IBAction)jiashizheng:(UITapGestureRecognizer *)sender {
    
    YLCheZhuController *vc = [YLCheZhuController new];
    //认证状态
    if (self.jiashidata.ld_licence_number) {
        vc.model = self.jiashidata;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

//行驶证认证
- (IBAction)xingshizheng:(UITapGestureRecognizer *)sender {
    
    
    YLCheLiangController *vc =  [YLCheLiangController new];
    //认证状态
    if (self.xingshidata.ld_licence_plate) {
        vc.model = self.xingshidata;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//保险认证
- (IBAction)baodang:(UITapGestureRecognizer *)sender {
    
    
    YLBaoXianController *vc =  [YLBaoXianController new];
    //认证状态
    if (self.baoxiandata.ld_policy_number) {
        vc.model = self.baoxiandata;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
