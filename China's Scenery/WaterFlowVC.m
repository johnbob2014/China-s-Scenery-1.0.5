//
//  WaterFlowVC.m
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "WaterFlowVC.h"

@implementation WaterFlowVC

#pragma mark - Lazy Load

#pragma mark - init
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[self headerViewInit];
    
    [self collectionViewInit];
    
    [self addRefresh];
}


//-(void)headerViewInit{
//    /*
//     ***广告栏
//     */
//    float AD_height=150;
//    
//    self.headerView = [[AdvertisingColumn alloc]initWithFrame:CGRectMake(5, 5, fDeviceWidth-10, AD_height)];
//    self.headerView.backgroundColor = [UIColor blackColor];
//    
//    /*
//     ***加载的数据
//     */
//    NSArray *imgArray = [NSArray arrayWithObjects:@"cat.png",@"cat.png",@"cat.png",@"cat.png",@"cat.png",@"cat.png", nil];
//    [self.headerView setArray:imgArray];
//    
//}



- (void)collectionViewInit {
    WaterFlowCVLayout *layout=[[WaterFlowCVLayout alloc]init];
    layout.delegate=self;
    self.layout=layout;
    //layout.insets=UIEdgeInsetsMake(20, 20, 20, 20);
    //layout.count=4;
    
    //CGRect frame=CGRectMake(0, fNavBarHeigth, fDeviceWidth, fDeviceHeight-fToolBarHeigth);
    //UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:self.layout];
    
    UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:self.layout];
    //collectionView.collectionViewLayout=self.layout;
    collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    
     [self.view addSubview:collectionView];
    [collectionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:fNavBarHeigth];
    [collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor=[UIColor darkGrayColor];
    //collectionView.backgroundColor=[UIColor groupTableViewBackgroundColor];
   
    
    // autolayout全屏幕显示
    //[collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [collectionView registerClass:[WaterFlowCVCell class] forCellWithReuseIdentifier:WaterFlowCVCellIdentifer];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    self.collectionView=collectionView;
    
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/*
//头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    if (!headerView) {
        headerView=[UICollectionReusableView new];
    }
    
    
    [headerView addSubview:self.headerView];//头部广告栏
    return headerView;
}

//-------------------------------------------------------------------------------------------
#pragma mark 定时滚动scrollView
-(void)viewDidAppear:(BOOL)animated{//显示窗口
    [super viewDidAppear:animated];
    //    [NSThread sleepForTimeInterval:3.0f];//睡眠，所有操作都不起作用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.headerView openTimer];//开启定时器
    });
}
-(void)viewWillDisappear:(BOOL)animated{//将要隐藏窗口  setModalTransitionStyle=UIModalTransitionStyleCrossDissolve时是不隐藏的，故不执行
    [super viewWillDisappear:animated];
    if (self.headerView.totalNum>1) {
        [self.headerView closeTimer];//关闭定时器
    }
}
#pragma mark - scrollView也是适用于tableView的cell滚动 将开始和将要结束滚动时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.headerView closeTimer];//关闭定时器
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.headerView.totalNum>1) {
        [self.headerView openTimer];//开启定时器
    }
}
//===========================================================================================
*/

#pragma mark - WaterFlowCVLayout Delegate
//override this method in subclass
-(CGFloat)waterFlowCVLayout:(WaterFlowCVLayout *)waterFlowCVLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    return width;
}

#pragma mark - 首次加载的时候，应该调用旋转方法
-(void)viewWillAppear:(BOOL)animated{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
    // 首次加载的时候,单独处理
    self.loadRotate=YES;
    CGSize orignal=[UIScreen mainScreen].bounds.size;
    id<UIViewControllerTransitionCoordinator> coordinator=nil;
    [self viewWillTransitionToSize:orignal withTransitionCoordinator:coordinator];
    
    [super viewWillAppear:animated];
    
    
    //设置刷新控件的最后更新时间
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *lastUpdatedTime=[df stringFromDate:[NSDate date]];
    [self.collectionView.mj_header setLastUpdatedTimeKey:lastUpdatedTime];

}

#pragma mark - 屏幕旋转
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinato{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    CGFloat width=size.width;
    
    if (screenSize.width==width) {
        if (self.isLoadRotate) {
            self.loadRotate=NO;
        }else{
            width=size.height;
        }
    }
    
    CGFloat maxWidth=screenSize.width>screenSize.height?screenSize.width:screenSize.height;
    
    if (width==maxWidth) {
        //LandScape
        if (self.landScapeLayoutCount) {
            self.layout.count=self.landScapeLayoutCount;
        }else{
            self.layout.count=5;
        }
    }else{
        //Portrait
        if (self.portraitLayoutCount) {
            self.layout.count=self.portraitLayoutCount;
        }else{
            self.layout.count=3;
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark - 集成上拉下拉刷新功能
//static const CGFloat MJDuration = 0.5;
- (void)addRefresh {
    
    MJRefreshGifHeader *header=[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(mj_header_RefreshingAction)];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];

    self.collectionView.mj_header = header;
    
    //MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mj_header)];
}

-(void)mj_header_RefreshingAction{
    NSLog(@"WaterFlowVC:%@",NSStringFromSelector(_cmd));
//    [self.collectionView reloadData];
//    [self.collectionView.mj_header endRefreshing];
}


@end
