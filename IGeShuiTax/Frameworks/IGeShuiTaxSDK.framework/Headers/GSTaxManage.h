//
//  GSTaxManage.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/8.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//  Version: 0.0.1

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GSErrorCode.h"

/**
    个税登录返回结果,成功失败都会调用
 
    @param orderNumber 查询成功返回的订单号，用于调用用户个税详情，失败为nil
    @param error 查询结果状态 9999为失败 0000为成功
 */
typedef void(^GSResultBlock)(NSString *orderNumber, GSErrorCode error);


@interface GSTaxManage : NSObject


/**
 *  默认定位城市名 可选 存在时优先于定位信息
 */
@property (nonatomic, strong) NSString *locationCityName;

/**
 *  默认定位城市ID 可选
 */
@property (nonatomic, strong) NSString *locationCityId;


/**
 个税授权/查询结果错误码
 */
@property (nonatomic) GSErrorCode code;


/**
 个税授权/查询接口

 @param apiKey 授权key
 @param boundle 商户APP Bundle identifier
 @param uid 用户唯一id, 需商户自行设定
 @param result 结果返回
 @param viewController 作用于视图控制器
 */
- (void)requestGSWithApiKey:(NSString *)apiKey boundleName:(NSString *)boundle uid:(NSString *)uid completionBlock:(GSResultBlock)result originViewController:(UIViewController *)viewController;

//- (void)startGSAutioWithOriginViewController:(UIViewController *)viewController;


@end
