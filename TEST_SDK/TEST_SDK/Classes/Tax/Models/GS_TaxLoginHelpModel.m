//
//  GS_TaxLoginHelpModel.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/20.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginHelpModel.h"

@implementation GS_TaxLoginHelpModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"siteLoginHelpBtns" : [GSTaxLoginHelpButtonModel class] };
}

@end

@implementation GSTaxLoginHelpButtonModel

@end
