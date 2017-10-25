//
//  YLCheLiangController.m
//  WULIU_iOS
//
//  Created by 袁亮 on 2017/8/22.
//  Copyright © 2017年 Miaomiao Dai. All rights reserved.
//

#import "YLCheLiangController.h"
#import "YLTopPromptCell.h"
#import "YLInfoInputCell.h"
#import "YLInfoSelecteCell.h"
#import "YLImageSlecteCell.h"
#import "YLSeleteCellHeadView.h"

#import "AppDelegate.h"
#import "LBTabBarController.h"

#import "YLBaoXianController.h"
#import "YLCheXingModel.h"
#import "YLCheXingCell.h"
@interface YLCheLiangController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //承载量View中按钮记录
    UIButton *currentCheZaiBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//信息提示
@property(nonatomic,strong)NSMutableArray *infoIndecatorArr;
//按钮点击cell提示
@property(nonatomic,strong)NSMutableArray *btnIndecatorArr;
//图片选择数组
@property(nonatomic,strong)NSMutableArray *imageArr;

/************三种modal视图**************/
//车型选择
@property (weak, nonatomic) IBOutlet UIView *cheXingView;
@property (weak, nonatomic) IBOutlet UIView *chexingCollectionView;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *cheXingArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cheXingTopCons;

//承载量View
@property (weak, nonatomic) IBOutlet UIView *chengZaiView;
@property (weak, nonatomic) IBOutlet UIScrollView *cheZaiScrollview;
@property(nonatomic,strong)NSMutableArray *chengZaiArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chengZaiTopCons;


//行驶证日期选择
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xingShiZhengTopCons;
@property (weak, nonatomic) IBOutlet UIView *datepickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (nonatomic, copy) NSString *tupianPath;

/*******图片选择部分*******/
//驾驶证
@property(nonatomic,strong)UIImage *XingShiZhengimage;

//提交数据
@property(nonatomic,strong)NSString *carNumber;
@property(nonatomic,strong)NSString *carOwne;
@property(nonatomic,strong)NSString *carType;
@property(nonatomic,strong)NSString *carzhongliang;
@property(nonatomic,strong)NSString *carDate;

@property(nonatomic,strong)YLMBProgressHUD *hud;
@end

static int pageNum = 0;
static int size = 50;

