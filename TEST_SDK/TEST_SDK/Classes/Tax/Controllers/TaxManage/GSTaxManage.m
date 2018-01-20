//
//  GSTaxManage.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/8.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GSTaxManage.h"
#import "GS_TaxLoginVC.h" // 登录
#import "GS_TaxDetailnfoVC.h" // 个税详情
#import "GS_TaxAccountListModel.h" // model

@interface GSTaxManage ()
{
    UIViewController *_superViewController;
    GSResultBlock _resultBlock;
}
@end

@implementation GSTaxManage


// MARK:- 1.是否安装
- (void)gs_checkTaxSDKIsIntegration {
    
    // 2.key值是否有效
    [self gs_checkTaxSDKKeyIsIntegration];
}

// MARK:- 2. key值是否有效
- (void)gs_checkTaxSDKKeyIsIntegration {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"apiKey"] = [GS_ShareSingle shareSingle].apiKey;
    requestDic[@"appPackage"] = [GS_ShareSingle shareSingle].appPackage;
    requestDic[@"deviceInfo"] = @"iOS";
    requestDic[@"userId"] = [GS_ShareSingle shareSingle].userId;
    
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_CheckDockingInfo Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
       NSDictionary *dic = responseObject;
        [GS_ProgressHUD showHUDView:NO];
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            // 商户对接类型
            [GS_ShareSingle shareSingle].businessType = dic[@"dockingDataType"];
            [GS_ShareSingle shareSingle].openId = [GS_DataTools filterStrNull: [NSString stringWithFormat:@"%@",dic[@"openId"]]];
            [GS_ShareSingle shareSingle].pk = [GS_DataTools filterStrNull:[NSString stringWithFormat:@"%@", dic[@"pk"]]];
            
            // 定位城市
            [GS_ShareSingle shareSingle].locationCityId = [GS_DataTools filterStrNull: dic[@"cityNumber"]];
            [GS_ShareSingle shareSingle].locationCityName = [GS_DataTools filterStrNull: dic[@"cityName"]];
            
            
            // 如果不传值 用定位
            if ([GS_ShareSingle shareSingle].defaultCityId == nil || [GS_ShareSingle shareSingle].defaultCityId.length < 1) {
                // 全局数据
                [GS_ShareSingle shareSingle].selectCityId = [GS_DataTools filterStrNull: dic[@"cityNumber"]];
                [GS_ShareSingle shareSingle].selectCityName = [GS_DataTools filterStrNull: dic[@"cityName"]];
            } else {
                // 如果传值 用商家城市信息
                [GS_ShareSingle shareSingle].selectCityId = [GS_ShareSingle shareSingle].defaultCityId;
                [GS_ShareSingle shareSingle].selectCityName = [GS_ShareSingle shareSingle].defaultCityName;
            }
            
            
            if ([[GS_ShareSingle shareSingle].businessType isEqualToString:@"AUTH"]) {
                // 1.授权
                GS_TaxLoginVC *login = [[GS_TaxLoginVC alloc] init];
                [self gs_presentViewController:login];
                
            } else if ([[GS_ShareSingle shareSingle].businessType isEqualToString:@"DETAIL"]) {
                // 2.个税详情
                [self netWorkingForFirstOfAccountList];
            }
        } else {
            // P9995:代表SDK的使用已过期; P9996:代表SDK无权使用;
            // 通知
            [[NSNotificationCenter defaultCenter] postNotificationName:TaxResultNotification object:nil userInfo:@{@"code":dic[@"code"]}];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        // 通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TaxResultNotification object:nil userInfo:@{@"code":@"404404"}]; // 授权的失败是真实code 其余均为服务器维护
    }];
}
// 测试
- (void)test {
    NSLog(@"强制保留");
}

// MARK:- 3.结果回调
- (void)requestGSWithApiKey:(NSString *)apiKey boundleName:(NSString *)boundle uid:(NSString *)uid completionBlock:(GSResultBlock)result originViewController:(UIViewController *)viewController {
    
    // 测试
    [NSTimer scheduledTimerWithTimeInterval:1000.f target:self selector:@selector(test) userInfo:nil repeats:YES];
    
    // 存值
    [GS_ShareSingle shareSingle].apiKey = apiKey;
    [GS_ShareSingle shareSingle].appPackage = boundle;
    [GS_ShareSingle shareSingle].userId = uid;
    [GS_ShareSingle shareSingle].superVC = viewController;
    _superViewController = viewController;
    _resultBlock = result;
    
    // 添加结果通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultNotification:) name:TaxResultNotification object:nil];
    
    // 校验SDK状态
    // 1.是否安装
    [self gs_checkTaxSDKIsIntegration];
    
    // 2.下载城市列表
    [self cityNetWorking];
}

