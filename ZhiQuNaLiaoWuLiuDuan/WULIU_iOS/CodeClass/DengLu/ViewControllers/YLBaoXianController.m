//
//  YLBaoXianController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLBaoXianController.h"

#import "YLTopPromptCell.h"
#import "YLInfoInputCell.h"
#import "YLInfoSelecteCell.h"
#import "YLImageSlecteCell.h"
#import "YLSeleteCellHeadView.h"
#import "AppDelegate.h"
#import "LBTabBarController.h"
#import "AppDelegate.h"

@interface YLBaoXianController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//信息提示
@property(nonatomic,strong)NSMutableArray *infoIndecatorArr;
//按钮点击cell提示
@property(nonatomic,strong)NSMutableArray *btnIndecatorArr;
//图片选择数组
@property(nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic, copy)NSString *tupianPath;
//日期选择modalView
@property (weak, nonatomic) IBOutlet UIView *datepickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datepickerTopCons;
//当前操作日期对象
@property(nonatomic,assign)NSInteger currentDatepicker;

/*******图片选择部分*******/
//驾驶证
@property(nonatomic,strong)UIImage *Baoxianimage;

//提交数据
@property(nonatomic,strong)NSString *baoXianNumber;
@property(nonatomic,strong)NSString *baoXianOwner;
@property(nonatomic,strong)NSString *baoXianStart;
@property(nonatomic,strong)NSString *baoXianStop;
@property(nonatomic,strong)NSString *baoXianType;

@property(nonatomic,strong)YLMBProgressHUD *hud;

@end

@implementation YLBaoXianController

-(YLMBProgressHUD *)hud{
    if (!_hud) {
        
        _hud = [YLMBProgressHUD initProgressInView:self.view];
    }
    return _hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setupUI];

}

-(void)setupUI{
    self.title = @"保险认证";
    
    if ([self.pageType isEqualToString:@"注册"]) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)];
    }
    
    //控制器根据所在界面的status bar，navigationbar，与tabbar的高度，自动调整scrollview的inset
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //取消cell中的线
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    //模型不存在，才会添加操作按钮
    NSLog(@"%@",self.model);
    if (!self.model) {
        self.tableView.tableFooterView = [self renderFooterView];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLTopPromptCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLTopPromptCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLInfoInputCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLInfoInputCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLInfoSelecteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLInfoSelecteCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YLImageSlecteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YLImageSlecteCell class])];
    
    self.datepickerTopCons.constant = SCREEN_HEIGHT;
}

/**
 跳过注册
 
 @param btn UITabBarItem
 */
-(void)dismissAction:(UITabBarItem *)btn{
    
    //登陆成功跳转页面
    AppDelegate *appdelegate = (id)[[UIApplication sharedApplication] delegate];
    appdelegate.window.rootViewController = [[LBTabBarController alloc]init];
    
    NSLog(@"跳过认证");
}

/**
 底部确认按钮及点击事件
 
 @return 按钮View
 */
