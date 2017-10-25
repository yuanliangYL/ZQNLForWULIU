//
//  YLCheZhuController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
#import "YLCheZhuController.h"
#import "YLTopPromptCell.h"
#import "YLInfoInputCell.h"
#import "YLInfoSelecteCell.h"
#import "YLImageSlecteCell.h"
#import "YLSeleteCellHeadView.h"
#import "AppDelegate.h"
#import "LBTabBarController.h"
#import "YLCheLiangController.h"

@interface YLCheZhuController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//日期选择视图
@property (weak, nonatomic) IBOutlet UIView *dateSelecteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modalViewTopCons;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//原始信息提示
@property(nonatomic,strong)NSMutableArray *infoIndecatorArr;
//驾驶证信息
@property(nonatomic,strong)NSMutableArray *CarIDArr;
//身份证信息
@property(nonatomic,strong)NSMutableArray *IDArr;
//日期选择
@property(nonatomic,strong)NSMutableArray *dateArr;

/*******图片选择部分*******/
//驾驶证
@property(nonatomic,strong)UIImage *JiaShiZhengimage;
//@property (nonatomic, strong) NSData *JiaShiZhengData;
@property (nonatomic, copy)NSString *JiaShiZhengPath;


//身份证正面
@property(nonatomic,strong)UIImage *IDZimage;
@property (nonatomic, copy)NSString *IDZimagePath;
//身份证方面
@property(nonatomic,strong)UIImage *IDFimage;
@property (nonatomic, copy)NSString *IDFimagePath;
//当前操作图片对象
@property(nonatomic,assign)NSInteger currentIMG;


/*******所需提交信息部分*******/
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *licence;
@property(nonatomic,strong)NSString *licenceDate;

@property(nonatomic,strong)YLMBProgressHUD *hud;

@end

@implementation YLCheZhuController

-(YLMBProgressHUD *)hud{
    if (!_hud) {
        _hud = [YLMBProgressHUD initProgressInView:self.view];
    }
    return _hud;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    
    [self initData];
}

