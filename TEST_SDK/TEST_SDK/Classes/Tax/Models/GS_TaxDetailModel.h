//
//  GS_TaxDetailModel.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GS_TaxPayInfosModel.h"

@interface GS_TaxDetailModel : NSObject

@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *totalTax;
@property (nonatomic, strong) NSArray *taxPayInfos;

@end
