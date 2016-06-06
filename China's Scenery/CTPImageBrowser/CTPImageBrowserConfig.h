//
//  CTPImageBrowserConfig.h
//  CTPImageView
//
//  Created by 张保国 on 16/1/5.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#ifndef CTPImageBrowserConfig_h
#define CTPImageBrowserConfig_h

typedef enum {
    CTPWaitingViewModeLoopDiagram, // 环形
    CTPWaitingViewModePieDiagram // 饼型
} CTPWaitingViewMode;

// 图片保存成功提示文字
#define CTPImageBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define CTPImageBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define CTPImageBrowserBackgrounColor [UIColor blackColor]
//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define CTPImageBrowserImageViewMargin 10

// browser中显示图片动画时长
#define CTPImageBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define CTPImageBrowserHideImageAnimationDuration 0.3f

// 图片下载进度指示进度显示样式（CTPWaitingViewModeLoopDiagram 环形，CTPWaitingViewModePieDiagram 饼型）
#define CTPWaitingViewProgressMode CTPWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define CTPWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define CTPWaitingViewItemMargin 10


#define GMImageSavedToDocumentDirectoryNotification @"GMImageSavedToDocumentDirectoryNotification"
#define GMImagePathKey @"GMImagePathKey"

#endif /* CTPImageBrowserConfig_h */

