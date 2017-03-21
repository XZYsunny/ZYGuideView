//
//  ZYGuideView.h
//  ZYGuideViewDemo
//
//  Created by sunny on 2017/3/20.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYGuideView : UIView

/**
 *  创建guideView
 */
+ (instancetype)shardZYGuideView;
/**
 *  带按钮的引导页
 *
 *  @param imageNames      背景图片数组
 *  @param enterBtnImageName 最后一页进入按钮，nil 的不显示，@""为透明button
 */
- (void)createImageNamesArray:(NSMutableArray *)imageNames EnterBtnImageName:(NSString *)enterBtnImageName;
/**
 *  在最后一页再次向右滑动是否隐藏引导页
 *  default YES
 */
@property (nonatomic,assign) BOOL isScrollOut;

/**
 *  是否显示pageControl
 */
@property (nonatomic, assign) BOOL isShowPageControl;
/**
 *  选中pageControl的指示器颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *currentColor;
/**
 *  未选中状态下的pageControl的颜色，默认灰色
 */
@property (nonatomic, strong) UIColor *nomalColor;

@end
