//
//  GS_ParentViewController.m
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/7/12.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_ParentViewController.h"

@interface GS_ParentViewController () <UIGestureRecognizerDelegate>

@end

@implementation GS_ParentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景色
    self.view.backgroundColor = GS_Background_Color;
    
//    //自定义nvc侧滑需要设置
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self; //替换了delegate之后，必须在gestureRecognizerShouldBegin:中设置某ViewController A开启右滑返回，同时在A中未设置interactivePopGestureRecognizer.enabled = NO，右滑返回才会开启，即二者中任一为NO，右滑返回都处于关闭状态。
}


#pragma mark- ------------------------------------------- 导航栏
// 设置导航栏属性
- (void)setupNavigationTitle:(NSString *)title {
    
    self.navigationItem.title = title; // 标题
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor darkTextColor], [UIFont systemFontOfSize:17], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, nil]];
    self.navigationController.navigationBar.titleTextAttributes = dic; // 颜色
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO; // 不透明 0,64
    self.navigationController.navigationController.navigationBar.barStyle = UIBarStyleDefault; // 镂空样式
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor]; // bar背景色
    self.navigationController.navigationBar.tintColor = GS_Main_Color; // 图片/字体镂空颜色

    // 针对于rt_nvc
//    if (self.navigationController.childViewControllers.count > 1) {
        // 针对于原生nvc
        [self addNvcBackItem];
//    }
}
//改变导航栏控制器的title颜色
- (void)setupNavgationTitleColor:(UIColor *)color {
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:color}];
}

// 返回
- (void)addNvcBackItem {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[GSImage_Named(@"gs_nvcback") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(navigationPopBack)];
    
    self.navigationItem.leftBarButtonItem = item;
}
- (void)navigationPopBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark- ------------------------------------------- 手势
//第一页侧滑防止页面假死
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else{
        return YES;
    }
}


#pragma mark- ------------------------------------------- 键盘
// 文本框Return隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    [textField resignFirstResponder];
    return UIReturnKeyDone;
}
// 隐藏键盘通用方法
- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent: UIEventTypeTouches];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
