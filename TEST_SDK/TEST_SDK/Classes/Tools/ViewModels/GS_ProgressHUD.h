//
//  GS_ProgressHUD.h
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_ProgressHUD : UIView

+ (void)showHUDView:(BOOL)show; /**< 加载框 */
+ (void)showHUDView:(UIView *)theView states:(BOOL)successOrFailed title:(NSString *)theTitle content:(NSString *)theContent time:(float)thTime andCodes:(void (^)(void))finish; /**< 提示框 */

+ (void)unShowHUDViewSleepTime:(float)thTime andCodes:(void (^)(void))finish; /**< 纯粹的延迟 */

@end
