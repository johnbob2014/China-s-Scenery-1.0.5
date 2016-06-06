//
//  Image&DetailTVCell.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/9.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "Image&DetailTVCell.h"
#import "UIView+AutoLayout.h"
#import "UIImageView+WebCache.h"
#import "GeneralMethod.h"

@interface Image_DetailTVCell()

@property (strong, nonatomic) UIButton *isInFavouritesButton;
@property (strong, nonatomic) UIImageView *cellImageView;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *detailLabel;

@end

@implementation Image_DetailTVCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.cellImageView = [[UIImageView alloc]initForAutoLayout];
        //self.cellImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //self.cellImageView.backgroundColor =[[UIColor brownColor] colorWithAlphaComponent:0.5];
        self.cellImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [self.cellImageView sizeToFit];
        [self addSubview:self.cellImageView];
        [self.cellImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 20, 5, 5) excludingEdge:ALEdgeRight];
        [self.cellImageView autoSetDimension:ALDimensionWidth toSize:self.frame.size.height+10];
        
        self.nameLabel=[[UILabel alloc]initForAutoLayout];
        [self addSubview:self.nameLabel];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.cellImageView withOffset:10];
        [self.nameLabel sizeToFit];
        
        self.detailLabel=[[UILabel alloc]initForAutoLayout];
        [self addSubview:self.detailLabel];
        [self.detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.cellImageView withOffset:10];
        [self.detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:20];
        [self.detailLabel sizeToFit];
        
        self.isInFavouritesButton=[[UIButton alloc]initForAutoLayout];
        [self addSubview:self.isInFavouritesButton];
        [self.isInFavouritesButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 5, 5) excludingEdge:ALEdgeLeft];
        
        //[GM logRect:self.cellImageView.frame];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImagePath:(NSString *)imagePath{
    //NSLog(@"WaterFlowCVCell: %@",NSStringFromSelector(_cmd));
    if (imagePath) {
        _imagePath=imagePath;
        [self.cellImageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        //[self setNeedsDisplay];
    }
}

-(void)setImageURL:(NSURL *)imageURL{
    //NSLog(@"WaterFlowCVCell: %@",NSStringFromSelector(_cmd));
    //NSLog(@"%@",imageURL);
    if (imageURL) {
        _imageURL=imageURL;
        [SDImageCache sharedImageCache].shouldCacheImagesInMemory=NO;
        [self.cellImageView setShowActivityIndicatorView:YES];
        [self.cellImageView sd_setImageWithURL:imageURL
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

-(void)setName:(NSString *)name{
    self.nameLabel.text=name;
}

-(void)setDetail:(NSString *)detail{
    self.detailLabel.text=detail;
}

-(void)setIsInFavourites:(BOOL)isInFavourites{
    NSString *title;
    if (isInFavourites) {
        title=@"⭐️";
    }else{
        title=@"☆";
    }
    [self.isInFavouritesButton setTitle:title forState:UIControlStateNormal];
}

-(UIImage *)image{
    return self.cellImageView.image;
}

-(void)setImage:(UIImage *)image{
    self.cellImageView.image=image;
}

-(void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode{
    self.imageView.contentMode=imageViewContentMode;
}

@end
