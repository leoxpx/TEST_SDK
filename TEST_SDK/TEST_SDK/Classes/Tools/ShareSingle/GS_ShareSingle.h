//
//  GS_ShareSingle.h
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/7/12.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GS_ShareSingle : NSObject

@property (nonatomic,strong) NSString *apiKey;
@property (nonatomic,strong) NSString *appPackage;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) UIViewController *superVC;

@property (nonatomic,strong) NSString *openId;
@property (nonatomic,strong) NSString *orderNo;

@property (nonatomic,strong) NSString *pk;

@property (nonatomic,strong) NSString *userToken;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic, strong) NSString *defaultCityName; // 传则 selectCityId 为此
@property (nonatomic, strong) NSString *defaultCityId;
@property (nonatomic, strong) NSString *locationCityName; // 仅用于城市选择界面的定位信息
@property (nonatomic, strong) NSString *locationCityId;
@property (nonatomic, strong) NSString *selectCityName; // 选择的城市 用于默认登录表单
@property (nonatomic, strong) NSString *selectCityId;
@property (nonatomic, strong) NSString *accountIdTax;
@property (nonatomic, strong) NSString *businessType; // 商业类型 autio list
@property (nonatomic,strong) NSString *taxAccountId;
@property (nonatomic,strong) NSString *taxAccountCityId;

+ (GS_ShareSingle *)shareSingle;

@end
