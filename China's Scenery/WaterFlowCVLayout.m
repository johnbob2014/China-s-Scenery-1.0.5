//
//  WaterFlowCVLayout.m
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "WaterFlowCVLayout.h"

@interface WaterFlowCVLayout()
/* Key: 第几列; Value: 保存每列的cell的底部y值 */
@property (nonatomic,strong) NSMutableDictionary *cellInfo;
@end

@implementation WaterFlowCVLayout

#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.insets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.count = 3;
    }
    return self;
}

- (NSMutableDictionary *)cellInfo {
    if (!_cellInfo) {
        _cellInfo = [NSMutableDictionary dictionary];
    }
    return _cellInfo;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 可以在每次旋转屏幕的时候，重新计算
    for (int i=0; i<self.count; i++) {
        NSString *index = [NSString stringWithFormat:@"%d",i];
        self.cellInfo[index] = @(self.insets.top);
    }
}

#pragma mark - 处理所有的Item的layoutAttributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 每次重新布局之前，先清除掉以前的数据(因为屏幕滚动的时候也会调用)
    __weak typeof (self) wSelf = self;
    [self.cellInfo enumerateKeysAndObjectsUsingBlock:^(NSString *columnIndex, NSNumber *minY, BOOL *stop) {
        wSelf.cellInfo[columnIndex] = @(wSelf.insets.top);
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    
    return array;
}

#pragma mark - 处理单个的Item的layoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取cell底部Y值最小的列
    __block NSString *minYForColumn = @"0";
    __weak typeof (self) wSelf = self;
    [self.cellInfo enumerateKeysAndObjectsUsingBlock:^(NSString *columnIndex, NSNumber *minY, BOOL *stop) {
        if ([minY floatValue] < [wSelf.cellInfo[minYForColumn] floatValue]) {
            minYForColumn = columnIndex;
        }
    }];
    
    CGFloat width = (self.collectionView.frame.size.width - self.insets.left - self.insets.right - self.columnMargin * (self.count - 1)) / self.count;
    CGFloat height = [self.delegate waterFlowCVLayout:self heightForWidth:width atIndexPath:indexPath];
    CGFloat x = self.insets.left + (width + self.columnMargin) * [minYForColumn integerValue];
    CGFloat y = self.rowMargin + [self.cellInfo[minYForColumn] floatValue];
    
    self.cellInfo[minYForColumn] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize {
    CGFloat width = self.collectionView.frame.size.width;
    
    __block CGFloat maxY = 0;
    [self.cellInfo enumerateKeysAndObjectsUsingBlock:^(NSString *columnIndex, NSNumber *itemMaxY, BOOL *stop) {
        if ([itemMaxY floatValue] > maxY) {
            maxY = [itemMaxY floatValue];
        }
    }];
    
    return CGSizeMake(width, maxY + self.insets.bottom);
}

@end
