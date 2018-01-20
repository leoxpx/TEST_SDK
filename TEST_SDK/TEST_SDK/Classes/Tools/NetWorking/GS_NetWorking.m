//
//  NetWorking.m
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_NetWorking.h"
//加密
#import "GS_RSAEncryptor.h"
#import "GS_GTMBase64.h"

#define ErrorTips @"亲，网络崩溃了哟，请稍后重试！"

static GS_AFHTTPSessionManager *_manager = nil;

@implementation GS_NetWorking

// manager配置
+ (GS_AFHTTPSessionManager *)shareAFNManager {
    
    if (_manager == nil) {
        
        GS_AFHTTPSessionManager *manager = [GS_AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 20;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", @"text/javascript", @"image/jpeg", nil];
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;//缓存策略
        manager.securityPolicy.allowInvalidCertificates = YES;//安全策略
        manager.securityPolicy.validatesDomainName      = NO;
        _manager = manager;
        
    }
    
    _manager.requestSerializer  = [AFJSONRequestSerializer serializer];//请求和返回的为JSON
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // Header
    [_manager.requestSerializer setValue: [GS_ShareSingle shareSingle].openId ?: @""  forHTTPHeaderField:@"Gssq-Authorization-openID"];
    
//    NSLog(@"ID: %@ Token: %@", [GS_ShareSingle shareSingle].uuid, [GS_ShareSingle shareSingle].userToken);
    
    [self newRequestId];
    
    
    return _manager;
}
// 刷新requestID
+ (void)newRequestId {
    
//    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
//    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
//    int requestIdTemp = (arc4random() % 50000)+10000;
//    [GS_ShareSingle shareSingle].requestId = [NSString stringWithFormat:@"%llu%d",theTime,requestIdTemp];
}


// POST
+ (void)POSTWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters successBlock:(AFNSuccessBlock)success failure:(AFNFailureBlock)failure {
    
    // manager配置
    GS_AFHTTPSessionManager *manager = [GS_NetWorking shareAFNManager];
    
    // 发起请求
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 成功回调
        success(task, responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 失败回调
        failure(nil, nil, error);
        
    }];
}

// GET
+ (void)GETWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters successBlock:(AFNSuccessBlock)success failure:(AFNFailureBlock)failure{
    
    GS_AFHTTPSessionManager *manager = [GS_NetWorking shareAFNManager];
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task, responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(nil, nil, error);
        
    }];
}
// GET 二进制
+ (void)GETHttpWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters successBlock:(AFNSuccessBlock)success failure:(AFNFailureBlock)failure {
    
    GS_AFHTTPSessionManager *manager = [GS_NetWorking shareAFNManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求为JSON
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//返回为二进制
    
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task, responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(nil, nil, error);
        
    }];
}


// 加密相关
+ (NSString *)RSAAndBASE64Encryptor:(NSDictionary *)beforeDicForEncryptor{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:beforeDicForEncryptor options:NSJSONWritingPrettyPrinted error:nil];
    NSData *baseData = [GS_GTMBase64 encodeData:data];
    NSString *baseStr = [[NSString alloc] initWithData:baseData encoding:NSUTF8StringEncoding];
    
    //RSA 使用字符串格式的公钥私钥加密解密
    NSString *RSAStr = [GS_RSAEncryptor encryptString:baseStr publicKey:[GS_ShareSingle shareSingle].pk]; // MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDKMzbZZq4QyMPLSye2QkBqfcE3QbFzWO5r1+MrL5PVTOFMpC/SfYYXxa9F0mo3Yc/PszHd7EYsWCeVHjU0kHWBmmiWLqK92ZbwLImnV434ZcXolEMZFLl2+2X1gikjibHUP/UYS+CG8Gc7lfyYuv8N5aYHCzkKja+GQjZrlB5ZwQIDAQAB
    // base64 2 RSA内部已有base64
    
    return RSAStr;
}




@end