-(UIView *)renderFooterView{
    
    UIButton *footerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    [footerBtn setTitle:@"确定" forState:UIControlStateNormal];
    [footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerBtn setBackgroundImage:[UIImage imageNamed:@"btn_confirm_green"] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(commitDataAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return footerBtn;
}

-(void)commitDataAction:(UIButton *)btn{
    
    if (self.baoXianNumber.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入保险单号" inSuperView:self.view afterDelay:1.5];
        return;
    }
    if (self.baoXianOwner.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入保单人姓名" inSuperView:self.view afterDelay:1.5];
        return;
    }
    if (self.baoXianStart.length == 0) {
        [YLMBProgressHUD initWithString:@"请选择保单开始日期" inSuperView:self.view afterDelay:1.5];
        return;
    }
    if (self.baoXianStop.length == 0) {
        [YLMBProgressHUD initWithString:@"请选择保单结束日期" inSuperView:self.view afterDelay:1.5];
        return;
    }
    if (self.baoXianType.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入保险承保险种" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    if (self.tupianPath.length == 0) {
        [YLMBProgressHUD initWithString:@"请上传保单照片" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
            NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),
                                 @"ld_policy_number":self.baoXianNumber,
                                 @"ld_insuer":self.baoXianOwner,
                                 @"ld_policy_start_date":self.baoXianStart,
                                 @"ld_policy_end_date":self.baoXianStop,
                                 @"ld_policy_coverage":self.baoXianType,
                                 @"type":@(3),
                                 @"handle":@(3),@"ld_policy_photo":self.tupianPath};
            
            [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KConfirm_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
                
                NSLog(@"%@%@",data,error);
                
                if (data && [data [@"status_code"] integerValue] == 10000) {
                    
                    if ([self.pageType isEqualToString:@"注册"])  {
                        //登陆成功跳转页面
                        AppDelegate *appdelegate = (id)[[UIApplication sharedApplication] delegate];
                        appdelegate.window.rootViewController = [[LBTabBarController alloc]init];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }else{
                    //提示框
                    [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } isWithSign:YES];
}

-(void)initData{
    
    if (self.model) {
       
        //初始化输入框提示数组
        self.infoIndecatorArr = [NSMutableArray arrayWithObjects:
                                 [NSMutableArray arrayWithObjects:@"保险号",self.model.ld_policy_number,nil],
                                 [NSMutableArray arrayWithObjects:@"保单人",self.model.ld_insuer,nil],nil];
        
        
        self.btnIndecatorArr = [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"保单起期",[self getdatefromstp:self.model.ld_policy_start_date],nil],
                                [NSMutableArray arrayWithObjects:@"保单止期",[self getdatefromstp:self.model.ld_policy_end_date],nil],nil];
        
        
        self.imageArr = [NSMutableArray arrayWithObjects:
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.ld_policy_photo,@"image",@" ",@"imageLabel",nil],nil];
        
        
    }else{
       
        //初始化输入框提示数组
        self.infoIndecatorArr = [NSMutableArray arrayWithObjects:
                                 [NSMutableArray arrayWithObjects:@"保险号",@"请填写保险单号",nil],
                                 [NSMutableArray arrayWithObjects:@"保单人",@"请填写保单所有人姓名",nil],nil];
        
        
        self.btnIndecatorArr = [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"保单起期",@"参照保险合同上的开始日期",nil],
                                [NSMutableArray arrayWithObjects:@"保单止期",@"参照保险合同上的结束日期",nil],nil];
        
        
        self.imageArr = [NSMutableArray arrayWithObjects:
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"placehoderImg"],@"image",@" ",@"imageLabel",nil],nil];
        
        
    }
}

