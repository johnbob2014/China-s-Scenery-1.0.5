//
//  PictureListWaterFlowVC.m
//  China's Scenery
//
//  Created by 张保国 on 15/12/21.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "PictureListWaterFlowVC.h"
#import "CTPImageBrowserVC.h"
#import "CSCoreDataConfig.h"
#import "SceneryModel.h"

@interface PictureListWaterFlowVC ()

@property (strong,nonatomic) NSArray *sortedCPictureArray;
@property (assign,nonatomic) BOOL netWork;

@end

@implementation PictureListWaterFlowVC

-(NSArray *)sortedCPictureArray{
    NSSortDescriptor *aSort=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *pictureArray=[self.cScenery.pictures sortedArrayUsingDescriptors:@[aSort]];
    return pictureArray;
}

-(void)mj_header_RefreshingAction{
    [[SceneryModel sharedModel]asyncRefreshCScenery:self.cScenery.name completionBlock:^{
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
    
    if (![self.cScenery.pictures count]) {
        [self.collectionView.mj_header beginRefreshing];
    }
    
    self.title=self.cScenery.name;
    self.portraitLayoutCount=2;
    self.landScapeLayoutCount=3;
}

-(void)viewWillLayoutSubviews{
    [self updateFavouriteButtonTitle];
    self.netWork=[[SceneryModel sharedModel]checkNetWork];
}

#pragma mark - User
-(void)leftButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)rightButtonPressed:(id)sender{
    
    BOOL isIn=[self.cScenery.isInFavourites boolValue];
    isIn=!isIn;
    self.cScenery.isInFavourites=[NSNumber numberWithBool:isIn];
    [[SceneryModel sharedModel].managedObjectContext save:NULL];
    [self updateFavouriteButtonTitle];
}

-(void)updateFavouriteButtonTitle{
    if ([self.cScenery.isInFavourites boolValue]) {
        [self.rightButton setTitle:@"⭐️" forState:UIControlStateNormal];
    }else{
        [self.rightButton setTitle:@"☆" forState:UIControlStateNormal];
    }
}

#pragma mark - UICollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.sortedCPictureArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WaterFlowCVCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:WaterFlowCVCellIdentifer forIndexPath:indexPath];
    cell.imageViewContentMode=UIViewContentModeScaleToFill;
    
    CPictuer *cp=self.sortedCPictureArray[indexPath.item];
    NSString *pictureName=cp.thumbnailName;
    
    NSString *filePath=[GM filePathInDocumentDirectory:pictureName];
    
    cell.title=[cp.scenery.name stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)(indexPath.item+1)]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        cell.imagePath=filePath;
    }else{
        //NSLog(@"%@",pictureName);
        if (self.netWork) {
            cell.imageURL=[[Qiniu sharedQN] downloadURLForFile:pictureName];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"showImageBrowser" sender:indexPath];
    
}

#pragma mark - WaterFlowCVLayout Delegate
-(CGFloat)waterFlowCVLayout:(WaterFlowCVLayout *)waterFlowCVLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    CGFloat height=width;
    
    CPictuer *cp=self.sortedCPictureArray[indexPath.item];
    if (cp.width && cp.height && cp.width!=0) {
        height=[cp.height floatValue]/[cp.width floatValue]*width;
    }
    
    //NSLog(@"height:%.2f",height);
    return height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        CTPImageBrowserVC *ibVC=segue.destinationViewController;
        ibVC.currentImageIndex=((NSIndexPath *)sender).item;
        NSUInteger imageCount=[self.sortedCPictureArray count];
        ibVC.imageCount=imageCount;
        
        NSMutableArray *multiImageArray=[[NSMutableArray alloc]initWithCapacity:imageCount];
        [self.sortedCPictureArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CPictuer *cp=(CPictuer *)obj;
            NSString *thumbnailPath=[GM filePathInDocumentDirectory:cp.thumbnailName];
            NSString *picPath=[GM filePathInDocumentDirectory:cp.name];
            //如果网络不可用，下载URL置空，这样就不会使用网络了
            NSURL *sdURL=self.netWork?[[Qiniu sharedQN] downloadURLForFile:cp.thumbnailName]:nil;
            NSURL *hdURL=self.netWork?[[Qiniu sharedQN] downloadURLForFile:cp.name]:nil;
            CTPMultiImage *multi=[CTPMultiImage initWithSdImage:[UIImage imageWithContentsOfFile:thumbnailPath]
                                                        hdImage:[UIImage imageWithContentsOfFile:picPath]
                                               placeholderImage:nil
                                                          sdURL:sdURL
                                                          hdURL:hdURL
                                                    imageDetail:cp.detail];
            [multiImageArray addObject:multi];
        }];
        
        ibVC.multiImageArray=multiImageArray;
    }
}

@end
