//
//  TXHomeBannerWebController.m
//  TailorX
//
//  Created by Qian Shen on 1/4/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXHomeBannerWebController.h"
#import "TXAllDesignerViewController.h"
#import "TXWebView.h"
#import "AppDelegate.h"
#import "UINavigationBar+Awesome.h"
#import "TXCustomNavView.h"
#import "TXShareActionSheet.h"

@interface TXHomeBannerWebController ()<UIScrollViewDelegate>

/** TXWebView*/
@property (nonatomic, strong) TXWebView *webView;
/** 自定义导航条*/
@property (nonatomic, strong) TXCustomNavView *navView;
/** title */
@property (nonatomic, strong) NSString *webNavTitle;

@end

@implementation TXHomeBannerWebController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[TXWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.webView.scrollView.delegate = self;
    self.webView.requestUrl = self.requestUrl;
    
    weakSelf(self);
    self.webView.didFinish = ^ (WKNavigation *navigation,NSString *webTitle){
        weakSelf.webNavTitle = webTitle;
    };
    [self.view addSubview:self.webView];
    [self.view addSubview:self.navView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(htmlAppointmentDesigner) name:kNotificationHtmlAppointmentDesigner object:nil];
    self.webView.webView.scrollView.contentInset = UIEdgeInsetsMake(kTopHeight, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 程荣刚：兼容9.3.3代理crash问题
    self.webView.webView.scrollView.delegate = nil;
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Touch Method

- (void)htmlAppointmentDesigner {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:false];
    [((TXNavigationViewController *)([AppDelegate sharedAppDelegate].tabBarVc.selectedViewController)) pushViewController:[TXAllDesignerViewController new] animated:false];
}

- (void)respondsToBackBtn:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Share

/** 
 * 分享
 */
- (void)respondsToShareBtn:(UIButton*)sender {
    [self shareAction];
}

- (void)shareAction {
    TXShareActionSheet *actionSheet = [TXShareActionSheet instanceView];
    [actionSheet showWithweChat:^{
        [self shareContentWithPlatform:UMSocialPlatformType_WechatSession];
    } FriendCircle:^{
        [self shareContentWithPlatform:UMSocialPlatformType_WechatTimeLine];
    } Qq:^{
        [self shareContentWithPlatform:UMSocialPlatformType_QQ];
    }];
}

-(void)shareContentWithPlatform:(UMSocialPlatformType) platform {
     NSString *url = [self.requestUrl stringByReplacingOccurrencesOfString:@".html" withString:@"-share.html"];
    
    NSString *title = self.webNavTitle;
    NSString *content = nil;
    if ([self.requestUrl.lastPathComponent isEqualToString:@"arts.html"]) {
        content = @"每一刀每一针每一线都是我们所追求的细节，所有的细节处理都为让您的体验更加舒适！";
    } else if ([self.requestUrl.lastPathComponent isEqualToString:@"step.html"]) {
        content = @"线上线下相结合的互联网成衣定制模式，让您体验极速的快感！";
    } else {
        content = @"全手工流水线高端定制工艺，结合全进口面料，为您的服装保驾护航！";
    }
    UIImage *image = [UIImage imageNamed:@"shareLogo"];
    NSData *data = UIImagePNGRepresentation(image);
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:data];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"分享失败"];
        } else {
            [MBProgressHUD showMessage:@"分享成功"];
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    NSLog(@"offset = %.2f", offset);
    CGFloat alpha = (offset + 64) / 64;
    NSLog(@"alpha = %.2f", alpha);
    if (alpha >= 0) {
        self.navView.titleLabel.text = self.webNavTitle;
    } else {
        self.navView.titleLabel.text = @"";
    }
    self.navView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
    self.navView.titleLabel.textColor = [RGB(46, 46, 46) colorWithAlphaComponent:alpha];
}

#pragma mark - Lazy 

- (TXCustomNavView *)navView {
    if (!_navView) {
        _navView = [TXCustomNavView getCustomNavView];
        _navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight);
        _navView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _navView.activityView.hidden = YES;
        if (self.isHideShare) {
            _navView.shareButton.hidden = true;
        } else {
            _navView.shareButton.hidden = false;
        }
        [_navView.backBtn setImage:[UIImage imageNamed:@"ic_nav_arrow"] forState:UIControlStateNormal];
        _navView.titleLabel.text = @"";
        _navView.backgroundColor = [UIColor clearColor];
        _navView.bottomView.hidden = true;
        [_navView.backBtn addTarget:self action:@selector(respondsToBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_navView.shareButton addTarget:self action:@selector(respondsToShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        _navView.titleLabel.textColor = [RGB(46, 46, 46) colorWithAlphaComponent:1];
    }
    return _navView;
}

@end
