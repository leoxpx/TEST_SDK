//
//  XWMobileAlertView.h
//  GeShuiGuanJia
//
//  Created by xinwang2 on 2018/1/5.
//  Copyright © 2018年 杭州薪王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_MobileAlertView : UIView

@property(nonatomic,strong)NSString *requestId;

/**
 初始化统一采用此用法

 @param feildDict 输入框的数组
 feildDict : formInfo字典
 @return UIview
 */
-(instancetype)initWithTextFeildDict:(NSDictionary *)feildDict requestId:(NSString *)requestId;

/**
 遮罩视图
 */
@property(nonatomic,strong)UIView *backView;


/**
 提示语句
 */
@property(nonatomic,strong)UILabel *alertLabel;

/**
 提示详情语句
 */
@property(nonatomic,strong)UILabel *alertSubLabel;


/**
 输入框数组
 */
@property(nonatomic,strong,readonly)NSArray<UITextField *> *fieldS;


/**
 输入文本数组
 */
@property(nonatomic,strong,readonly)NSArray<NSString *>* fielsStrs;


/**
 输入文本字典
 */
@property(nonatomic,strong,readonly)NSDictionary* fielsStrDict;

/**
 确认按钮
 */
@property(nonatomic,strong)UIButton *sureBtn;


/**
 取消按钮
 */
@property(nonatomic,strong)UIButton  *cancalBtu;






@end
