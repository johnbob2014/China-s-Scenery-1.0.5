//
//  WaterFlowCVLayout.h
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowCVLayout;
@protocol  WaterFlowCVLayoutDelegate <NSObject>
/*通过代理获得每个cell的高度(之所以用代理取得高度的值，就是为了解耦，这里定义的WaterFlowCVLayout不依赖于任务模型数据)*/
- (CGFloat)waterFlowCVLayout:(WaterFlowCVLayout *)waterFlowCVLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end

@interface WaterFlowCVLayout : UICollectionViewLayout
/*cell的列间距*/
@property (nonatomic,assign) CGFloat columnMargin;
/*cell的行间距*/
@property (nonatomic,assign) CGFloat rowMargin;
/*collectionView的top,right,bottom,left间距*/
@property (nonatomic,assign) UIEdgeInsets insets;
/*显示多少列*/
@property (nonatomic,assign) NSInteger count;

@property (nonatomic,assign) id<WaterFlowCVLayoutDelegate> delegate;

@end