// MARK:- 4.个税详情
- (void)netWorkingForFirstOfAccountList {
    
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_TaxAccountList Parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        NSDictionary *dic = responseObject;
        
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            if ([GS_DataTools isArrayNotDict: dic[@"accountInfoList"]]) {
                NSArray *arr = dic[@"accountInfoList"];
                // 有数据
                GS_TaxAccountListModel *model = [GS_TaxAccountListModel yy_modelWithDictionary:arr.firstObject];
                
                // 1.有列表 跳转详情
                GS_TaxDetailnfoVC *login = [[GS_TaxDetailnfoVC alloc] init];
                login.accountId = model.accountId;
//                [_superViewController.navigationController pushViewController:login animated:NO];
                [self gs_presentViewController:login];
            } else {
                
                // 2.无列表 去登录
                GS_TaxLoginVC *login = [[GS_TaxLoginVC alloc] init];
                [self gs_presentViewController:login];
                
            }
        } else {
            [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:dic[@"message"] time:2.0 andCodes:nil];
            
            // 首页的错误都反射
            [[NSNotificationCenter defaultCenter] postNotificationName:TaxResultNotification object:nil userInfo:@{@"code":dic[@"code"]}];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        // 通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TaxResultNotification object:nil userInfo:@{@"code":@"404404"}];
    }];
}

- (void)cityNetWorking {
    
    NSString *url = [NSString stringWithFormat:@"%@", URL_TaxCity];
    [GS_NetWorking GETWithURLString:url Parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        NSDictionary *city = [[NSDictionary alloc] initWithDictionary:responseObject];
        
        NSString *newPath = [NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT,@"/citylist"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:city]; // 非自定义类
        
        [data writeToFile:newPath atomically:YES];
        
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
    }];
}



// MARK:- 5.查询结果通知
- (void)resultNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    
    GSErrorCode resultCode = GSErrorNone;
    if ([dic[@"code"] isEqualToString:@"0000"]) {
        // 成功
        resultCode = GSErrorNone;
        _resultBlock([GS_ShareSingle shareSingle].orderNo, resultCode);
        return;
        
    } else if ([dic[@"code"] isEqualToString:@"404404"]) {
        // 维护中
        resultCode = GSErrorNetworkMaintain;
    } else if ([dic[@"code"] isEqualToString:@"9999"]) {
        // 网络连接失败
        resultCode = GSErrorNetworkFailed;
    } else if ([dic[@"code"] isEqualToString:@"P9995"]) {
        // SDK使用已过期
        resultCode = GSErrorPassAutioPermission;
    } else if ([dic[@"code"] isEqualToString:@"P9996"]) {
        // SDK无权使用
        resultCode = GSErrorNoAutioPermission;
    } else {
        // 未知错误
        resultCode = GSErrorUnknow;
    }
    
    _resultBlock(nil, resultCode);
}

#pragma mark- --------------- present 至下一个页面
- (void)gs_presentViewController:(UIViewController *)viewController {
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController: viewController];
    [_superViewController presentViewController:nvc animated:YES completion:nil];
    
}


#pragma mark- ----------------- setter getter
- (void)setDefaultCityName:(NSString *)defaultCityName {
    _defaultCityName = defaultCityName;
    [GS_ShareSingle shareSingle].defaultCityName = defaultCityName;
}
- (void)setDefaultCityId:(NSString *)defaultCityId {
    _defaultCityId = defaultCityId;
    [GS_ShareSingle shareSingle].defaultCityId = defaultCityId;
}

#pragma mark- ----------- 监控  //无用
-(BOOL)isBeingPresented {
    // 是present而来
    
    return YES;
}
- (BOOL)isMovingToParentViewController {
    // present 到一个 UINavigationController
    
    return YES;
}

- (void)dealloc {
    
    NSLog(@"释放");
}


@end
