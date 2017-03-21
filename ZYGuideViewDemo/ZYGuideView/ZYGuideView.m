//
//  ZYGuideView.m
//  ZYGuideViewDemo
//
//  Created by sunny on 2017/3/20.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ZYGuideView.h"

@interface ZYGuideView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView  *launchScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *imageNamesArray;
@property (nonatomic,copy) NSString *enterBtnImage;
@property (nonatomic,strong)UIButton *enterButton;

@end

@implementation ZYGuideView

+ (instancetype)shardZYGuideView{
    ZYGuideView *guideView = [[ZYGuideView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    return guideView;
}
- (void)createImageNamesArray:(NSMutableArray *)imageNames EnterBtnImageName:(NSString *)enterBtnImageName{
        self.isScrollOut = NO;
        self.imageNamesArray = imageNames;
        self.isShowPageControl = NO;
        _enterBtnImage = enterBtnImageName;
        _currentColor = [UIColor blackColor];
        _nomalColor = [UIColor lightGrayColor];
        [self createUI];
}

- (void)setIsShowPageControl:(BOOL)isShowPageControl{
    _isShowPageControl = isShowPageControl;
    if (_isShowPageControl) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 30)];
        self.pageControl.numberOfPages = self.imageNamesArray.count;
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.currentPage = 0;
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPageIndicatorTintColor = _currentColor;
        self.pageControl.pageIndicatorTintColor = _nomalColor;
        [self addSubview:self.pageControl];
    }
}
- (void)setCurrentColor:(UIColor *)currentColor{
    _currentColor = currentColor;
    if (_isShowPageControl) {
        self.pageControl.currentPageIndicatorTintColor = currentColor;
    }
}
- (void)setNomalColor:(UIColor *)nomalColor{
    _nomalColor = nomalColor;
    if (_isShowPageControl) {
        self.pageControl.pageIndicatorTintColor = nomalColor;
    }
}
- (void)setIsScrollOut:(BOOL)isScrollOut{
    _isScrollOut = isScrollOut;
}
- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    if ([self isFirstLauch]) {
        [self createScrollView];
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        [window addSubview:self];
    }else{
        [self removeFromSuperview];
    }
}
#pragma mark - 判断需不需要显示欢迎页
-(BOOL)isFirstLauch{
    // 获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    // 获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:@"appVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 创建滚动视图
-(void)createScrollView{
    self.launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.launchScrollView.showsHorizontalScrollIndicator = NO;
    self.launchScrollView.bounces = NO;
    self.launchScrollView.pagingEnabled = YES;
    self.launchScrollView.delegate = self;
    self.launchScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.imageNamesArray.count, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:self.launchScrollView];
    for (int i = 0; i < self.imageNamesArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        imageView.image = [UIImage imageNamed:self.imageNamesArray[i]];
        [self.launchScrollView addSubview:imageView];
        /// 最后一个引导Image添加按钮
        if (i == self.imageNamesArray.count - 1) {
            //判断要不要添加button
            if (_enterBtnImage != nil) {
                self.enterButton  = [UIButton buttonWithType:UIButtonTypeCustom];
#warning       根据需要自己定义
                self.enterButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200)/2.0f, [UIScreen mainScreen].bounds.size.height - 180, 200, 50);
                
                if ([_enterBtnImage isEqualToString:@""]) {
                    [self.enterButton setBackgroundColor:[UIColor clearColor]];
                }else{
                    [self.enterButton setImage:[UIImage imageNamed:self.enterBtnImage] forState:UIControlStateNormal];
                }
                [self.enterButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:self.enterButton];
                imageView.userInteractionEnabled = YES;
            }
        }
    }
}
#pragma mark - 隐藏引导页
-(void)hideGuidView{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
        
    }];
}
#pragma mark - scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width/2)/[UIScreen mainScreen].bounds.size.width;
    if (cuttentIndex == self.imageNamesArray.count - 1) {
        if ([self isScrollToLeft:scrollView]) {
            if (self.isScrollOut) {
                [self hideGuidView];
            }
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width/2)/[UIScreen mainScreen].bounds.size.width;
        self.pageControl.currentPage = cuttentIndex;
    }
}
/**
 *  返回YES为向左反动，NO为右滚动
 */
-(BOOL)isScrollToLeft:(UIScrollView *) scrollView{
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}
- (void)dealloc{
    self.launchScrollView.delegate = nil;
}


@end
