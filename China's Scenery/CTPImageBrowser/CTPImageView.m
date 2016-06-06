//
//  CTPImageView.m
//  CTPImageView
//
//  Created by 张保国 on 16/1/4.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CTPImageView.h"
#import "CTPImageBrowserConfig.h"
#import "CTPWaitingView.h"
#import "UIImageView+WebCache.h"

@interface CTPImageView()<UIGestureRecognizerDelegate>

@property (strong,nonatomic) UIScrollView *backSV;
@property (strong,nonatomic) UIImageView *backScrollIV;

@property (strong,nonatomic) UIScrollView *zoomSV;
@property (strong,nonatomic) UIImageView *zoomScrollIV;

@property (strong,nonatomic) CTPWaitingView *waitingView;
@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation CTPImageView

#pragma mark - Getter & Setter

@synthesize image=_image;

-(UIImage *)image{
    if (!_image) {
        if (self.hdImage) {
            _image=self.hdImage;
        }else if (self.sdImage){
            _image=self.sdImage;
        }else if (self.sdURL){
            [self downloadImage:self.sdURL withDownLoadImageCompletionBlock:^(UIImage *image){
                self.sdImage=image;
            }];
        }
    }
    return _image;
}

-(void)setHdImage:(UIImage *)hdImage{
    _hdImage=hdImage;
    self.image=hdImage;
}

-(void)downloadImage:(NSURL *)url withDownLoadImageCompletionBlock:(DownLoadImageCompletionBlock)completionBlock{
    __weak CTPImageView *weakSelf=self;
    [SDImageCache sharedImageCache].shouldCacheImagesInMemory=NO;
    [self sd_setImageWithURL:url
            placeholderImage:self.placeholderImage
                     options:SDWebImageRetryFailed|SDWebImageCacheMemoryOnly|SDWebImageContinueInBackground
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        weakSelf.waitingView.progress=(CGFloat)receivedSize/expectedSize;
                    }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       [weakSelf.waitingView removeFromSuperview];
                       weakSelf.waitingView=nil;
                       
                       if (error) {
                           [CTPImageView showTipsLabelWithSize:CGSizeMake(150, 30) tips:@"图片加载失败" removeAfterDelay:1.2];
                       }else{
                           
                           //更新视图
                           self.zoomScrollIV.image=image;
                           //缓存图片
                           [CTPImageView saveImageToDocumentDirectory:image forName:[imageURL lastPathComponent]];
                           //执行传入的block
                           if (completionBlock) {
                               completionBlock(image);
                           }
                       }
                       
                   }];

}

+(NSString *)filePathInDocumentDirectory:(NSString *)fileName{
    if (!fileName) {
        return nil;
    }
    
    NSURL *documentDirectory=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSURL *fileLocalURL=[documentDirectory URLByAppendingPathComponent:fileName];
    NSString *filePath=[fileLocalURL path];
    
    return filePath;
}

+(void)saveImageToDocumentDirectory:(UIImage *)image forName:(NSString *)aName{
    NSString *filePath=[CTPImageView filePathInDocumentDirectory:aName];
    NSData *fileData=UIImageJPEGRepresentation(image, 1);
    
    if ([fileData writeToFile:filePath atomically:YES]) {
        NSLog(@"CTPImageSavedNotification: %@ has saved to local!",aName);
        NSMutableDictionary *userInfo=[NSMutableDictionary new];
        [userInfo setValue:filePath forKey:GMImagePathKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:GMImageSavedToDocumentDirectoryNotification object:nil userInfo:userInfo];
    }
}

-(CTPWaitingView *)waitingView{
    if (!_waitingView) {
        _waitingView=[[CTPWaitingView alloc]init];
        _waitingView.bounds=CGRectMake(0, 0, 60, 60);
        _waitingView.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _waitingView.mode=CTPWaitingViewProgressMode;
        [self insertSubview:_waitingView aboveSubview:self.zoomSV];
    }
    return _waitingView;
}

