//
//  SceneryListWaterFlowVC.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/21.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "SceneryListWaterFlowVC.h"
#import "AppDelegate.h"
#import "PictureListWaterFlowVC.h"
#import "CSCoreDataConfig.h"
#import "SceneryModel.h"

@interface SceneryListWaterFlowVC ()
@property (nonatomic,strong) NSArray *sortedCSceneryArray;
@property (nonatomic,assign) BOOL netWork;
@end

@implementation SceneryListWaterFlowVC
#pragma mark - Noti

-(NSArray *)sortedCSceneryArray{
    NSSortDescriptor *aSort=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sceneryArray=[self.cProvince.sceneries sortedArrayUsingDescriptors:@[aSort]];
    return sceneryArray;
}

-(void)sceneryModelRefreshed:(id)sender{
    NSLog(@"SceneryList:接收到数据更新通知");
    [self.collectionView reloadData];
}

-(void)mj_header_RefreshingAction{
    [[SceneryModel sharedModel]asyncRefreshCProvinceWithCompletionBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=self.cProvince.name;
    self.rightButton.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.netWork=[[SceneryModel sharedModel] checkNetWork];
}

-(void)leftButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UICollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.sortedCSceneryArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WaterFlowCVCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:WaterFlowCVCellIdentifer forIndexPath:indexPath];
    
    cell.imageViewContentMode=UIViewContentModeScaleAspectFit;
    
    if (cell.image) {
        cell.image=nil;
    }
    
    CScenery *cs=self.sortedCSceneryArray[indexPath.item];
    
    cell.title=cs.name;
    
    //固定图片
    NSString *pictureName=[cs.name stringByAppendingString:@".JPG"];
    
    NSString *filePath=[GM filePathInDocumentDirectory:pictureName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        cell.imagePath=filePath;
    }else{
        if (self.netWork) {
            cell.imageURL=[[Qiniu sharedQN] downloadURLForFile:pictureName];
        }
    }
    
    //随机图片
    /*
    NSArray *pictureArray=[cs.pictures allObjects];
    
    NSUInteger pictureCount=[pictureArray count];
    if (pictureCount) {
        CPictuer *cp=pictureArray[arc4random()%(pictureCount-1)];
        NSString *pictureName=cp.thumbnailName;
        
        NSString *filePath=[GM filePathInDocumentDirectory:pictureName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            cell.imagePath=filePath;
        }else{
            if (self.netWork) {
                cell.imageURL=[[Qiniu sharedQN] downloadURLForFile:pictureName];
            }
        }
    }
    */
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CScenery *cScenery=self.sortedCSceneryArray[indexPath.item];
    [self performSegueWithIdentifier:@"showPictureList" sender:cScenery];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[CScenery class]]) {
        CScenery *cScenery=(CScenery *)sender;
        PictureListWaterFlowVC *plwfvc=segue.destinationViewController;
        plwfvc.cScenery=cScenery;
        plwfvc.navigationItem.title=cScenery.name;
    }
}


#pragma mark - WaterFlowCVLayout Delegate
-(CGFloat)waterFlowCVLayout:(WaterFlowCVLayout *)waterFlowCVLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height=width;
    return height;
    
}

@end
