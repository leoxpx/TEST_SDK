//
//  GS_TaxPayInfosModel.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GS_TaxPayInfosModel : NSObject

@property (nonatomic, strong) NSString *paymentTime;
@property (nonatomic, strong) NSString *amountPaid;
@property (nonatomic, strong) NSString *incomeType;
@property (nonatomic, strong) NSString *payPerson;

@end
