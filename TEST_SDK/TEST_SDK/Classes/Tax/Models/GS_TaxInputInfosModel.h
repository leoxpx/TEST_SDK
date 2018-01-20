//
//  GSTaxLoginInputInfosModel.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/11.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GS_TaxInputInfosModel : NSObject

@property (nonatomic, strong) NSString *inputId;
@property (nonatomic, strong) NSString *inputName;
@property (nonatomic, strong) NSString *inputLabel;
@property (nonatomic, strong) NSString *inputTip;
@property (nonatomic, strong) NSString *inputType;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) NSArray *options;

@end
