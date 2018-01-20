//
//  GS_TaxLoginOverdueVC.h
//  BaseSDK
//
//  Created by xinwang on 2018/1/8.
//  Copyright © 2018年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_ParentViewController.h"
#import "GS_TaxFormInfosModel.h" // model

@interface GS_TaxLoginOverdueVC : GS_ParentViewController

@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) GS_TaxFormInfosModel *formInfosModel;
@property (nonatomic,strong) NSString *accountId;
@property (nonatomic,strong) NSString *requestId; // 请求生成的ID

@end