-(void)setupUI{
    
    self.title = @"司机认证";
    
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
   
    //代码修改约束
    self.modalViewTopCons.constant = SCREEN_HEIGHT;
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


/**
 提交数据
 @param btn btn
 */
-(void)commitDataAction:(UIButton *)btn{
    
    NSLog(@"%@～～～～～～～～%@～～～～～～～～～～%@",self.realName,self.licence,self.licenceDate);
   
    if (self.realName.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请填写真实姓名" inSuperView:self.view afterDelay:1.5];
        
        return;
    }
    
    if (self.licence.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请填写驾驶证号" inSuperView:self.view afterDelay:1.5];
        
        return;
        
    }else{
        
        if (![self isCorrect:self.licence]) {
            [YLMBProgressHUD initWithString:@"驾驶证号输入有误" inSuperView:self.view afterDelay:1.5];
            return;
        }
    }
    
    if (self.licenceDate.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请选择驾驶证初次领证日期" inSuperView:self.view afterDelay:1.5];
        
        return;
    }
    
   
    if (self.JiaShiZhengPath.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请上传驾驶证照片" inSuperView:self.view afterDelay:1.5];
        
        return;
    }
    
    if (self.IDZimagePath.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请上传身份证正面照片" inSuperView:self.view afterDelay:1.5];
        
        return;
    }
    
    
    if (self.IDFimagePath.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请上传身份证反面照片" inSuperView:self.view afterDelay:1.5];
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),
                         @"ld_realname":self.realName,
                         @"ld_licence_number":self.licence,
                         @"ld_licence_first_get_date":self.licenceDate,
                         @"type":@(1),
                         @"handle":@(3),
                         @"ld_licence_photo":self.JiaShiZhengPath,
                         @"ld_idcard_front_photo":self.IDZimagePath,
                         @"ld_idcard_back_photo":self.IDFimagePath,
                         };
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KConfirm_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@%@",data,error);
        
        if (data) {
            
            if ([data [@"status_code"] integerValue] == 10000) {
                
                if ([self.pageType isEqualToString:@"注册"])  {
                    
                    YLCheLiangController *cvc = [YLCheLiangController new];
                    cvc.pageType = self.pageType;
                    [self.navigationController pushViewController:cvc animated:YES];
                    
                }else{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                
            }else{
                
                //提示框
                [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
                
            }
            
        }else {
            
            [YLMBProgressHUD initWithString:@"请求超时" inSuperView:self.view afterDelay:2];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } isWithSign:YES];
    
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

-(void)initData{
    
    if (self.model) {
        
        //初始化输入框提示数组
        self.infoIndecatorArr = [NSMutableArray arrayWithObjects:@[@"真实姓名",self.model.ld_realname],@[@"驾驶证号",self.model.ld_licence_number],nil];
        
        self.IDArr = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.ld_idcard_front_photo,@"image",@"（正面实例）",@"imageLabel",nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.ld_idcard_back_photo,@"image",@"（反面实例）",@"imageLabel",nil],nil];
        
        
        self.CarIDArr = [NSMutableArray arrayWithObjects:
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.ld_licence_photo,@"image",@" ",@"imageLabel",nil],nil];
        
        self.dateArr = [NSMutableArray arrayWithObjects:@"驾驶证初次领证日期",[self getdatefromstp:self.model.ld_licence_first_get_date],nil];
        
        
    }else{
        //初始化输入框提示数组
        self.infoIndecatorArr = [NSMutableArray arrayWithObjects:@[@"真实姓名",@"请填写本人真实姓名"],@[@"驾驶证号",@"请填写本人驾驶证号"],nil];
        
        self.IDArr = [NSMutableArray arrayWithObjects:
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"id_zhengmian"],@"image",@"（正面实例）",@"imageLabel",nil],
                      [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"id_fanmian"],@"image",@"（反面实例）",@"imageLabel",nil],nil];
        
        
        self.CarIDArr = [NSMutableArray arrayWithObjects:
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"placehoderImg"],@"image",@" ",@"imageLabel",nil],nil];
        
        self.dateArr = [NSMutableArray arrayWithObjects:@"驾驶证初次领证日期", @"请选择您初次领取驾驶证的日期",nil];
 
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

   if (1 == section || 4 == section){
        
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    
        //头部信息提示
        YLTopPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLTopPromptCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.infoArr = [NSArray arrayWithObjects:@"icon_jiashizheng",@"第一步：填写本人驾驶证",@"平台会保障您的个人隐私，信息仅用平台审核，不会泄漏给任何组织和个人", nil];
    
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
                    
                    self.realName = x;
                    
                }else{
                    
                    self.licence = x;
                    cell.InfoTF.keyboardType = UIKeyboardTypeNumberPad;
                }
            }];
            
        }
       
        return cell;
        
    }else if (indexPath.section == 2){
        
        //信息按钮选择
        YLInfoSelecteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLInfoSelecteCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        
        if (self.model) {
            
            cell.haveinfoArr = self.dateArr;
        }else{
            
            cell.infoArr = self.dateArr;
            
            [[[cell.seletedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
                btn.highlighted = NO; //取消高亮
                btn.selected = YES;
                
                //动画移动视图
                [UIView animateWithDuration:1.0 animations:^{
                    self.modalViewTopCons.constant = 0;
                } completion:nil];
                
            }];
   
        }
       
        return cell;
    }
    
    else if (indexPath.section == 3){
        
       //上传驾驶证
        YLImageSlecteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLImageSlecteCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        
        if (self.model) {
            
            cell.haveinfoArr = self.CarIDArr[indexPath.row];
            
        }else{
            
            cell.itemArr = self.CarIDArr[indexPath.row];
            [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
                //添加图片操作标示
                self.currentIMG = 0;
                
                [self openAlertSheet];
            }];
        }

        return cell;
    }
    
    //上传身份证
    YLImageSlecteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLImageSlecteCell class]) forIndexPath:indexPath];
    cell.selectionStyle = 0;
    
    if (self.model) {
        
        cell.haveinfoArr = self.IDArr[indexPath.row];
        
    }else{
        cell.itemArr = self.IDArr[indexPath.row];
        [[[cell.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.view.rac_willDeallocSignal]subscribeNext:^(UIButton *btn) {
            if (indexPath.row == 0) {
                
                self.currentIMG = 1;
                
            }else{
                
                self.currentIMG = 2;
            }
            
            [self openAlertSheet];
        }];
    }

    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return  SCREEN_HEIGHT * 0.16;
        
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        
        return  SCREEN_HEIGHT * 0.13;
    }
    return SCREEN_HEIGHT * 0.2;
}

