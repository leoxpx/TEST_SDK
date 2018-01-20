//
//  GS_TaxResultView.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/11.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_TaxResultView : UIView

@property (nonatomic, copy) void(^buttonClickBlock)(void);

// 图片 + 提示语 + 按钮
- (instancetype)initWithImageName:(NSString *)imageStr tipsStr:(NSString *)tipStr btnTitle:(NSString *)btnTitle;


@end
