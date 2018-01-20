//
//  GS_TaxLoginAnimationView.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/13.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_TaxLoginAnimationView : UIView

@property (nonatomic, strong) UILabel *tipLabel;

+ (instancetype)GS_ShareSingle;
- (void)startAnimation;
- (void)stopAnimation;

@end