-(UIImageView *)zoomScrollIV{
    if (!_zoomScrollIV) {
        _zoomScrollIV=[[UIImageView alloc]initWithImage:self.image];
        _zoomScrollIV.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _zoomScrollIV;
}

-(void)layoutZoomScrollIV{
    self.zoomScrollIV.bounds=CGRectMake(0, 0, [self resizedImageWidth], [self resizedImageHeight]);
    self.zoomScrollIV.center=self.zoomSV.center;
}

-(UIScrollView *)zoomSV{
    if (!_zoomSV) {
        _zoomSV=[[UIScrollView alloc]init];
        _zoomSV.backgroundColor=CTPImageBrowserBackgrounColor;
        [_zoomSV addSubview:self.zoomScrollIV];
        [self addSubview:_zoomSV];
    }
    return _zoomSV;
}

-(void)layoutZoomSV{
    self.zoomSV.frame=self.bounds;
    self.zoomSV.contentSize=self.bounds.size;
}

-(CGFloat)resizedImageWidth{
    
    CGFloat resizedImageWidth=self.bounds.size.width;
    if (self.image) {
        resizedImageWidth=MIN(self.bounds.size.width, self.image.size.width/[self maxScale]);
    }else{
        resizedImageWidth=self.bounds.size.height;
    }
    return resizedImageWidth;
}


-(CGFloat)resizedImageHeight{
    CGFloat resizedImageHeight;
    CGFloat resizedImageWidth=[self resizedImageWidth];
    if (self.image) {
        resizedImageHeight=resizedImageWidth*(self.image.size.height/self.image.size.width);
        resizedImageHeight=MIN(resizedImageHeight, self.bounds.size.height);
    }else{
        resizedImageHeight=self.bounds.size.height;
    }
    return resizedImageHeight;
}



#pragma mark - imageDetailTextView Getter
-(UITextView *)imageDetailTextView{
    if (!_imageDetailTextView) {
        _imageDetailTextView=[[UITextView alloc]init];
        _imageDetailTextView.editable=NO;
        _imageDetailTextView.text=self.imageDetail;
        _imageDetailTextView.textAlignment=NSTextAlignmentNatural;
        _imageDetailTextView.textColor=[UIColor whiteColor];
        _imageDetailTextView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
        _imageDetailTextView.layer.cornerRadius=_imageDetailTextView.bounds.size.height *0.5;
        _imageDetailTextView.font=[CTPImageView bodyFontWithSizeMultiplier:0.8];
        [self insertSubview:_imageDetailTextView aboveSubview:self.zoomSV];
    }
    return _imageDetailTextView;
}

+(UIFont *)bodyFontWithSizeMultiplier:(CGFloat)multiplier{
    UIFont *bodyFont=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    return [UIFont fontWithName:bodyFont.fontName size:bodyFont.pointSize*multiplier];
}

#pragma mark - saveImageToPhotosAlbum
- (void)saveImageToPhotosAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self.indicatorView removeFromSuperview];
    
    NSString *errorString;
    if (error) {
        errorString = CTPImageBrowserSaveImageFailText;
    }else{
        errorString = CTPImageBrowserSaveImageSuccessText;
    }
    [CTPImageView showTipsLabelWithSize:CGSizeMake(150, 30) tips:errorString removeAfterDelay:1.2];
}

+(void)showTipsLabelWithSize:(CGSize)size tips:(NSString *)tips removeAfterDelay:(NSTimeInterval)delay{
    UILabel *label = [[UILabel alloc] init];
    
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0 alpha:0.9f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text=tips;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    label.center=window.center;
    label.bounds=CGRectMake(0, 0, size.width, size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:delay];
}

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.totalScale=1.0;
        
        UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureRecognizer:)];
        pinch.delegate=self;
        [self addGestureRecognizer:pinch];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self layoutZoomSV];
    
    [self layoutZoomScrollIV];
    
    [self zoomToScale:1.0];
    
    self.imageDetailTextView.frame=CGRectMake(10, self.bounds.size.height-10-80-25, self.bounds.size.width-20, 70);

}

#pragma mark - GestureRecognizer
-(void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer{
    CGFloat scale = recognizer.scale;
    CGFloat totalScale = _totalScale + (scale - 1);
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 16.0 && totalScale > _totalScale)){
        return; // 最大缩放16倍,最小0.5倍
    }else{
        [self zoomToScale:totalScale];
    }
    
    recognizer.scale = 1.0;
}

#pragma mark - Zoom
- (void)zoomToScale:(CGFloat)scale{
    self.totalScale=scale;
    
    //实现图片缩放的关键语句
    self.zoomScrollIV.transform=CGAffineTransformMakeScale(scale, scale);
    //[self logRect:self.zoomScrollIV.frame];
    
    if (scale>1) {
        self.zoomSV.contentSize=self.zoomScrollIV.frame.size;
        self.zoomScrollIV.center=CGPointMake(self.zoomScrollIV.frame.size.width/2, self.zoomScrollIV.frame.size.height/2);
        CGFloat offsetX=(self.zoomSV.contentSize.width-self.zoomSV.bounds.size.width)/2;
        CGFloat offsetY=(self.zoomSV.contentSize.height-self.zoomSV.bounds.size.height)/2;
        self.zoomSV.contentOffset=CGPointMake(offsetX, offsetY);
        
    }else{
        self.zoomSV.contentSize=self.zoomSV.frame.size;
        self.zoomSV.contentInset=UIEdgeInsetsZero;
        self.zoomScrollIV.center=self.zoomSV.center;
    }
}

- (void)zoomToScale:(CGFloat)scale animateWithDuration:(NSTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{
        [self zoomToScale:scale];
    } completion:^(BOOL finished) {
        
    }];
}

-(CGFloat)maxScale{
    return MAX(self.image.size.width/self.bounds.size.width, self.image.size.height/self.bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)logRect:(CGRect)rect{
    NSLog(@"%0.f,%0.f,%0.f,%0.f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}
@end
