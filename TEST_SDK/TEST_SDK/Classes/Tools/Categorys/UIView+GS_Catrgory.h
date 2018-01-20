//
//  UIView+Catrgory.h
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/7/15.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GSCatrgory)

- (void)setupCornerRadius:(float)radius; /* *< 设置圆角 */
- (void)setupBorderRadius:(float)border color:(UIColor *)color; /* *< 设置描边 */
- (void)setupShadowRadius:(float)radius; /* *< 设置阴影 */
- (void)setupShadowRadius:(float)radius andCornerRadius:(float)cornerRadius; /* *< 设置圆角+阴影 */
+ (void)setupCellLineTo:(UIView *)view frame:(CGRect)frame; /* *< 分割线 */

+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

// 背景色
@property (nonatomic, copy, readonly) void (^ backGroundColorRGB)(CGFloat red, CGFloat green, CGFloat blue);


@end
