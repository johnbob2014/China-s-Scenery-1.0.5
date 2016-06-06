//
//  CTPWaitingView.m
//  CTPImageView
//
//  Created by 张保国 on 16/1/5.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "CTPWaitingView.h"
#import "CTPImageBrowserConfig.h"

@implementation CTPWaitingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CTPWaitingViewBackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.mode = CTPWaitingViewModeLoopDiagram;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
    if (progress >= 1) {
        [self removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    switch (self.mode) {
        case CTPWaitingViewModePieDiagram:
        {
            CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - CTPWaitingViewItemMargin;
            
            
            CGFloat w = radius * 2 + CTPWaitingViewItemMargin;
            CGFloat h = w;
            CGFloat x = (rect.size.width - w) * 0.5;
            CGFloat y = (rect.size.height - h) * 0.5;
            CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
            CGContextFillPath(ctx);
            
            [CTPWaitingViewBackgroundColor set];
            CGContextMoveToPoint(ctx, xCenter, yCenter);
            CGContextAddLineToPoint(ctx, xCenter, 0);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
            CGContextClosePath(ctx);
            
            CGContextFillPath(ctx);
        }
            break;
            
        default:
        {
            CGContextSetLineWidth(ctx, 15);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.05; // 初始值0.05
            CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5 - CTPWaitingViewItemMargin;
            CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 0);
            CGContextStrokePath(ctx);
        }
            break;
    }
}

@end
