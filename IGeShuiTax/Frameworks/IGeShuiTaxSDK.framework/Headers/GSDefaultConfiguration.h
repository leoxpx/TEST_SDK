//
//  GSDefaultConfiguration.h
//  GeShuiChaXunSDK
//
//  Created by xinwang on 2017/12/5.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#ifndef GSDefaultConfiguration_h
#define GSDefaultConfiguration_h

// 相关配置项
#define GS_RGB(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define GS_RGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 主色调（按钮颜色）
#define GS_Main_Color GS_RGB(6, 207, 197)
// 页面背景颜色
#define GS_Background_Color GS_RGB(242, 242, 242)
// 分割线颜色
#define GS_Cell_Color GS_RGB(225, 225, 225)

// 如需修改图标,可将图标替换至 IGeShuiTaxSDK.bundle 内, 需与原图片保持命名一致.





#endif /* GSDefaultConfiguration_h */
