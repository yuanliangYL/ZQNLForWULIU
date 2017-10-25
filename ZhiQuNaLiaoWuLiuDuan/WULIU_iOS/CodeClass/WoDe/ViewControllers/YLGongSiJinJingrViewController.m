//
//  YLGongSiJinJingrViewController.m
//  ZQNLForPackagingStation
//
//  Created by Miaomiao Dai on 2017/9/8.
//  Copyright © 2017年 Albert Yuan. All rights reserved.
//

#import "YLGongSiJinJingrViewController.h"
#import "YLJinJingCollectionViewCell.h"
#import "YLGongSiAddPhotonsViewController.h"


@interface YLGongSiJinJingrViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *rightBarBtn;
@property BOOL isSelectOriginalPhoto;

//保存服务器图片数组，以便本地增加与删除操作
@property(nonatomic,strong)NSMutableArray *remoteImgArr;
//全路径数组
@property(nonatomic,strong)NSMutableArray *photosArray;

@property(nonatomic,strong)YLMBProgressHUD *hud;

//图片数组字符串
@property(nonatomic,strong)NSString *carPhotosStr;

@end

@implementation YLGongSiJinJingrViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initData];
}

-(void)initData{
    
    //个人信息
    NSDictionary *dic =@{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(6)};
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"33%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            //车照片
            if( data[@"data"][@"ld_truck_photo"] == [NSNull null]) {
                
                 self.carPhotosStr = @"暂无图片数据";
                
                 [YLMBProgressHUD initWithString:self.carPhotosStr inSuperView:self.view afterDelay:1.5];
                
            }else{
                
                self.carPhotosStr = data[@"data"][@"ld_truck_photo"];

                self.remoteImgArr = [self.carPhotosStr componentsSeparatedByString:@","].mutableCopy;
                
                self.photosArray = [NSMutableArray new];
                
                [self.photosArray removeAllObjects];
                
                //上级图片数据处理
                for (int i = 0; i < self.remoteImgArr.count; i ++) {
                    
                    NSString* imgstr = [NSString stringWithFormat:@"%@%@",kDownImage_URL,self.remoteImgArr[i]];
                    
                    NSLog(@"11111111111%@",imgstr);
                    
                    [self.photosArray addObject:imgstr];
                }
                
                [self.view addSubview:self.collectionView];
                
                [self.collectionView reloadData];
                
            }
            
        }else{
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:1.5];
        }
        
    } isWithSign:YES];
}

-(YLMBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [YLMBProgressHUD initProgressInView:self.view];
    }
    
    return _hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"货车照片";
    
    self.rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBarBtn.frame = CGRectMake(0, 0, 44, 44);
    [self.rightBarBtn setImage:[UIImage imageNamed:@"daohang_bianji"] forState:UIControlStateNormal];
    [self.rightBarBtn setImage:[UIImage imageNamed:@"daohang_cancel"] forState:UIControlStateSelected];
    [self.rightBarBtn addTarget:self action:@selector(bianjiClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn];

}

//删除操作按钮
- (void)bianjiClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.isSelected) {
        
        [self.collectionView layoutIfNeeded];
        [self.collectionView reloadData];
        
    }else {
        
        
    }
    
    [self.collectionView reloadData];
}

#pragma mark - lazy

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        _margin = 20;
        _itemWH = (self.view.bounds.size.width - 3 * _margin ) / 2 ;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH - 60)/ 2, (SCREEN_WIDTH - 60)/ 2);
        flowLayOut.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114) collectionViewLayout:flowLayOut];
        
        _collectionView.backgroundColor = [UIColor yl_toUIColorByStr:@"#f2f2f2"];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YLJinJingCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"collection"];
        self.collectionView.scrollEnabled = YES;
    }
    
    return _collectionView;
}


#pragma mark ------------------collectionView ---------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"%lu",(unsigned long)self.photosArray.count);
    
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YLJinJingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
     cell.deletBtn.tag = indexPath.row;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.photosArray[indexPath.row]]];
 
    [cell.imageView LFLHeadimageBrowser];
    
    if (!self.rightBarBtn.isSelected) {
       
        cell.deletBtn.hidden = YES;
       
    }else {

         cell.deletBtn.hidden = NO;
         [cell.deletBtn addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return cell;
}


//删除操作
- (void)deletePhotos:(UIButton *)sender{
    
    [self.hud show:YES];
    //临时数组储存原始状态
    NSInteger tempArr = self.remoteImgArr.count;
    NSArray *tempArray = [NSArray arrayWithArray:self.remoteImgArr];
    
    NSString *newstr = nil;
    
    if (self.remoteImgArr.count == 1) {
        
        newstr = @"deleteall";
        self.carPhotosStr = @"暂无图片数据";
        [self loadImagePath:newstr withBtn:sender];
        
    }else{
        
        for (NSInteger i = 0; i < tempArr; i++) {
            
            //删除数组中选中的项目
            if (sender.tag == i) {
                
                [self.remoteImgArr removeObject:self.remoteImgArr[i]];
                
            }else{
                
                if (newstr == nil) {
                    
                    newstr = tempArray[i];
                    
                }else{
                    
                    newstr = [NSString stringWithFormat:@"%@,%@",newstr,tempArray[i]];
                }
                
            }
        }
        self.carPhotosStr = newstr;
        [self loadImagePath:newstr withBtn:sender];
    }
}

//网络删除操作
-(void)loadImagePath:(NSString *)imgStr withBtn:(UIButton *)sender{
    
    NSDictionary *dic = nil;
    
    if( [imgStr isEqualToString:@"deleteall"]){
        
        dic = @{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(2)};
        
    }else{
        
       
        dic = @{@"uid":@(([WoDeModel sharedWoDeModel].user_id).intValue),@"type":@(2),@"car_photos":imgStr};
    }
    
    
    [[SDNetAPIClient sharedSDNetAPIClient] requestJsonDataWithPath:KUserInfo_URL withParams:dic withMethodType:Post andBlock:^(id data, NSError *error, NSString *errorMsg) {
        
        NSLog(@"33%@",data);
        
        if (data && [data [@"status_code"] integerValue] == 10000) {
            
            [_photosArray removeObjectAtIndex:sender.tag];
            [_collectionView performBatchUpdates:^{
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
                
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
                
                [_collectionView reloadData];
                
            } completion:^(BOOL finished) {
                
                [_collectionView reloadData];
            }];
    
        
        }else{
            
            //提示框
            [YLMBProgressHUD initWithString:data[@"msg"] inSuperView:self.view afterDelay:2];
        }
        
        [self.hud hide:YES];
        
    } isWithSign:YES];
}


//添加照片
- (IBAction)addPhotos:(id)sender {
    
    YLGongSiAddPhotonsViewController *addVC = [[YLGongSiAddPhotonsViewController alloc] init];
    
    addVC.carPhotosStr = self.carPhotosStr;

    [self.navigationController pushViewController:addVC animated:YES];
}

@end
