//
//  GS_Hong.h
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#ifndef GS_Hong_h
#define GS_Hong_h


// 通知
#define TaxResultNotification @"GS_TaxResultNotification"

// tag
#define TagLeftViewShare 1000 // 1000-1003
#define TagModifyPhoneBtn2 1010

// 定义
#define GS_Bundle_IMG(imageName) [@"IGeShuiTaxSDK.bundle" stringByAppendingPathComponent:imageName]
#define GS_Bundle [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"IGeShuiTaxSDK" ofType: @"bundle"]]


//** 系统匹配 ***********************************************************************************
// 适配
#define GSDevice_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define GSSafeAreaTopHeight (GSDevice_iPhoneX ? 88 : 64)
#define GSSafeAreaBottomHeight (GSDevice_iPhoneX ? 34 : 0)
// 屏幕宽高
#define GSScreen_Height      [[UIScreen mainScreen] bounds].size.height
#define GSScreen_Width       [[UIScreen mainScreen] bounds].size.width
// 图片名
#define GSImage_Named(imgName) [[UIImage imageNamed: GS_Bundle_IMG(imgName)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] // sdk用
//#define GSImage_Named(imgName) [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] // 项目用


//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//** 弱指针 ********************************************************************************
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
// 所有事物弱引用
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
//** DEBUG LOG ********************************************************************************
#ifdef DEBUG

#define NSLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif


//** UIView - viewWithTag ********************************************************************
#define View_With_Tag(_OBJECT, _TAG)\
\
[_OBJECT viewWithTag : _TAG]

//** 断点Assert *************************************************************************
#define xAssert(condition, ...)\
\
do {\
if (!(condition))\
{\
[[NSAssertionHandler currentHandler]\
handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
lineNumber:__LINE__\
description:__VA_ARGS__];\
}\
} while(0)

//** 方法备注 *************************************************************************
#define DEPRECATED(_version) __attribute__((deprecated("feiqile")))






#endif /* GS_Hong_h */
