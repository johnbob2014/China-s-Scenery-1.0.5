//
//  CTPImageBrowserVC.m
//  CTPImageView
//
//  Created by 张保国 on 16/1/5.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CTPImageBrowserVC.h"
#import "CTPImageBrowserConfig.h"
#import "CTPImageView.h"

@interface CTPImageBrowserVC ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIScrollView *containerSV;
@property (nonatomic,strong) UILabel *imageIndexLabel;
@property (nonatomic,strong) UIButton *backButton;


@property (strong,nonatomic) UIButton *saveButton;
@property (strong,nonatomic) UIButton *hdButton;

@property (nonatomic,assign) NSInteger purchasedCoins;
@property (assign,nonatomic) BOOL accessoryHasHidden;

@property (nonatomic,assign) CTPImageView *currentImageView;

@end

@implementation CTPImageBrowserVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=CTPImageBrowserBackgrounColor;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.containerSV.bounds=self.view.bounds;
    self.containerSV.center=self.view.center;
    
    [self.containerSV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat x=idx*self.view.bounds.size.width;
        obj.frame=CGRectMake(x, 0, self.containerSV.bounds.size.width, self.containerSV.bounds.size.height);
        
    }];
    
    self.containerSV.contentSize=CGSizeMake(self.imageCount*self.view.bounds.size.width, self.view.bounds.size.height);
    self.containerSV.contentOffset=CGPointMake(self.currentImageIndex*self.view.bounds.size.width, 0);
    
    self.imageIndexLabel.center = CGPointMake(self.view.bounds.size.width * 0.5, 35);
    self.backButton.frame=CGRectMake(self.view.bounds.size.width-50-10, self.view.bounds.size.height-25-10,50,25);
    self.saveButton.frame = CGRectMake(10, self.view.bounds.size.height-25-10, 50, 25);
    self.hdButton.frame=CGRectMake(_saveButton.frame.origin.x+_saveButton.frame.size.width+10, _saveButton.frame.origin.y, 130, 25);
    
    if (self.currentImageView.hdImage) {
        self.hdButton.hidden=YES;
    }else{
        self.hdButton.hidden=self.accessoryHasHidden;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
    self.currentImageIndex=(scrollView.contentOffset.x+self.view.bounds.size.width*0.5)/self.view.bounds.size.width;
    self.imageIndexLabel.text=[NSString stringWithFormat:@"%ld/%ld", self.currentImageIndex + 1, (long)self.imageCount];
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CTPImageView *currentIV=scrollView.subviews[self.currentImageIndex];
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - self.currentImageIndex * self.view.bounds.size.width) > margin || (x - self.currentImageIndex * self.view.bounds.size.width) < - margin) {
        
        if (currentIV.totalScale!=1.0) {
            [UIView animateWithDuration:0.5 animations:^{
                currentIV.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [currentIV zoomToScale:1.0];
            }];
        }
    }
    
    //更换图片时，是否显示高清大图按钮
    if (self.currentImageView.hdImage) {
        self.hdButton.hidden=YES;
    }else{
        self.hdButton.hidden=self.accessoryHasHidden;
    }

}

#pragma mark - Getter&Setter

-(CTPImageView *)currentImageView{
    return self.containerSV.subviews[self.currentImageIndex];
}

-(UIScrollView *)containerSV{
    if (!_containerSV) {
        _containerSV=[[UIScrollView alloc]init];
        _containerSV.delegate=self;
        _containerSV.showsHorizontalScrollIndicator=YES;
        _containerSV.showsVerticalScrollIndicator=YES;
        _containerSV.pagingEnabled=YES;
        
        
        UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
        doubleTap.delegate=self;
        doubleTap.numberOfTapsRequired=2;
        [_containerSV addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        singleTap.delegate=self;
        [_containerSV addGestureRecognizer:singleTap];
        
        [self.multiImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CTPImageView *iv=[[CTPImageView alloc]init];
            CTPMultiImage *multi=self.multiImageArray[idx];
            
            iv.sdImage=multi.sdImage;
            iv.hdImage=multi.hdImage;
            iv.placeholderImage=multi.placeholderImage;
            iv.sdURL=multi.sdURL;
            iv.hdURL=multi.hdURL;
            iv.imageDetail=multi.imageDetail;
            
            [_containerSV addSubview:iv];
        }];
        
        [self.view addSubview:_containerSV];

    }
    return _containerSV;
}


-(void)singleTapGestureRecognizer:(UIPinchGestureRecognizer *)recognizer{
    self.accessoryHasHidden=!self.accessoryHasHidden;
}

-(void)doubleTapGestureRecognizer:(UIPinchGestureRecognizer *)recognizer{
    if (self.currentImageView.totalScale==1.0) {
        [self.currentImageView zoomToScale:[self.currentImageView maxScale]];
    }else{
        [self.currentImageView zoomToScale:1.0];
    }
}


