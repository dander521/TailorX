//
//  TabBarController.m
//  Tailorx
//
//  Created by   徐安超 on 16/7/18.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "TXTabBarController.h"
#import "TXHomeViewController.h"
#import "TXQueueNoViewController.h"
#import "TXUserCenterViewController.h"
#import "TXDiscoveViewController.h"
#import "ScrollTabBarDelegate.h"

@interface TXTabBarController () <UITabBarControllerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) NSInteger subViewControllerCount;
@property (nonatomic, strong) ScrollTabBarDelegate *tabBarDelegate;
@end

@implementation TXTabBarController

- (BOOL)prefersStatusBarHidden {
    return false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = RGB(255, 255, 255);
    self.tabBar.backgroundColor = RGBA(0, 0, 0, 0.3);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotifation object:nil];
    
    // 首页
    TXHomeViewController *vwcHome = [[TXHomeViewController alloc] init];
    vwcHome.title = LocalSTR(@"Title_Home");
    _homeNavCon = [[TXNavigationViewController alloc] initWithRootViewController:vwcHome];
    _homeNavCon.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalSTR(@"Title_Home")
                                                               image:[UIImage imageNamed:@"ic_tab_home"]
                                                       selectedImage:[self setBarItemImage:@"ic_tab_home_black"]];
    
    // 发现
    TXDiscoveViewController *vwcTrend = [[TXDiscoveViewController alloc] init];
    vwcTrend.title = @"Discover";
    _classifyNavCon = [[TXNavigationViewController alloc] initWithRootViewController:vwcTrend];
    _classifyNavCon.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现"
                                                               image:[UIImage imageNamed:@"ic_tab_find"]
                                                       selectedImage:[self setBarItemImage:@"ic_tab_find_black"]];
    
    
    // 排号
    TXQueueNoViewController *vwcQueue = [[TXQueueNoViewController alloc] init];
    vwcQueue.title = LocalSTR(@"Title_QueueNo");
    _queueNoNavCon = [[TXNavigationViewController alloc] initWithRootViewController:vwcQueue];
    _queueNoNavCon.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalSTR(@"Title_QueueNo")
                                                               image:[UIImage imageNamed:@"ic_tab_number"]
                                                       selectedImage:[self setBarItemImage:@"ic_tab_number_black"]];


    
    // 门店
    TXUserCenterViewController *vwcStore = [[TXUserCenterViewController alloc] init];
    vwcStore.title = @"我的";
    _storeNavCon = [[TXNavigationViewController alloc] initWithRootViewController:vwcStore];
    _storeNavCon.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                              image:[UIImage imageNamed:@"ic_tab_user"]
                                                      selectedImage:[self setBarItemImage:@"ic_tab_user_black"]];
    
    [self themeChangeAction];
    self.viewControllers = @[_homeNavCon, _classifyNavCon, _queueNoNavCon, _storeNavCon];
    [self addScrollTabBar];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [self dropShadowWithOffset:CGSizeMake(0, -3) radius:2 opacity:0.04];

    TXDiscoverItem *clickDiscoverView = [TXDiscoverItem sharedTXDiscoverItem];
    clickDiscoverView.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 49);
    clickDiscoverView.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDiscoverItemSingleTap)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [clickDiscoverView addGestureRecognizer:singleTapGestureRecognizer];

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDiscoverItemDoubleTap)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [clickDiscoverView addGestureRecognizer:doubleTapGestureRecognizer];
    //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];

    [self.tabBar addSubview:clickDiscoverView];
}

- (void)clickDiscoverItemSingleTap {
    if ([[TXKVPO getIsDiscover] integerValue] == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDiscoverItemSingleTap object:nil];
    }else {
        //self.selectedIndex = 1;
    }
}

- (void)clickDiscoverItemDoubleTap {
    if ([[TXKVPO getIsDiscover] integerValue] == 0) {
        //self.selectedIndex = 1;
    }else {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationDiscoverItemDoubleTap object:nil];
    }
}

- (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;

    self.tabBar.clipsToBounds = NO;
}

-(void)themeChangeAction {
    
    self.tabBar.tintColor = RGB(53, 47, 34); //[[ThemeManager shareManager] loadThemeColorWithName:@"tabBar_color"];
    
    UIColor *color = RGB(53, 47, 34);// [[ThemeManager shareManager] loadThemeColorWithName:@"navigation_color"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = color;

    _homeNavCon.navigationBar.titleTextAttributes = dic;
    _homeNavCon.tabBarItem.selectedImage = [self setBarItemImage:@"ic_tab_home_black"];

    _classifyNavCon.navigationBar.titleTextAttributes = dic;
    _classifyNavCon.tabBarItem.selectedImage = [self setBarItemImage:@"ic_tab_find_black"];

    _queueNoNavCon.navigationBar.titleTextAttributes = dic;
    _queueNoNavCon.tabBarItem.selectedImage = [self setBarItemImage:@"ic_tab_number_black"];

    _storeNavCon.navigationBar.titleTextAttributes = dic;
    _storeNavCon.tabBarItem.selectedImage = [self setBarItemImage:@"ic_tab_user_black"];
}

- (UIImage *)setBarItemImage:(NSString *)imgName {
    UIImage *img = [UIImage imageNamed:imgName];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 添加滑动逻辑
 */
- (void)addScrollTabBar {
    // 正确的给予 count
    self.subViewControllerCount = self.viewControllers ? self.viewControllers.count : 0;
    // 代理
    self.tabBarDelegate = [[ScrollTabBarDelegate alloc] init];
    self.delegate = self.tabBarDelegate;
    // 增加滑动手势
//    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
//    [self.view addGestureRecognizer:self.panGesture];
}

- (void)panHandle:(UIPanGestureRecognizer *)panGesture {
    // 获取滑动点
    CGFloat translationX = [panGesture translationInView:self.view].x;
    CGFloat progress = fabs(translationX)/self.view.frame.size.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.tabBarDelegate.interactive = YES;
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < self.subViewControllerCount - 1) {
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.tabBarDelegate.interactionController updateInteractiveTransition:progress];
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress > 0.3) {
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController finishInteractiveTransition];
            }else{
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController cancelInteractiveTransition];
            }
            self.tabBarDelegate.interactive = NO;
        }
            break;
        default:
            break;
    }
}


@end
