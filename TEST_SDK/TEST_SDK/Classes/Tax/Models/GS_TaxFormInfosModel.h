//
//  GS_TaxFormInfosModel.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/11.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GS_TaxInputInfosModel.h"

@interface GS_TaxFormInfosModel : NSObject

@property (nonatomic, strong) NSString *formId;
@property (nonatomic, strong) NSString *formName;
@property (nonatomic, strong) NSString *yzmTip;
@property (nonatomic, strong) NSArray *inputInfos;

@property (nonatomic,strong) NSString *btnText; // 按钮文字
@property (nonatomic,strong) NSString *isFormPanel; // 判断是弹出窗还是进去下一页
@property (nonatomic,strong) NSString *formTipBottom; // 底部 按钮上面的文字、可能有

@end

