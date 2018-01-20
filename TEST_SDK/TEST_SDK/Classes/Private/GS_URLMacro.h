//
//  URLMacro.h
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/8/29.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#ifndef GS_URLMacro_h
#define GS_URLMacro_h

// 正服
//#define URL_Main @"https://www.igeshui.com/platform/api/"

// 测服
#define URL_Main @"http://test.igeshui.com/platform/api/"


// SDK
#define URL_CheckDockingInfo [NSString stringWithFormat:@"%@appInvoking/checkDockingInfo",URL_Main]


//个税
#define URL_TaxSiteInfo [NSString stringWithFormat:@"%@taxSite/info",URL_Main] // 表单
#define URL_TaxSiteImgCode [NSString stringWithFormat:@"%@taxSite/imgCode",URL_Main] // 图片验证码
#define URL_TaxSiteSubmit [NSString stringWithFormat:@"%@taxSite/submit",URL_Main] // 个登录
#define URL_TaxAllDetail [NSString stringWithFormat:@"%@tax/allDetail",URL_Main] // 个税详情
#define URL_TaxCity [NSString stringWithFormat:@"%@taxSite/city",URL_Main] // 个税城市站点
#define URL_TaxStatus [NSString stringWithFormat:@"%@taxSite/status",URL_Main] //获取状态
#define URL_TaxCheckImg [NSString stringWithFormat:@"%@taxSite/imgCode",URL_Main] //首页刷新弹出验证码
#define URL_TaxAccountList [NSString stringWithFormat:@"%@accountInfo/findTaxAccountList",URL_Main] // 个税账户
#define URL_TaxAccountDelete [NSString stringWithFormat:@"%@accountInfo/deleteUserAccountInfo",URL_Main] // 个税删除
#define URL_TaxLoginGps [NSString stringWithFormat:@"%@h5Invoking/locationByIpAddress",URL_Main] // 个税定位

#endif /* GS_URLMacro_h */
