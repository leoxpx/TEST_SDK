//
//  GS_TaxLoginModel.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/11.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginModel.h"

@implementation GS_TaxLoginModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"formInfos" : [GS_TaxFormInfosModel class],
//              @"siteHelp" : [GS_TaxSiteHelpModel class],
              @"urlInfos" : [GS_TaxUrlInfosModel class] };
}

@end