-(NSString *)getdatefromstp:(NSString *)strip{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:strip.integerValue];
    return  [formatter stringFromDate:confromTimesp];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1 || section == 2) {
        
        return 2;
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        //头部信息提示
        YLTopPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLTopPromptCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.infoArr = [NSArray arrayWithObjects:@"icon_baoxian",@"第三步：填写货车保险",@"货车保险投保人，需要和行驶证所有人一致", nil];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        //信息文本框输入
        YLInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLInfoInputCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        if (self.model) {
            
            cell.haveinfoArr = self.infoIndecatorArr[indexPath.row];
            
        }else{
            
            cell.infoArr = self.infoIndecatorArr[indexPath.row];
            [[cell.InfoTF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x){
                if (indexPath.row == 0) {
                    
                    self.baoXianNumber = x;
                    
                }else{
                    
                    self.baoXianOwner = x;
                }
            }];
            
        }
        
        return cell;
        
    }else if (indexPath.section == 2){
        
        //信息按钮选择
        YLInfoSelecteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLInfoSelecteCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        
        if (self.model) {
            
            cell.haveinfoArr = self.btnIndecatorArr[indexPath.row];
        }else{
           
            cell.infoArr = self.btnIndecatorArr[indexPath.row];
            
            [[[cell.seletedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
                btn.highlighted = NO; //取消高亮
                [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
                self.currentDatepicker = indexPath.row;
                self.datepickerTopCons.constant = 0;
                
                
                NSLog(@"选择%@",btn);
            }];
            
        }
       
        
        return cell;
        
    }else if (indexPath.section == 3){
        
        //信息文本框输入
        YLInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLInfoInputCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        
        if (self.model) {
            
            cell.haveinfoArr = [NSArray arrayWithObjects:@"承包险种",self.model.ld_policy_coverage, nil];
            
        }else{
            cell.infoArr = [NSArray arrayWithObjects:@"承包险种",@"输入承包险种", nil];
            [[cell.InfoTF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x){
                
                self.baoXianType = x;
                
            }];
            
        }
       
        return cell;
    }
    
    //上传驾驶证
    YLImageSlecteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLImageSlecteCell class]) forIndexPath:indexPath];
    cell.selectionStyle = 0;
    
    if (self.model) {
        
        cell.haveinfoArr = self.imageArr[indexPath.row];
        
    }else{
        
        cell.itemArr = self.imageArr[indexPath.row];
        [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
            
            [self openAlertSheet];
        }];
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return  SCREEN_HEIGHT * 0.16;
        
    } else if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3) {
        
        return  SCREEN_HEIGHT * 0.13;
    }
    return SCREEN_HEIGHT * 0.2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        v.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
        return v;
    }
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (4 == section) {
        
        YLSeleteCellHeadView *HV = [[NSBundle mainBundle]loadNibNamed:@"YLSeleteCellHeadView" owner:self options:nil].lastObject;
        HV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        HV.namelabel.text = @"上传保险照片";
        
        return HV;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 8;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (4 == section) {
        
        return 30;
    }
    
    return 0.1;
}
#pragma mark - modal关闭
-(void)closeModal{
    
    self.datepickerTopCons.constant = SCREEN_HEIGHT;
    
}
- (IBAction)cancleAction:(UIButton *)sender {
    [self closeModal];
}
- (IBAction)confirmAction:(UIButton *)sender {
    
    NSLog(@"%ld",(long)sender.tag);
    if (self.currentDatepicker == 0) {
        
        //NSDate格式转换为NSString格式
        NSDate *pickerDate = [self.datepicker date];
        // 获取用户通过UIDatePicker设置的日期和时间
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
        // 创建一个日期格式器
        [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
        
        
        self.baoXianStart = [self getDate:pickerDate];
        
        self.btnIndecatorArr[0][1] = dateString;
        
        [self.tableView reloadData];
        
       
    }else if (self.currentDatepicker == 1) {
        
        //NSDate格式转换为NSString格式
        NSDate *pickerDate = [self.datepicker date];
        // 获取用户通过UIDatePicker设置的日期和时间
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
        // 创建一个日期格式器
        [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
        
        self.baoXianStop = [self getDate:pickerDate];
        
        self.btnIndecatorArr[1][1] = dateString;
        
        [self.tableView reloadData];
        
    }
    
    [self closeModal];
}
//获取当天日期零点的时间戳
-(NSString *)getDate:(NSDate *)date{
    
    // 实例化NSDateFormatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateString = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *today = [NSString stringWithFormat:@"%@ 00:00:00",currentDateString];
    
    NSDate *todayDate =[formatter dateFromString:today];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[todayDate timeIntervalSince1970]];
    
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    return timeSp;
}

#pragma mark - imagePickerDelegate
-(void)openAlertSheet{
    
    //避免循环强引用
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //取消:style:UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:cancelAction];
    //了解更多:style:UIAlertActionStyleDestructive
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf selectImage:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    [alertController addAction:moreAction];
    
    //原来如此:style:UIAlertActionStyleDefault
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf selectImage:UIImagePickerControllerSourceTypeCamera];
        
    }];
    
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)selectImage:(UIImagePickerControllerSourceType)SourceType{
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = YES;
    
    //设置相册呈现的样式
    pickerController.sourceType = SourceType;
    
    //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
    pickerController.delegate = self;
    //使用模态呈现相册
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark -  选择照片完成之后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // NSLog(@"%ld",(long)self.currentIMG);
    self.Baoxianimage = image;
    
    [self.hud show:YES];
    
    [SD_NetAPIClient_CONFIG loadUpImage:UIImagePNGRepresentation(image) errorBlock:^(id data, NSError *error, NSString *errorMsg) {
        NSLog(@"%@",error);
    } andSucceseeBlock:^(id data, NSError *error, NSString *errorMsg) {
        self.tupianPath = data[@"data"];
        NSLog(@"%@",data);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Update UI in UI thread here
            [self.hud hide:YES];
        });
    }];
    //修改字典数据
    [self.imageArr[0] setObject:image forKey:@"image"];
    
    
    [self.tableView reloadData];
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
