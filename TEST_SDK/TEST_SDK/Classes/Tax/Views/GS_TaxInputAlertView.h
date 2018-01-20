//
//  GS_TaxInputAlertView.h
//  BaseSDK
//
//  Created by 许墨 on 2018/1/13.
//  Copyright © 2018年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_TaxInputAlertView : UIView

/**
 所有的输入框, 用于没有数据时取提示语
 */
@property(nonatomic, strong, readonly) NSMutableArray *inputTextFieldsArr;

/**
 输入信息的结果字典
 */
@property(nonatomic, strong, readonly) NSMutableDictionary *inputDic;

/**
 确认按钮
 */
@property(nonatomic, strong) UIButton *sureBtn;

/**
 取消按钮
 */
@property(nonatomic, strong) UIButton *cancalBtu;

/**
 视图和数据的初始化方法
 
 @param formInfo 视图创建所需的数据
 @param requestId 请求Id
 @return UIView
 */
- (instancetype)initWithFormInfo:(NSDictionary *)formInfo andRequestId:(NSString *)requestId;

/**
 弹出弹框
 */
- (void)showInputAlertView;

/**
 取消弹框
 */
- (void)dismissInputAlertView;


@end
