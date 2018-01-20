//
//  GS_UIWebViewPublicVC.m
//  GeShuiGuanJia
//
//  Created by xinwang on 2017/11/17.
//  Copyright © 2017年 杭州薪王. All rights reserved.
//

#import "GS_UIWebViewPublicVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface GS_UIWebViewPublicVC () <UIWebViewDelegate>
{
    UIWebView *_webView;
    NSString *_currentUrlStr;
}
@end

@implementation GS_UIWebViewPublicVC

//返回事件
-(void)navigationPopBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationTitle:@" "];
    self.view.backgroundColor = GS_Background_Color;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:GSImage_Named(@"nvc_back") style:UIBarButtonItemStylePlain target:self action:@selector(navigationPopBack)];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIWebView *webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height-GSSafeAreaTopHeight)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = GS_Background_Color;
    [self.view addSubview:webView];
    _webView = webView;
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:_links]];
    [webView loadRequest:request];
}

//代理
-(void)webViewDidStartLoad:(UIWebView *)webView {
    [GS_ProgressHUD showHUDView:YES];
    _currentUrlStr = webView.request.URL.absoluteString;
    
    // 到达成功页面 返回
    if ([_currentUrlStr containsString:[GS_DataTools filterStrNull: _successLinks]]) {
        
        [webView stopLoading];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [GS_ProgressHUD showHUDView:NO];
    
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setupNavigationTitle:title];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [GS_ProgressHUD showHUDView:NO];
}



@end
