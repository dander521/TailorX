//
//  TXShowWebViewController.m
//  TailorX
//
//  Created by RogerChen on 2017/4/13.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXShowWebViewController.h"
#import "TXWebView.h"

@interface TXShowWebViewController ()

@end

@implementation TXShowWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.naviTitle;
    
    TXWebView *webView = [[TXWebView alloc] initWithFrame:self.view.bounds];
    webView.requestUrl = self.webViewUrl;
    [self.view addSubview:webView];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_nav_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backItem.tintColor = RGB(138, 138, 138);
    self.navigationItem.leftBarButtonItems = @[backItem];
}

#pragma mark - events

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
