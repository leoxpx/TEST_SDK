//
//  GS_TaxLoginVC.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/8.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_ParentViewController.h"

@interface GS_TaxLoginVC : GS_ParentViewController

@property (nonatomic, strong) NSString *cityId; // 当刷新需要重新登录时传值
@property (nonatomic, strong) NSString *cityName;

@end
