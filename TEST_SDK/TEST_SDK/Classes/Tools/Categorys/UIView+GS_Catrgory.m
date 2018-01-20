//
//  UIView+Catrgory.m
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/7/15.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "UIView+GS_Catrgory.h"

@implementation UIView (GSCatrgory)

// 圆角
- (void)setupCornerRadius:(float)radius {
    
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

// 描边
- (void)setupBorderRadius:(float)border color:(UIColor *)color {
    
    self.layer.borderWidth = border;
    self.layer.borderColor = color.CGColor;
}

// 阴影
- (void)setupShadowRadius:(float)radius {
    
    UIView *shadowView = [[UIView alloc]initWithFrame:self.frame];
    [self addSubview:shadowView];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色
    shadowView.layer.shadowOffset = CGSizeMake(5, 5); //设置阴影的偏移量
    shadowView.layer.shadowOpacity = 1; //设置阴影的透明度
    shadowView.layer.shadowRadius = radius; //设置阴影的圆角
    shadowView.clipsToBounds = NO;
    [shadowView addSubview:self];
}

// 分割线
+ (void)setupCellLineTo:(UIView *)view frame:(CGRect)frame {
    
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = GS_Cell_Color;
    [view addSubview:line];
    
}



// 阴影+圆角 设置了masksToBounds属性为YES了，将后面设置的阴影效果给裁剪掉了，所以我们看不到阴影效果，如果我们将masksToBounds属性为NO了，这样就会失去圆角效果（尽管会出现阴影效果）.给imageView添加一个父视图，在父视图上添加阴影效果就好，这样就不会对imageView的圆角造成影响了。clipsToBounds:视图上的子视图,如果超出父视图的部分就截取掉, masksToBounds:视图的图层上的子图层,如果超出父图层的部分就截取掉
- (void)setupShadowRadius:(float)radius andCornerRadius:(float)cornerRadius {
    
    UIView *shadowView = [[UIView alloc]initWithFrame:self.frame];
    [self addSubview:shadowView];
    shadowView.layer.cornerRadius = cornerRadius; //设置圆角
    shadowView.clipsToBounds = NO;
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色
    shadowView.layer.shadowOffset = CGSizeMake(5, 5); //设置阴影的偏移量
    shadowView.layer.shadowOpacity = 1; //设置阴影的透明度
    shadowView.layer.shadowRadius = radius; //设置阴影的圆角
    [shadowView addSubview:self];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


// 背景色
- (void (^)(CGFloat, CGFloat, CGFloat))backGroundColorRGB {
    
    void (^ block)(CGFloat red, CGFloat green, CGFloat blue) = ^ (CGFloat red, CGFloat green, CGFloat blue) {
        
        self.backgroundColor = GS_RGB(red, green, blue);
    };
    return block;
}

@end
