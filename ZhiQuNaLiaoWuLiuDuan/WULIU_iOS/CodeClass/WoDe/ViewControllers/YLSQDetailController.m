//
//  YLSQDetailController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/9/23.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLSQDetailController.h"

#import "YLSQDetailDabaoZhan.h"
#import "YLSQDetailWoDe.h"
#import "YLSQDetailPackInfo.h"
#import "YLRefuseAndAgreeView.h"
#import "YLCancleActionView.h"

#import "YLSQDetialTopCell.h"
#import "YLSQdaressCell.h"
#import "YLGoodsInfoCell.h"
#import "YLpackInfoCell.h"
@interface YLSQDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)YLMBProgressHUD *hud;

@property(nonatomic,strong)YLSQDetailDabaoZhan *dabaozhanmodel;
@property(nonatomic,strong)YLSQDetailWoDe *wodemodel;
@property(nonatomic,strong)YLSQDetailPackInfo *packmodel;

@property(nonatomic,strong)UITableView *tableview;
@end

@implementation YLSQDetailController

-(YLMBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [YLMBProgressHUD initProgressInViewbystateShow:self.tableview];
    }
    return _hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请详情";
    
    [self setupUI];
    
    [self initData];
}

//拒绝操作
-(void)refuseAction{
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":@(5),
                         @"id":self.model.plg_id,
                         @"pack_id":self.model.pack_id
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //删除成功
            [YLMBProgressHUD initWithString:@"物流申请已拒绝" inSuperView:self.tableview afterDelay:1];

            //[self initData];
            
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
            
        }
        
    } isWithSign:YES];
}

//同意操作
-(void)aggreAction{
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":@(4),
                         @"id":self.model.plg_id,
                         @"pack_id":self.model.pack_id,
                         @"order_id":self.model.order_id,
                         @"logistics_require_id":self.model.logistics_require_id,
                         @"plor_total":self.model.plg_offer_price,
                         @"plor_weight":self.model.capacity,
                         @"plor_send_address":self.model.start_area,
                         @"plor_take_address":self.model.end_area,
                         @"plor_send_date":self.model.plg_estimate_depart_date,
                         @"order_type":self.model.order_type,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            [YLMBProgressHUD initWithString:@"物流申请已同意" inSuperView:self.tableview afterDelay:1];
            
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
        }
    } isWithSign:YES];
}

-(void)cancleAction{
    
    NSDictionary *dic =@{
                         @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                         @"handle":@(self.orderType),
                         @"slug":@(3),
                         @"id":self.model.dla_id,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"3%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            [YLMBProgressHUD initWithString:@"物流申请已取消" inSuperView:self.tableview afterDelay:1];
            
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }
        [self.hud hide:YES];
        
    } isWithSign:YES];
    
}


-(void)setupUI{
    //打包站申请
    if (self.orderType == 2) {
        //待处理
        if ([self.model.plg_apply_state isEqualToString:@"0"] ) {
            
            self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height * 0.92) style:UITableViewStylePlain];
            self.tableview.delegate = self;
            self.tableview.dataSource = self;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.tableview.bounces = NO;
            self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
            self.tableview.showsVerticalScrollIndicator = NO;
            
           //操作按钮
            YLRefuseAndAgreeView *btn = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YLRefuseAndAgreeView class]) owner:nil
                                                                    options:nil].lastObject;
            btn.frame = CGRectMake(0, self.view.height * 0.92, self.view.width, self.view.height * 0.08);
            [[[btn.refuseAction rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
                
                [self refuseAction];
            }];
            [[[btn.agreeAction rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
                [self aggreAction];
            }];
            [self.view addSubview:btn];
        }
        //以完成
        else{
            self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height) style:UITableViewStylePlain];
            self.tableview.delegate = self;
            self.tableview.dataSource = self;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.tableview.bounces = NO;
            self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
            self.tableview.showsVerticalScrollIndicator = NO;
        }
    }
    
    //我的申请
    else{
   
        //待处理
        if ([self.model.dla_apply_state isEqualToString:@"0"] ) {
            
            self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height * 0.92) style:UITableViewStylePlain];
            self.tableview.delegate = self;
            self.tableview.dataSource = self;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.tableview.bounces = NO;
            self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
            self.tableview.showsVerticalScrollIndicator = NO;
            
            //操作按钮
            YLCancleActionView *btn = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YLCancleActionView class]) owner:nil
                                                                   options:nil].lastObject;
            btn.frame = CGRectMake(0, self.view.height * 0.92, self.view.width, self.view.height * 0.08);
            [[[btn.cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
                [self cancleAction];
            }];
            [self.view addSubview:btn];
        }
        //以完成
        else{
            self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height) style:UITableViewStylePlain];
            self.tableview.delegate = self;
            self.tableview.dataSource = self;
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.tableview.bounces = NO;
            self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
            self.tableview.showsVerticalScrollIndicator = NO;
            
        }
    
    }
    
    self.tableview.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YLSQDetialTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLSQDetialTopCell class])];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YLSQdaressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLSQdaressCell class])];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YLGoodsInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLGoodsInfoCell class])];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([YLpackInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLpackInfoCell class])];
    
    [self.view addSubview:self.tableview];
}

