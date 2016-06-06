//
//  CTPImageView.h
//  CTPImageView
//
//  Created by 张保国 on 16/1/4.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownLoadImageCompletionBlock)(UIImage *image);

@interface CTPImageView : UIImageView

@property (nonatomic,strong) UIImage *sdImage;
@property (nonatomic,strong) UIImage *hdImage;
@property (nonatomic,strong) UIImage *placeholderImage;
@property (nonatomic,strong) NSURL *sdURL;
@property (nonatomic,strong) NSURL *hdURL;

@property (nonatomic,strong) NSString *imageDetail;

@property (strong,nonatomic) UITextView *imageDetailTextView;

@property (assign,nonatomic) CGFloat totalScale;

- (void)downloadImage:(NSURL *)url withDownLoadImageCompletionBlock:(DownLoadImageCompletionBlock)completionBlock;

- (void)saveImageToPhotosAlbum;

- (CGFloat)maxScale;

- (void)zoomToScale:(CGFloat)scale;

@end
