//
//  GS_TaxRefreshVM.h
//  BaseSDK
//
//  Created by xinwang on 2018/1/9.
//  Copyright © 2018年 杭州薪王信息技术有限公司. All rights reserved.
//  个税刷新 数据服务类

#import <Foundation/Foundation.h>

@interface GS_TaxRefreshVM : NSObject

@property (nonatomic, copy) void(^successBlock)(NSDictionary *dict);

@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *accountCityId; // 只供刷新失败重新登录时传到登录页面有用
@property (nonatomic, strong) NSString *accountCityName;

- (void)startRefreshTaxDataSuccessBlock:(void(^)(NSDictionary *dict))successBlock; // 刷新

@end
