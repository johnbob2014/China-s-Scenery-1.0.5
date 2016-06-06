//
//  AboutVC.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/14.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *versonLabel;
@property (nonatomic,strong) UITextView *detailTextView;
@property (nonatomic,strong) UILabel *bottomLabel;

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=NSLocalizedString(@"关于", @"");
    self.rightButton.hidden=YES;
    
    [self initAboutUI];

}

-(void)leftButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)initAboutUI{
    self.imageView=[[UIImageView alloc]initForAutoLayout];
    [self.imageView setImage:[UIImage imageNamed:@"China's Scenery-180*180.png"]];
    [self.view addSubview:self.imageView];
    [self.imageView autoSetDimensionsToSize:CGSizeMake(80, 80)];
    [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:fNavBarHeigth*2];
    [self.imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:fDeviceWidth/5];
    
    self.nameLabel=[[UILabel alloc]initForAutoLayout];
    self.nameLabel.text=NSLocalizedString(@"中国风景", @"");
    self.nameLabel.font=[GM bodyFontWithSizeMultiplier:1.6];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.imageView withOffset:-10];
    [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imageView withOffset:10];
    
    self.versonLabel=[[UILabel alloc]initForAutoLayout];
    self.versonLabel.text=NSLocalizedString(@"v1.0", @"");
    self.versonLabel.font=[GM bodyFontWithSizeMultiplier:0.8];
    [self.view addSubview:self.versonLabel];
    [self.versonLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.nameLabel];
    [self.versonLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.imageView withOffset:-10];

    self.bottomLabel=[[UILabel alloc]initForAutoLayout];
    self.bottomLabel.text=NSLocalizedString(@"2016 CTP Technology Co.,Ltd", @"");
    self.bottomLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.bottomLabel];
    [self.bottomLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 20, 20, 20) excludingEdge:ALEdgeTop];
    [self.bottomLabel autoSetDimension:ALDimensionHeight toSize:60];
    
    self.detailTextView=[[UITextView alloc]initForAutoLayout];
    self.detailTextView.editable=NO;
    self.detailTextView.font=[GM bodyFontWithSizeMultiplier:0.8];
    self.detailTextView.text=NSLocalizedString(@"      每每出行，总想提前了解一下目的地的情况，最快捷、最直观的办法就是浏览照片。而网上搜索到的照片大多是良莠不齐，或者不清晰，或者不准确；游记则大多冗长啰嗦，看着太累，有悖于出行放松的初衷。\n      《中国风景》旨在让这一切变得简单方便——它依据省份划分各个景点，提供原创、超清、经典、唯美的景点图片，再搭配简洁的文字说明，让你虽未身临其地，但已心入其境。\n       没有广告、没有“跪求好评”，只为给你一点悠闲安静的空间，带你走进三山五岳、烟雨江南，陪你踏遍大江南北、万里河山。\n      看过《中国风景》，无论你去或者不去，它都已经根植于你的记忆中,回味悠长。", @"");
    [self.view addSubview:self.detailTextView];
    [self.detailTextView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageView withOffset:20];
    [self.detailTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.detailTextView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [self.detailTextView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomLabel withOffset:20];
}

@end
