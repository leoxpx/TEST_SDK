//
//  UILabel+Extension.m
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "UILabel+GS_Category.h"

@implementation UILabel (GS_Catrgory)

- (instancetype)initWithTextColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSTextAlignment)alignment text:(NSString *)text{
    
    self = [super init];
    if (self) {
        
        self.textColor = color ? color : [UIColor darkTextColor];
        self.font = [UIFont systemFontOfSize:font];
        self.text = text;
        self.textAlignment = alignment;
    }
    
    return self;
}

- (void)setupTextAttributesTextFont:(CGFloat)font textColor:(UIColor *)color atRange:(NSRange)range {
    
    [self setTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font] , NSForegroundColorAttributeName:color} atRange:range];
}

- (void)setTextAttributes:(NSDictionary *)attributes atRange:(NSRange)range {
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    for (NSString *name in attributes) {
        [mutableAttributedString addAttribute:name value:[attributes objectForKey:name] range:range];
    }
    
    self.attributedText = mutableAttributedString;
}

@end