-(void)initData{
    
    [self.hud show:YES];
    
    NSDictionary *dic = nil;
    
    //申请类型判断
    if (self.pushDic) {
        dic = self.pushDic;
    }else{
        
        if (self.model.dla_id) {
            
            dic =@{
                   @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                   @"handle":@(self.orderType),
                   @"slug":@(6),
                   @"id":self.model.dla_id,
                   @"pack_id":self.model.pack_id,
                   };
        }else{
            dic =@{
                   @"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),
                   @"handle":@(self.orderType),
                   @"slug":@(6),
                   @"id":self.model.plg_id,
                   @"pack_id":self.model.pack_id,
                   @"logistics_require_id":self.model.logistics_require_id
                   };
        }
        
    }
   
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KLogistics_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"111222333%@",data[@"data"]);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            if (self.orderType == 2) {
                
                //打包站
                self.dabaozhanmodel = [YLSQDetailDabaoZhan mj_objectWithKeyValues:data[@"data"][@"apply_detail"]];
            }else{
                
                //我的
                self.wodemodel = [YLSQDetailWoDe mj_objectWithKeyValues:data[@"data"][@"apply_detail"]];
            }
           
            self.packmodel = [YLSQDetailPackInfo mj_objectWithKeyValues:data[@"data"][@"pack_info"]];
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1];
        }
        
        [self.tableview reloadData];
        
        [self.hud hide:YES];
        
    } isWithSign:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 3;
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //打包站申请
    if (self.orderType == 2) {
        //待处理头部视图
        if (indexPath.section == 0) {
            
            YLSQDetialTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLSQDetialTopCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.SQtype = @"打包站";
            cell.state = self.dabaozhanmodel.plg_apply_state;
            return cell;
            
        }else if(indexPath.section == 1){
            
            YLSQdaressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLSQdaressCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"起始：";
                cell.itemLabel.text = self.dabaozhanmodel.start_area;
    
            }else if (indexPath.row == 1) {
                cell.titleLabel.text = @"目的地：";
                cell.itemLabel.text = self.dabaozhanmodel.end_area;
            }else{
                cell.titleLabel.text = @"出发日期：";
                cell.itemLabel.text = [self getdatefromstp:self.dabaozhanmodel.plg_estimate_depart_date];
            }
            return cell;
            
        }else if(indexPath.section == 2){
            
            YLGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLGoodsInfoCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.hightLabel.text = self.dabaozhanmodel.capacity;
            cell.priceLabel.text = self.dabaozhanmodel.plg_offer_price;
            return cell;
            
        }else{
            
            YLpackInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLpackInfoCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.namelabel.text = self.packmodel.pk_real_name;
            cell.numberLabel.text = self.packmodel.pk_credit_score;
            cell.adressLable.text = self.packmodel.pk_address;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,@""]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
            if ([self.dabaozhanmodel.plg_apply_state isEqualToString:@"0"]) {
                cell.actionBtn.hidden = NO;
                [[[cell.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
                    
                    [self contactAction:indexPath withphone:self.packmodel.pk_phone];
                }];
            }else{
                cell.actionBtn.hidden = NO;
                [[[cell.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
                    
                    [self contactAction:indexPath withphone:self.packmodel.pk_phone];
                }];
            }
            return cell;
        }
    }
    
    
    
    //我的申请
    else{
        
        if (indexPath.section == 0) {
            
            YLSQDetialTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLSQDetialTopCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.SQtype = @"我的";
            cell.state = self.wodemodel.dla_apply_state;
            return cell;
            
        }else if(indexPath.section == 1){
            
            YLSQdaressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLSQdaressCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"起始：";
                cell.itemLabel.text = self.wodemodel.start_area;
                
            }else if (indexPath.row == 1) {
                cell.titleLabel.text = @"目的地：";
                cell.itemLabel.text = self.wodemodel.end_area;
            }else{
                cell.titleLabel.text = @"出发日期：";
                cell.itemLabel.text = [self getdatefromstp:self.wodemodel.depart_time];
            }
            return cell;
            
        }else if(indexPath.section == 2){
            
            YLGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLGoodsInfoCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.hightLabel.text = self.wodemodel.capacity;
            cell.priceLabel.text = self.wodemodel.dla_offer_price;
            return cell;
            
        }else{
            YLpackInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLpackInfoCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.namelabel.text = self.packmodel.pk_real_name;
            cell.numberLabel.text = self.packmodel.pk_credit_score;
            cell.adressLable.text = self.packmodel.pk_address;
            
            if ([self.dabaozhanmodel.plg_apply_state isEqualToString:@"0"]) {
                cell.actionBtn.hidden = NO;
                [[[cell.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
                    
                    [self contactAction:indexPath withphone:self.packmodel.pk_phone];
                }];
            }else{
                cell.actionBtn.hidden = NO;
                [[[cell.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *btn) {
                    
                    [self contactAction:indexPath withphone:self.packmodel.pk_phone];
                }];
            }
            return cell;
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return SCREEN_HEIGHT * 0.18;
        
    }else if (indexPath.section == 1) {
        
        return SCREEN_HEIGHT * 0.08;
        
    }else if (indexPath.section == 2) {
        
        return SCREEN_HEIGHT * 0.15;
        
    }else{
        
        return SCREEN_HEIGHT * 0.25;
    }
}

-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
}

//联系
-(void)contactAction:(NSIndexPath *)indexpath withphone:(NSString *)phone{
    
    NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",phone]];
    
    [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:nil];
    
}

@end
