//
//  GS_ViewTools.m
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_ViewTools.h"

@implementation GS_ViewTools

// 旋转
+(void)startRotate:(BOOL)isStart theView:(UIView *)view {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    
    if (isStart) {
        [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }else{
        [view.layer removeAnimationForKey:@"rotationAnimation"];
    }
}


@end
