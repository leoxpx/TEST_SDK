//
//  GS_TaxResultView.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/11.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxResultView.h"

@implementation GS_TaxResultView

- (instancetype)initWithImageName:(NSString *)imageStr tipsStr:(NSString *)tipStr btnTitle:(NSString *)btnTitle {
    
    self = [super initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height)];
    if (self) {
        [self setupSelfView:imageStr tip:tipStr btn:btnTitle];
    }
    return self;
}

- (void)setupSelfView:(NSString *)image tip:(NSString *)tip btn:(NSString *)btn {
    
    self.backgroundColor = GS_Background_Color;
    
    UIImageView *imageForNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    imageForNoData.center = CGPointMake(self.frame.size.width/2, 90);
    imageForNoData.image = [GSImage_Named(image) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (image && [image isEqualToString:@"gs_resultright"]) {
        imageForNoData.tintColor = GS_Main_Color;
    } else {
        imageForNoData.tintColor = GS_RGB(207, 207, 207);
    }
    [self addSubview:imageForNoData];
    
    
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 20)];
    tipLable.center = CGPointMake(self.frame.size.width/2, 175);
    tipLable.textColor = [UIColor lightGrayColor];
    tipLable.text = tip;
    tipLable.textAlignment = NSTextAlignmentCenter;
    tipLable.numberOfLines = 2;
    tipLable.font = [UIFont systemFontOfSize:16];
    [self addSubview:tipLable];
    
    
    UIButton *claimBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width-30, 45)];
    claimBtn.center = CGPointMake(self.frame.size.width/2, 240);
    claimBtn.backgroundColor = GS_Main_Color;
    [claimBtn setTitle:btn forState:UIControlStateNormal];
    [claimBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    claimBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    claimBtn.layer.cornerRadius = 2;
    claimBtn.layer.masksToBounds = YES;
    [self addSubview:claimBtn];
    [claimBtn addActionWithBlock:^{
        
        if (_buttonClickBlock) {
            _buttonClickBlock();
        }
    }];
}

@end
