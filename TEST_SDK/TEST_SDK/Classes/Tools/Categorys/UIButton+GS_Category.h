//
//  UIButton+Extension.h
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnBlock)(void);

@interface UIButton (GS_Category)

- (instancetype)initWithImage:(NSString *)imageStr text:(NSString *)text; /**< 图片 主色字 */

- (instancetype)initWithMainTextColorText:(NSString *)text; /**< 白色底 主色字 */

- (instancetype)initWithMainBackgroundColorText:(NSString *)text; /**< 主色底 白色字 */

- (instancetype)initWithBackgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font text:(NSString *)text; /**< UIButton分类 */

- (void)setupLayerLine; /**< 描边 */

- (void)addActionWithBlock:(btnBlock)block; /**< block按钮事件 */

@end
