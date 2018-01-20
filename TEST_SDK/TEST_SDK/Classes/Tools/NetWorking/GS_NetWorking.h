//
//  NetWorking.h
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GS_AFNetworking.h"

// 完成回调
typedef void(^AFNSuccessBlock)(NSURLSessionDataTask * task, id responseObject, NSError *error);
typedef void(^AFNFailureBlock)(NSURLSessionDataTask * task, id responseObject, NSError *error);
typedef void(^AFNUploadFileBlock)(id formData);

@interface GS_NetWorking : NSObject

// 网络封装方法 POST
+ (void)POSTWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters successBlock:(AFNSuccessBlock)success failure:(AFNFailureBlock)failure;

// GET
+ (void)GETWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters successBlock:(AFNSuccessBlock)success failure:(AFNFailureBlock)failure;

// GET 二进制
+ (void)GETHttpWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters successBlock:(AFNSuccessBlock)success failure:(AFNFailureBlock)failure;

// 加密
+(NSString *)RSAAndBASE64Encryptor:(NSDictionary *)beforeDicForEncryptor;


@end