-(UILabel *)imageIndexLabel{
    if (!_imageIndexLabel) {
        _imageIndexLabel = [[UILabel alloc] init];
        _imageIndexLabel.bounds = CGRectMake(0, 0, 80, 30);
        _imageIndexLabel.textAlignment = NSTextAlignmentCenter;
        _imageIndexLabel.textColor = [UIColor whiteColor];
        _imageIndexLabel.font = [UIFont boldSystemFontOfSize:20];
        _imageIndexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _imageIndexLabel.layer.cornerRadius = _imageIndexLabel.bounds.size.height * 0.5;
        _imageIndexLabel.clipsToBounds = YES;
        if (self.imageCount > 1) {
            _imageIndexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        }
        [self.view insertSubview:_imageIndexLabel aboveSubview:self.containerSV];
    }
    return _imageIndexLabel;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        _backButton.layer.cornerRadius = 1;
        _backButton.layer.borderWidth=1.0f;
        _backButton.layer.borderColor=[UIColor whiteColor].CGColor;
        _backButton.clipsToBounds = YES;
        [_backButton addTarget:self action:@selector(closeBrowser) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_backButton aboveSubview:self.containerSV];
    }
    return _backButton;
}

-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        _saveButton.layer.cornerRadius = 1;
        _saveButton.layer.borderWidth =1.0f;
        _saveButton.layer.borderColor=[UIColor whiteColor].CGColor;
        _saveButton.clipsToBounds = YES;
        [_saveButton addTarget:self action:@selector(saveImageToPhotosAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_saveButton aboveSubview:self.containerSV];
    }
    return _saveButton;
}

-(void)saveImageToPhotosAlbum{
    [self.currentImageView saveImageToPhotosAlbum];
}

-(UIButton *)hdButton{
    if (!_hdButton) {
        _hdButton = [[UIButton alloc] init];
        NSString *hdButtonTitle=[[NSString alloc]initWithFormat:@"高清大图(%d)",(int)self.purchasedCoins];
        [_hdButton setTitle:hdButtonTitle forState:UIControlStateNormal];
        [_hdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _hdButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        _hdButton.layer.cornerRadius = 1;
        _hdButton.layer.borderWidth=1.0f;
        _hdButton.layer.borderColor=[UIColor whiteColor].CGColor;
        _hdButton.clipsToBounds = YES;
        [_hdButton addTarget:self action:@selector(showHDImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_hdButton aboveSubview:self.containerSV];
    }
    return _hdButton;
}

-(void)showHDImage{
    if(self.purchasedCoins>0){
        //调用CTPImageView的方法下载大图，如果下载成功，图币减少
        [self.currentImageView downloadImage:self.currentImageView.hdURL withDownLoadImageCompletionBlock:^(UIImage *image) {
            
            if (image) {
                self.currentImageView.hdImage=image;
                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    self.hdButton.hidden=YES;
//                    self.purchasedCoins--;
//                    [self.currentImageView zoomToScale:self.currentImageView.maxScale];
//                });
                
                self.hdButton.hidden=YES;
                self.purchasedCoins--;
                NSString *hdButtonTitle=[[NSString alloc]initWithFormat:@"高清大图(%d)",(int)self.purchasedCoins];
                [self.hdButton setTitle:hdButtonTitle forState:UIControlStateNormal];
                [self.currentImageView zoomToScale:self.currentImageView.maxScale];
            
            }
            
        }];
        
    }else{
        [self.hdButton setTitle:@"图币不足" forState:UIControlStateNormal];
    }
}

-(void)setAccessoryHasHidden:(BOOL)accessoryHasHidden{
    _accessoryHasHidden=accessoryHasHidden;
    self.saveButton.hidden=accessoryHasHidden;
    self.backButton.hidden=accessoryHasHidden;
    self.imageIndexLabel.hidden=accessoryHasHidden;

    if (self.currentImageView.hdImage) {
        self.hdButton.hidden=YES;
    }else{
        self.hdButton.hidden=accessoryHasHidden;
    }
    
    for (UIView *view in self.containerSV.subviews) {
        if ([view isKindOfClass:[CTPImageView class]]) {
            CTPImageView *iv=(CTPImageView *)view;
            iv.imageDetailTextView.hidden=accessoryHasHidden;
        }
    }
}


#pragma mark - purchasedCoins
@synthesize purchasedCoins=_purchasedCoins;

-(NSInteger)purchasedCoins{
    if (!_purchasedCoins) {
        NSInteger coins=[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedCoins"];
        if (coins) {
            _purchasedCoins=(NSInteger)coins;
        }else{
            _purchasedCoins=20;
        }

    }
    return _purchasedCoins;
}

-(void)setPurchasedCoins:(NSInteger)purchasedCoins{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:purchasedCoins forKey:@"purchasedCoins"];
    [defaults synchronize];
    _purchasedCoins=purchasedCoins;
    
}


- (void)closeBrowser{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)logRect:(CGRect)rect{
    NSLog(@"%0.f,%0.f,%0.f,%0.f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
}

@end
