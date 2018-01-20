//
//  GS_ProgressHUD.m
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_ProgressHUD.h"
#import "GS_MBProgressHUD.h"

static GS_MBProgressHUD *_HUD;

@implementation GS_ProgressHUD

// 加载框
+(void)showHUDView:(BOOL)show {
    
    if (show) {
        [_HUD removeFromSuperview];
        
        _HUD = [GS_MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        _HUD.labelText = @"请稍后...";
        _HUD.animationType = GS_MBProgressHUDAnimationZoomOut;
//        _HUD.backgroundColor = [UIColor lightGrayColor];
        _HUD.minShowTime = 1;
        _HUD.alpha = 0.8;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:_HUD];
        
    } else {
        
        [_HUD removeFromSuperview];
    }
}

// 提示框
+(void)showHUDView:(UIView *)theView states:(BOOL)successOrFailed title:(NSString *)theTitle content:(NSString *)theContent time:(float)thTime andCodes:(void (^)(void))finish {
    
    GS_MBProgressHUD *HUD    = [GS_MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:NO];
    HUD.labelText            = theTitle;
    HUD.detailsLabelText     = theContent;
    HUD.mode                 = GS_MBProgressHUDModeCustomView; // GS_MBProgressHUDModeText;
    HUD.color                = [UIColor darkGrayColor];
    [HUD hide:YES afterDelay:2];
    
    HUD.customView       = [[UIImageView alloc] initWithImage: successOrFailed ? GSImage_Named(@"hud_success") : GSImage_Named(@"hud_warning")];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(thTime); // 暂停和afterDelay:2并无关系
    } completionBlock:^{
        if (finish) {
            finish();
        }
    }];
}

// 延迟操作
+ (void)unShowHUDViewSleepTime:(float)thTime andCodes:(void (^)(void))finish {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        sleep(thTime);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            finish();
        });
    });
}


@end
