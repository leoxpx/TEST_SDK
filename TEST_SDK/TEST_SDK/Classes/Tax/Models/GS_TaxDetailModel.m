//
//  GS_TaxDetailModel.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxDetailModel.h"

@implementation GS_TaxDetailModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"taxPayInfos" : [GS_TaxPayInfosModel class] };
}

@end