//第三个分区的尾部提示信息
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (2 == section) {
        
        UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25)];
        footerV.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"renzheng_xinghao"] forState:UIControlStateNormal];
        [btn setTitle:@"请认真填写认真信息，认证成功以后，将不能修改" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#ff5000"] forState:UIControlStateNormal];
        [btn setSetFontByDevice:12];
        
        [footerV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footerV.mas_centerY);
            make.left.equalTo(footerV.mas_left).offset(15);
        }];
        
        return footerV;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (3 == section || 4 == section) {
        
        YLSeleteCellHeadView *HV = [[NSBundle mainBundle]loadNibNamed:@"YLSeleteCellHeadView" owner:self options:nil].lastObject;
        HV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
       
        switch (section) {
            case 3:
                HV.namelabel.text = @"上传驾驶证照片";
                break;
            case 4:
                HV.namelabel.text = @"上传身份证正反面";
                break;
            default:
                break;
        }
       
        return HV;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2){
        
        return 25;
    }
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (3 == section || 4 == section) {
        
        return 30;
    }
    
    return 0.1;
}

#pragma mark - dateSelected
- (IBAction)confirmActionSelecteDate:(UIButton *)sender {
    
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];
    
     self.licenceDate = [self getDate:pickerDate];
    
    // 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    // 创建一个日期格式器
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
   
    
    self.dateArr[1] = dateString;
    
    [self.tableView reloadData];
    
    [self ViewChooseAction];
}

- (IBAction)cancleAction:(UIButton *)sender {
    
    [self ViewChooseAction];
}

- (IBAction)tapCloseAction:(id)sender {
    
    [self ViewChooseAction];
}

//关闭modal视图
-(void)ViewChooseAction{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.modalViewTopCons.constant = SCREEN_HEIGHT;
    } completion:nil];
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
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //根据标示操作图片
    if (0 == self.currentIMG) {
        
        // NSLog(@"%ld",(long)self.currentIMG);
        self.JiaShiZhengimage = image;

        //修改字典数据
        [self.CarIDArr[0] setObject:image forKey:@"image"];
        
     [self.hud show:YES];
     [SD_NetAPIClient_CONFIG loadUpImage:UIImagePNGRepresentation(image) errorBlock:^(id data, NSError *error, NSString *errorMsg) {
         NSLog(@"%@",error);
     } andSucceseeBlock:^(id data, NSError *error, NSString *errorMsg) {
         self.JiaShiZhengPath = data[@"data"];
          NSLog(@"%@",data);
         dispatch_sync(dispatch_get_main_queue(), ^{
             //Update UI in UI thread here
             [self.hud hide:YES];
         });
     }];
        
    }else if (1 == self.currentIMG) {
    
        self.IDZimage = image;
        self.IDArr[0][@"image"] = self.IDZimage;
        self.IDArr[0][@"imageLabel"] = @" ";
        [self.hud show:YES];
        [SD_NetAPIClient_CONFIG loadUpImage:UIImagePNGRepresentation(image) errorBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",error);
        } andSucceseeBlock:^(id data, NSError *error, NSString *errorMsg) {
            self.IDZimagePath = data[@"data"];
            NSLog(@"%@",data);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
               [self.hud hide:YES];
            });
        }];
    }else{
        
//        NSLog(@"%ld",(long)self.currentIMG);
        self.IDFimage = image;
        self.IDArr[1][@"image"] = self.IDFimage;
        self.IDArr[1][@"imageLabel"] = @" ";
        
        [self.hud show:YES];
        [SD_NetAPIClient_CONFIG loadUpImage:UIImagePNGRepresentation(image) errorBlock:^(id data, NSError *error, NSString *errorMsg) {
            NSLog(@"%@",error);
        } andSucceseeBlock:^(id data, NSError *error, NSString *errorMsg) {
            self.IDFimagePath = data[@"data"];
            NSLog(@"%@",data);
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.hud hide:YES];
            });
        }];
    }

    [self.tableView reloadData];
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma 校验身份证号即驾驶证号
//①根据百度百科中身份证号码的标准实现该方法
//②该方法只能判断18位身份证,且不能判断身份证号码和姓名是否对应(要看姓名和号码是否对应,应该有大量的数据库做对比才能实现)
//③直接copy这段代码,就能通过调用这个方法判断身份证号码是否符合标准,非常easy

/**
 *  验证身份证号码是否正确的方法
 *
 *  @param value 传进身份证号码字符串
 *
 *  @return 返回YES或NO表示该身份证号码是否符合国家标准
 */
- (BOOL)isCorrect:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                //4：检测ID的校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}


@end
