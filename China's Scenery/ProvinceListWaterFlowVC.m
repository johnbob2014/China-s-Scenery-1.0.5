//
//  ProvinceListWaterFlowVC.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/25.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "ProvinceListWaterFlowVC.h"
#import "SceneryListWaterFlowVC.h"

#import "CSCoreDataConfig.h"
#import "SceneryModel.h"

@interface ProvinceListWaterFlowVC()

@property (nonatomic,strong) NSArray *cProvinceArray;

@end

@implementation ProvinceListWaterFlowVC

-(void)refreshCProvinceArray{
    self.cProvinceArray=nil;
    self.cProvinceArray=[CProvince cProvinceArrayInManagedObjectContext:[SceneryModel sharedModel].managedObjectContext];
}

#pragma mark - refresh
-(void)mj_header_RefreshingAction{
    [[SceneryModel sharedModel]asyncRefreshCProvinceWithCompletionBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshCProvinceArray];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            NSLog(@"%@:数据已更新！",NSStringFromClass([self class]));
        });
    }];
    
    [self performSelector:@selector(mj_header_EndRefresh) withObject:nil afterDelay:CSTimeout];
    
}

-(void)mj_header_EndRefresh{
    if (self.collectionView.mj_header.state==MJRefreshStateRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
}

#pragma mark - init

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, fToolBarHeigth, 0)];
    
    [self refreshCProvinceArray];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"中国风景";
    
    self.leftButton.hidden=YES;
    self.rightButton.hidden=YES;
    
    self.portraitLayoutCount=4;
    self.landScapeLayoutCount=6;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[SceneryModel sharedModel] checkNetWork];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - WaterFlowCVLayout Delegate
-(CGFloat)waterFlowCVLayout:(WaterFlowCVLayout *)waterFlowCVLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    //return width*(float)(580/260);
    return width*2.3;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cProvinceArray count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WaterFlowCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterFlowCVCellIdentifer forIndexPath:indexPath];
    
    if (!cell) {
        cell=[WaterFlowCVCell new];
    }
    
    CProvince *cp=self.cProvinceArray[indexPath.item];
    NSString *imageName=cp.name;
    imageName=[imageName stringByAppendingString:@".png"];
    cell.image = [UIImage imageNamed:imageName];
    cell.title= cp.name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"安徽",@"s-ah",@"澳门",@"s-am",@"北京",@"s-bj",@"重庆",@"s-cq",@"福建",@"s-fj",@"广东",@"s-gd",@"甘肃",@"s-gs",@"广西",@"s-gx",@"贵州",@"s-gz",@"海南",@"s-han",@"河北",@"s-heb",@"河南",@"s-hen",@"黑龙江",@"s-hlj",@"湖北",@"s-hub",@"湖南",@"s-hun",@"吉林",@"s-jl",@"江苏",@"s-js",@"江西",@"s-jx",@"辽宁",@"s-ln",@"内蒙古",@"s-nmg",@"宁夏",@"s-nx",@"青海",@"s-qh",@"山西",@"s-s1x",@"陕西",@"s-s3x",@"四川",@"s-sc",@"山东",@"s-
     */
    
    CProvince *cProvince=self.cProvinceArray[indexPath.row];
    [self performSegueWithIdentifier:@"showSceneryList" sender:cProvince];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[CProvince class]]) {
        CProvince *cProvince=(CProvince *)sender;
        SceneryListWaterFlowVC *slwfvc=segue.destinationViewController;
        slwfvc.cProvince=cProvince;
        slwfvc.navigationItem.title=cProvince.name;
    }
    
}

@end
