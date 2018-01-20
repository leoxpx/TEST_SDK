//
//  GS_ParentViewController.h
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/7/12.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_ParentViewController : UIViewController

// 设置导航栏属性
- (void)setupNavigationTitle:(NSString *)title;
//改变导航栏控制器的title颜色
- (void)setupNavgationTitleColor:(UIColor *)color;
// 返回按钮
- (void)addNvcBackItem;
// nvc返回
- (void)navigationPopBack;

// 隐藏键盘通用方法
- (void)dismissKeyboard;



@end
