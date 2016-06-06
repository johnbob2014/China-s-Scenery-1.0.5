//
//  WaterFlowCVCell.m
//  WaterFlowCollectionView
//
//  Created by 张保国 on 15/12/20.
//  Copyright © 2015年 ZhangBaoGuo. All rights reserved.
//

#import "WaterFlowCVCell.h"
#import "UIImageView+WebCache.h"
#import "SceneryModel.h"
#import "UIView+AutoLayout.h"
#import "GeneralMethod.h"

@interface WaterFlowCVCell()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation WaterFlowCVCell

#pragma mark - drawRect
-(CGFloat)cornerScaleFactor{
    return self.bounds.size.height/CORNER_FONT_STANDARD_HEIGHT;
}

-(CGFloat)cornerRadius{
    return CORNER_RADIUS*[self cornerScaleFactor];
}

-(CGFloat)cornerOffset{
    return [self cornerRadius]/3.0;
}

-(void)drawRect:(CGRect)rect{
    UIBezierPath *roundedRect=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor]setFill];
    UIRectFill(self.bounds);
    
    [[UIColor whiteColor]setStroke];
    [roundedRect stroke];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc]initForAutoLayout];
        //self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.imageView.backgroundColor =[UIColor blackColor];
        
        [self.imageView sizeToFit];
        [self addSubview:self.imageView];
        [self.imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        
        self.button=[[UIButton alloc]initForAutoLayout];
        self.button.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.button];
        [self.button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 5, 10, 5) excludingEdge:ALEdgeTop];
        self.button.userInteractionEnabled=NO;
        
    }
    return self;
}

-(void)setImagePath:(NSString *)imagePath{
    //NSLog(@"WaterFlowCVCell: %@",NSStringFromSelector(_cmd));
    if (imagePath) {
        _imagePath=imagePath;
        [self.imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        //[self setNeedsDisplay];
    }
}

-(void)setImageURL:(NSURL *)imageURL{
    //NSLog(@"WaterFlowCVCell: %@",NSStringFromSelector(_cmd));
    //NSLog(@"%@",imageURL);
    if (imageURL) {
        _imageURL=imageURL;
        [SDImageCache sharedImageCache].shouldCacheImagesInMemory=NO;
        [self.imageView setShowActivityIndicatorView:YES];
        [self.imageView sd_setImageWithURL:imageURL
                          placeholderImage:nil
                                   options:SDWebImageRetryFailed|SDWebImageCacheMemoryOnly
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      
                            
                          }
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     [GM saveImageToDocumentDirectory:image forName:[imageURL lastPathComponent]];
                              
                          }
         ];
    }
    
}

-(void)setTitle:(NSString *)title{
    if (title) {
        _title=title;
        [self.button setTitle:title forState:UIControlStateNormal];
    }
}

-(UIImage *)image{
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image{
    self.imageView.image=image;
}

-(void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode{
    self.imageView.contentMode=imageViewContentMode;
}

@end
