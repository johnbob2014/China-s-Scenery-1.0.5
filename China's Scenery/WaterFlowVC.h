//
//  WaterFlowVC.h
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowCVLayout.h"
#import "WaterFlowCVCell.h"
//#import "AdvertisingColumn.h"
#import "NavigationBarVC.h"
#import "MJRefresh.h"

#define WaterFlowCVCellIdentifer @"WaterFlowCVCell"

@class WaterFlowCVLayout;

@interface WaterFlowVC : NavigationBarVC<UICollectionViewDataSource,UICollectionViewDelegate,WaterFlowCVLayoutDelegate>

@property (nonatomic,weak) WaterFlowCVLayout *layout;
@property (nonatomic,assign) int portraitLayoutCount;
@property (nonatomic,assign) int landScapeLayoutCount;

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,assign,getter=isLoadRotate) BOOL loadRotate;

//@property (nonatomic,strong) AdvertisingColumn *headerView;

//- (void)collectionViewInit;

-(void)mj_header_RefreshingAction;

@end
