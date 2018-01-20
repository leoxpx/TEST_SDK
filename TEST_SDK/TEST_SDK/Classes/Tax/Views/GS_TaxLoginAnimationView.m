//
//  GS_TaxLoginAnimationView.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/13.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginAnimationView.h"

static GS_TaxLoginAnimationView *animation = nil;

@implementation GS_TaxLoginAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)GS_ShareSingle {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (animation == nil) {
            animation = [[GS_TaxLoginAnimationView alloc] init];
        }
    });
    
    return animation;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, GSScreen_Width, GSScreen_Height);
    }
    return self;
}

- (void)startAnimation {
    
    if (_tipLabel != nil) {
        return;
    }
    
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageCycle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    imageCycle.center = CGPointMake(self.center.x, 100);
    imageCycle.image = [GSImage_Named(@"gs_taxlogincycle") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageCycle.tintColor = GS_Main_Color;
    [self addSubview:imageCycle];
    [GS_ViewTools startRotate:YES theView: imageCycle];
    
    UIImageView *imageTax = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    imageTax.center = CGPointMake(self.center.x, 100);
    imageTax.image = [GSImage_Named(@"gs_taxloginlogo") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageTax.tintColor = GS_Main_Color;
    [self addSubview:imageTax];
    
    UILabel *tipLabel = [[UILabel alloc] initWithTextColor:[UIColor darkTextColor] font:16 textAlignment:NSTextAlignmentCenter text:@""];
    tipLabel.frame = CGRectMake(0, 0, GSScreen_Width, 20);
    tipLabel.center = CGPointMake(self.center.x, 185);
    [self addSubview:tipLabel];
    _tipLabel = tipLabel;
}

- (void)stopAnimation {
    
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _tipLabel = nil;
    [self removeFromSuperview];
}


@end
