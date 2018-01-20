//
//  UIButton+Extension.m
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "UIButton+GS_Category.h"
#import <objc/runtime.h>

static const char btnKey;

@implementation UIButton (GS_Category)


- (instancetype)initWithImage:(NSString *)imageStr text:(NSString *)text {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setTitle: text?text:@"" forState:UIControlStateNormal];
        [self setImage:GSImage_Named(imageStr) forState:UIControlStateNormal];
        NSString *imgsel = [NSString stringWithFormat:@"%@_selected", imageStr];
        [self setImage:GSImage_Named(imgsel) forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}


- (instancetype)initWithMainTextColorText:(NSString *)text {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:GS_Main_Color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithMainBackgroundColorText:(NSString *)text {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = GS_Main_Color;
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithBackgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font text:(NSString *)text {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = bgColor ? bgColor : [UIColor clearColor];
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitleColor:textColor ? textColor : [UIColor darkTextColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    
    return self;
}
- (void)setupLayerLine {
    
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 0.3;
}


- (void)addActionWithBlock:(btnBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &btnKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [self addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    btnBlock block = objc_getAssociatedObject(self, &btnKey);
    block();
}


@end
