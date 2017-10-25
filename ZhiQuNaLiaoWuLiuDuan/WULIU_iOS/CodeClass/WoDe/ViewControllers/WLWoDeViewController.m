//
//  WLWoDeViewController.m
//  WULIU_iOS
//
//  Created by Miaomiao Dai on 2017/8/19.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "WLWoDeViewController.h"
#import "YLMyTopCell.h"
#import "YLMyitemCell.h"

#import "YLWoDeRenZhengController.h"
#import "YLAddressGuanLiController.h"
#import "YLMessageTableViewController.h"
#import "YLFundsManagementController.h"
#import "YLSettingController.h"
#import "YLUserInfoController.h"
#import "YLCustomerServices.h"
#import "YLWuLiuShenQingController.h"


@interface WLWoDeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *tophiddenView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//每行信息
@property(nonatomic,strong)NSArray *itemArr;

//弹窗视图
@property (strong, nonatomic) UIView *contentView;

@property(nonatomic,strong)WoDeModel *model;


@end

@implementation WLWoDeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.itemArr = [NSArray arrayWithObjects:@[@"wode_icon_zijin",@"资金管理"], @[@"wode_icon_renzheng",@"我的认证"],@[@"wode_icon_wuliu",@"物流申请"],@[@"wode_icon_address",@"地址管理"],@[@"wode_icon_kefu",@"联系客服"],@[@"wode_icon_shezhi",@"设置"],nil];
    
    [self setupUI];
}



-(void)setupUI{
    
    self.title = @"我的";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"daohang_news_p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(GetMassage:)];
    
    //控制器根据所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableView.showsVerticalScrollIndicator = NO;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLMyTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLMyTopCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLMyitemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLMyitemCell class])];
}

-(void)initData{

    //个人信息
    WoDeModel *mine = [WoDeModel sharedWoDeModel];
    NSDictionary *dic =@{@"uid":mine.user_id,@"type":@(5)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
    NSLog(@"%@",data);
        
    if (data && [data [@"status_code"] integerValue] == 10000) {
        
            WoDeModel *mymodel = [WoDeModel sharedWoDeModel];
            
            //头像
        if (!([data[@"data"][@"ld_headurl"] isEqual:[NSNull null]])) {
                
            mymodel.ld_headurl = [NSString stringWithFormat:@"%@",data[@"data"][@"ld_headurl"]];
        
        }
        
            //认证
            if (! ([data[@"data"][@"ld_auth_state"] isEqual:[NSNull null]]) ) {
            
                mymodel.ld_auth_state = [NSString stringWithFormat:@"%@",data[@"data"][@"ld_auth_state"]];
            }
        
            //实名
            if (! ([data[@"data"][@"ld_realname"] isEqual:[NSNull null]]) ) {
                
                mymodel.ld_realname = [NSString stringWithFormat:@"%@",data[@"data"][@"ld_realname"]];
            }
        
            self.model = mymodel;
        
            [self.tableView reloadData];
        
            //取消遮盖
           if (self.tophiddenView) {
                [self.tophiddenView removeFromSuperview];
           }
    
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
            
        }
    } isWithSign:YES];
}

-(void)GetMassage:(UIBarButtonItem *)btn{
    
    YLMessageTableViewController *mvc = [YLMessageTableViewController new];
    [self.navigationController  pushViewController:mvc animated:YES];
    NSLog(@"获取消息");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section ) {
        
        return 1;
    }
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        YLMyTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLMyTopCell class]) forIndexPath:indexPath];
        
        cell.model = [WoDeModel sharedWoDeModel];
       [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDownImage_URL,[WoDeModel sharedWoDeModel].ld_headurl]] placeholderImage:[UIImage imageNamed:@"login_logo"]];
        cell.selectionStyle = 0;
        return cell;
    
    }else{
        
        YLMyitemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLMyitemCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.itemArr = self.itemArr[indexPath.row];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return  SCREEN_HEIGHT * 0.18;
        
    }
    
    return  SCREEN_HEIGHT * 0.08;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                //资金管理
                if ([self.model.ld_auth_state isEqualToString:@"1"]) {
                    
                    YLFundsManagementController *fvc = [YLFundsManagementController new];
                    
                    [self.navigationController pushViewController:fvc animated:YES];
                
                }else{
                    
                    [YLMBProgressHUD initWithString:@"您尚未认证，请前往认证！" inSuperView:self.view afterDelay:1.5];
                    
                }
           
                break;
                
            case 1:
                //我的认证
            {
                YLWoDeRenZhengController *rvc = [YLWoDeRenZhengController new];
                //认证状态
                rvc.renZhengStatus = [WoDeModel sharedWoDeModel].ld_auth_state.intValue;
                
                [self.navigationController pushViewController:rvc animated:YES];
                
            }
                break;
            case 2:
                //物流申请
                
                if ([self.model.ld_auth_state isEqualToString:@"1"]) {
                    
                    YLWuLiuShenQingController *wvc = [YLWuLiuShenQingController new];
                    
                    [self.navigationController pushViewController:wvc animated:YES];
                    
                }else{
                    
                    [YLMBProgressHUD initWithString:@"您尚未认证，请前往认证！" inSuperView:self.view afterDelay:1.5];
                    
                }

                break;
            case 3:
                //地址管理
            {
                YLAddressGuanLiController *avc = [YLAddressGuanLiController new];
            
                [self.navigationController pushViewController:avc animated:YES];
                
            }
                
                break;
            case 4:
                //拨打电话
                [self popViewShow];
                
                break;
            case 5:
            {
                YLSettingController *svc = [YLSettingController new];
                [self.navigationController pushViewController:svc animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        
        //个人信息中心
        YLUserInfoController *uvc = [YLUserInfoController new];
        uvc.wodeModel = self.model;
        
        [self.navigationController pushViewController:uvc animated:YES];
        
    }
}

#pragma mark - 弹窗视图
- (void)popViewShow {

    //NSLog(@"%@",self.iscustomerServicesView?@"YES":@"NO");
    //客服弹窗
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.25)];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    YLCustomerServices * csvc = [[YLCustomerServices alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.7, SCREEN_HEIGHT * 0.25)];
    csvc.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    csvc.closeblock = ^{
        [weakSelf closeAndBack];
    };
    
    //拨打电话
    csvc.callphoneblock = ^{
        
        NSURL *url = [NSURL URLWithString:[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18256970599"]];
        
        //版本判断，兼容
        if([UIDevice currentDevice].systemVersion.doubleValue >= 10.0){
            
            [[UIApplication sharedApplication]  openURL:url options:@{} completionHandler:^(BOOL success) {
                [weakSelf closeAndBack];
            }];
            
        }else{
            
            [[UIApplication sharedApplication] openURL:url];
        }
        
    };
    [_contentView addSubview:csvc];


[HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
[HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
[[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
}

- (void)closeAndBack {
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

@end