@implementation YLCheLiangController

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
    self.title = @"车辆认证";
   
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
    
    self.cheXingTopCons.constant = self.xingShiZhengTopCons.constant = self.chengZaiTopCons.constant = SCREEN_HEIGHT;
    
    [self.chexingCollectionView addSubview:self.collectionView];
    
    [self setupCheZaiScrollView];
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
-(void)setupCheZaiScrollView{
    self.cheZaiScrollview.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
    self.cheZaiScrollview.bounces = YES;
    for (int i = 0; i < self.chengZaiArr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * 35 + i, SCREEN_WIDTH, 35);
        [btn setTitle:self.chengZaiArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setSetFontByDevice:15];
        btn.tag = i;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yl_toUIColorByStr:@"#ff5000"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selecteChezaiAction:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 0) {
//            currentCheZaiBtn = btn;
//            currentCheZaiBtn.selected = YES;
//        }
        [self.cheZaiScrollview addSubview:btn];
    }
    
    self.cheZaiScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, self.chengZaiArr.count * 35);
    
}
-(void)selecteChezaiAction:(UIButton *)btn{

    currentCheZaiBtn.selected = NO;
    currentCheZaiBtn = btn;
    currentCheZaiBtn.selected = YES;
    
    NSLog(@"%@",self.chengZaiArr[currentCheZaiBtn.tag]);
    
    self.carzhongliang = self.chengZaiArr[currentCheZaiBtn.tag];
    self.btnIndecatorArr[1][1] = self.chengZaiArr[currentCheZaiBtn.tag];
    [self.tableView reloadData];
    
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
    
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        //列距
        flowLayOut.minimumInteritemSpacing = 15;
        //行距
        flowLayOut.minimumLineSpacing = 15;
        //item大大小
        flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH-60)/3, SCREEN_WIDTH/3);
        //初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:self.chexingCollectionView.bounds collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YLCheXingCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([YLCheXingCell class])];
    }
    return _collectionView;
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
    
    if (self.carNumber.length == 0) {
        
        [YLMBProgressHUD initWithString:@"请输入车牌号" inSuperView:self.view afterDelay:1.5];
        return;
        
    }else{
        if (![self checkCarID:self.carNumber]) {
            [YLMBProgressHUD initWithString:@"车辆号码输入错误" inSuperView:self.view afterDelay:1.5];
            return;
        }
    }
    
    if (self.carOwne.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入车辆所有人姓名" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    if (self.carzhongliang.length == 0) {
        [YLMBProgressHUD initWithString:@"请输入车辆承载重量" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    if (self.carType.length == 0) {
        [YLMBProgressHUD initWithString:@"请选择车辆类型" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    if (self.carDate.length == 0) {
        [YLMBProgressHUD initWithString:@"请选择行驶证上的注册日期" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    if (self.tupianPath.length == 0) {
        [YLMBProgressHUD initWithString:@"请上传驾驶证照片" inSuperView:self.view afterDelay:1.5];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),
                             @"ld_licence_plate":self.carNumber,
                             @"ld_owner":self.carOwne,
                             @"ld_car_type":self.carType,
                             @"ld_capacity":self.carzhongliang,
                             @"ld_permit_register_date":self.carDate,
                             @"type":@(2),
                             @"handle":@(3),@"ld_permit_photo":self.tupianPath};
        

        [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KConfirm_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
            
            NSLog(@"%@%@",data,error);
            
            if (data && [data [@"status_code"] integerValue] == 10000) {
                
                
                if ([self.pageType isEqualToString:@"注册"])  {
                    
                    YLBaoXianController *Bvc = [YLBaoXianController new];
                    Bvc.pageType = self.pageType;
                    [self.navigationController pushViewController:Bvc animated:YES];
                    
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
        self.infoIndecatorArr = [NSMutableArray arrayWithObjects:
                                 [NSMutableArray arrayWithObjects:@"车辆号码",self.model.ld_licence_plate,nil],
                                 [NSMutableArray arrayWithObjects:@"车辆所有人",self.model.ld_owner,nil],
                                 [NSMutableArray arrayWithObjects:@"车承载量",self.model.ld_capacity,nil],nil];
        
        self.btnIndecatorArr = [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"车型",self.model.ld_car_type,nil],
                                [NSMutableArray arrayWithObjects:@"行驶证上的注册日期",[self getdatefromstp:self.model.ld_permit_register_date],nil],nil];
        
        self.imageArr = [NSMutableArray arrayWithObjects:
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:self.model.ld_permit_photo,@"image",@" ",@"imageLabel",nil],nil];
        
    }else{
        
        //初始化输入框提示数组
        self.infoIndecatorArr = [NSMutableArray arrayWithObjects:
                                 [NSMutableArray arrayWithObjects:@"车辆号码",@"请填写行驶证上的车牌号",nil],
                                 [NSMutableArray arrayWithObjects:@"车辆所有人",@"请填写车辆所有人姓名",nil],
                                 [NSMutableArray arrayWithObjects:@"车承载量",@"请填写车辆承载量",nil],nil];
        
        self.btnIndecatorArr = [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:@"车型",@"请选择车型",nil],
                                [NSMutableArray arrayWithObjects:@"行驶证上的注册日期",@"参照行驶证的注册日期",nil],nil];
        
        self.imageArr = [NSMutableArray arrayWithObjects:
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"placehoderImg"],@"image",@" ",@"imageLabel",nil],nil];
        
        self.cheXingArr = [YLCheXingModel getDefaultDataArray];
        
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

-(void)loadCarType{
    
    NSDictionary *dic =@{@"uid":@([WoDeModel sharedWoDeModel].user_id.intValue),@"pageNum":@(pageNum),@"size":@(size)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KCarType_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"%@%@",data,error);
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
        }else{
          //提示框
          //[YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
    } isWithSign:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        
        return 3;
        
    }else if (section == 2){
        
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        //头部信息提示
        YLTopPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLTopPromptCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        cell.infoArr = [NSArray arrayWithObjects:@"icon_xingshizheng",@"第二步：填写行驶证",@"本人或其他人行驶证均可", nil];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        //信息文本框输入
        YLInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLInfoInputCell class]) forIndexPath:indexPath];
        cell.selectionStyle = 0;
        
        //认证通过用文字
        if (self.model) {
            
            cell.haveinfoArr = self.infoIndecatorArr[indexPath.row];
            
        }else{
            
            cell.infoArr = self.infoIndecatorArr[indexPath.row];
            
            [[cell.InfoTF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x){
                
                if (indexPath.row == 0) {
                    
                    self.carNumber = x;
                
                }else if(indexPath.row == 1){
                    
                    self.carOwne = x;
                }else{
                    self.carzhongliang = x;
                    cell.InfoTF.keyboardType = UIKeyboardTypeDecimalPad;
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
                
                //通过标示选择显示modal
                if (indexPath.row == 0) {
                    //车型选择
                    [UIView animateWithDuration:1.0 animations:^{
                        self.cheXingTopCons.constant = -44;
                    }];
                }else{
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        self.xingShiZhengTopCons.constant = 0;
                    }];
                }
                
                //            else if (indexPath.row == 1){
                //                [UIView animateWithDuration:1.0 animations:^{
                //                    self.chengZaiTopCons.constant = 0;
                //                }];
                //            }
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
        
    } else if (indexPath.section == 1 || indexPath.section == 2) {
        
        return  SCREEN_HEIGHT * 0.13;
    }
    return SCREEN_HEIGHT * 0.2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        v.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
        return v;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (3 == section) {
        
        YLSeleteCellHeadView *HV = [[NSBundle mainBundle]loadNibNamed:@"YLSeleteCellHeadView" owner:self options:nil].lastObject;
        HV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        HV.namelabel.text = @"上传驾驶证照片";
       
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
    
    if (3 == section) {
        
        return 30;
    }
    
    return 0.1;
}

#pragma mark ------------------collectionView ---------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.cheXingArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YLCheXingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YLCheXingCell class]) forIndexPath:indexPath];
    
    //点击背景效果
     UIView * selecteV = [UIView new];
     selecteV.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
     cell.selectedBackgroundView = selecteV;
    
     cell.model = self.cheXingArr[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSLog(@"%ld",(long)indexPath.row);
    
    self.carType =  ((YLCheXingModel *)self.cheXingArr[indexPath.row]).name;
    
    self.btnIndecatorArr[0][1] = ((YLCheXingModel *)self.cheXingArr[indexPath.row]).name;

    [self.tableView reloadData];
}

#pragma mark - modal关闭
-(void)closeModal{
    
   self.xingShiZhengTopCons.constant = self.chengZaiTopCons.constant = self.cheXingTopCons.constant = SCREEN_HEIGHT;
    
}

- (IBAction)cancleAction:(UIButton *)sender {
    [self closeModal];
}

- (IBAction)confirmAction:(UIButton *)sender {
    
    if (sender.tag == 2) {
        //NSDate格式转换为NSString格式
        NSDate *pickerDate = [self.datepicker date];
        // 获取用户通过UIDatePicker设置的日期和时间
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
        // 创建一个日期格式器
        [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
        
        self.carDate = [self getDate:pickerDate];
        
        NSLog(@"%@  %@",self.btnIndecatorArr[1],self.btnIndecatorArr[1][1]);
        
        self.btnIndecatorArr[1][1] = dateString;
        
        [self.tableView reloadData];

    }
    
    [self closeModal];
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
    
    // NSLog(@"%ld",(long)self.currentIMG);
    self.XingShiZhengimage = image;
    //修改字典数据
    [self.imageArr[0] setObject:image forKey:@"image"];
    
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
    
    [self.tableView reloadData];
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)checkCarID:(NSString *)carID; { if (carID.length!=7) { return NO; } NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$"; NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex]; return [carTest evaluateWithObject:carID]; return YES; }

@end
