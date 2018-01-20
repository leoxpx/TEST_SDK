//
//  GS_TaxRefreshVM.m
//  BaseSDK
//
//  Created by xinwang on 2018/1/9.
//  Copyright © 2018年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxRefreshVM.h"
#import "GS_TaxLoginAnimationView.h" // 动画
#import "GS_TaxLoginVC.h" // 重新登录
#import "GS_TaxInputAlertView.h" // 弹框
#import "GS_TaxLoginOverdueVC.h" // 页面
#import "GS_TaxFormInfosModel.h" // model

NSString *_requestId; // 请求id
GS_TaxLoginAnimationView *_animationView;
GS_TaxInputAlertView *_alertView;
GS_TaxFormInfosModel *_formInfosModel;
NSString *_formId; // 表单ID

@implementation GS_TaxRefreshVM

// 开始刷新
- (void)startRefreshTaxDataSuccessBlock:(void (^)(NSDictionary *dict))successBlock {
    
    self.successBlock = successBlock;
    
    // 1.请求登录
    [self netWorkingForLoginFirst];
    
}

// MARK: 1. 提交登录信息 4. 验证后重新提交登录信息(不会循环,返回状态参数会终止)
- (void)netWorkingForLoginFirst {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"dIQsSGtNUOcCaNoITaZiROtHUa"] = _accountId; // 有accountId不用传cityId 否则会覆盖城市
    
    // 开始请求
    [self netWorkingLogin:requestDic];
}
- (void)netWorkingLogin:(NSDictionary *)requestDic {
    
    // 收键盘
    [_superVC.view endEditing:YES];
    
    // 加密
    NSString *rsaStr = [GS_NetWorking RSAAndBASE64Encryptor:requestDic];
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_TaxSiteSubmit Parameters:@{@"str":rsaStr} successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        [GS_ProgressHUD showHUDView:NO];
        
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            
            _requestId = dic[@"orderNo"];
            // 提交成功
            [self netWorkingForLoginState];
            
        } else {
            // 错误
            [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:dic[@"message"] time:2.0 andCodes:nil];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        // 失败
        [GS_ProgressHUD showHUDView:NO];
        [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:@"网络连接失败,请稍后再试" time:2.0 andCodes:nil];
    }];
}

// MARK: 2.获取登录状态
- (void)netWorkingForLoginState {
    
    _animationView = [GS_TaxLoginAnimationView GS_ShareSingle];
    [_animationView startAnimation];
    [_superVC.view addSubview:_animationView];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    
    [GS_NetWorking POSTWithURLString:URL_TaxStatus Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary * dic = responseObject;
        
        // 提示语
        _animationView.tipLabel.text = [GS_DataTools filterStrNull: dic[@"percentMsg"]];
        NSLog(@"登录状态 -> %@ %@", dic[@"status"], dic[@"percentMsg"]);
        
        if ([[GS_DataTools filterStrNull:dic[@"status"]] isEqualToString:@"1"]) {
            
            [_animationView stopAnimation];
            _animationView = nil;
            
            // 1.1 登录成功
            [GS_ShareSingle shareSingle].accountIdTax = dic[@"accountId"];
//            [GS_ShareSingle shareSingle].orderNo = dic[@"orderNo"];
            
            // 1.2 回调结果
            if (_successBlock) {
                self.successBlock(dic);
            }
            
            [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:YES title:@"" content:@"刷新成功" time:2.5f andCodes:^{
                
            }];
        } else if ([[GS_DataTools filterStrNull:dic[@"status"]] isEqualToString:@"-1"]) {
            
            [_animationView stopAnimation];
            _animationView = nil;
            
            // 2.登录失败 判断relogin
            if ([[GS_DataTools filterStrNull: dic[@"relogin"]] isEqualToString:@"1"]) {
                // 2.1 需要重新登录
                [GS_ProgressHUD showHUDView:_superVC.view states:NO title:@"" content:@"请重新登录" time:2.0 andCodes:^{
                    GS_TaxLoginVC *login = [[GS_TaxLoginVC alloc] init];
                    login.cityId = self.accountCityId;
                    login.cityName = self.accountCityName;
                    [_superVC.navigationController pushViewController:login animated:YES];
                }];
            } else {
                // 2.2 需要重新验证
                GS_TaxFormInfosModel *formInfosModelTemp = [GS_TaxFormInfosModel yy_modelWithDictionary:dic[@"formInfo"]];
                
                NSDictionary *formInfoDic = dic[@"formInfo"];
                _formId = formInfoDic[@"formId"];
                
                if (formInfoDic != nil && ![formInfoDic isKindOfClass:[NSNull class]]) {
//                    NSDictionary * detailDic = formInfoDic[@"inputInfos"][0];
                    
                    [GS_ProgressHUD showHUDView:_superVC.view states:NO title:@"" content:[GS_DataTools filterStrNull:dic[@"errorMessage"]] time:2.0 andCodes:^{
                        // 再次输入
                        if ([formInfosModelTemp.isFormPanel isEqualToString:@"0"]) {
                            
                            // 2.1.1 弹框图片验证码框
                            [self inputSMSNumView:formInfoDic];
                            
                        } else if ([formInfosModelTemp.isFormPanel isEqualToString:@"1"]) {
                            
                            // 2.1.2 页面样式
                            [self moreInputItemsView:formInfoDic];
                        }
                    }];
                } else {
                    // 3.其他失败
                    [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:[GS_DataTools filterStrNull:dic[@"errorMessage"]] time:2.5f andCodes:nil];
                }
            }
        } else if ([[GS_DataTools filterStrNull:dic[@"status"]] isEqualToString:@"0"]) {
            // 仍在登录中
            sleep(1);
            [self netWorkingForLoginState];
        } else {
            [_animationView stopAnimation];
            _animationView = nil;
            
            // 其他错误
            [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:[GS_DataTools filterStrNull:dic[@"message"]] time:2.0 andCodes:nil];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [_animationView stopAnimation];
        _animationView = nil;
    }];
}

// MARK: 3 弹框样式
- (void)inputSMSNumView:(NSDictionary *)formInfoDic {
    
    _alertView = [[GS_TaxInputAlertView alloc] initWithFormInfo:formInfoDic andRequestId:_requestId];
    
    @WeakObj(_alertView);
    @WeakObj(self);
    
    // 确定按钮
    [_alertView.sureBtn addActionWithBlock:^{
        
        // 过滤数据
        for (UITextField *textF in _alertViewWeak.inputTextFieldsArr) {
            if (textF.text.length <= 0) {
                [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:textF.placeholder time:2.0 andCodes:nil];
                return;
            }
        }
        
        // 收键盘
        [_superVC.view endEditing:YES];
        // 删除动画
        [_alertViewWeak dismissInputAlertView];
        // 提交验证码
        [selfWeak uploadSMSNumberClick:_alertViewWeak.inputDic];
    }];
    
    // 取消按钮 返回
    [_alertView.cancalBtu addActionWithBlock:^{
        [_alertViewWeak dismissInputAlertView];
        
//        [_superVC.navigationController popViewControllerAnimated:YES];
    }];
    
    // 弹出
    [_alertView showInputAlertView];
}

// 上传弹框验证码
- (void)uploadSMSNumberClick:(NSDictionary *)parameters{
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"formId"] = _formId;
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    requestDic[@"dIQsSGtNUOcCaNoITaZiROtHUa"] = _accountId;
    requestDic[@"loginParams"] = parameters;
    
    [self netWorkingLogin:requestDic];
}

// MARK: 4 页面样式
- (void)moreInputItemsView:(NSDictionary *)formInfoDic {
    
    GS_TaxLoginOverdueVC *tax = [[GS_TaxLoginOverdueVC alloc] init];
    tax.cityName = [GS_ShareSingle shareSingle].selectCityName;
    tax.cityId = [GS_ShareSingle shareSingle].selectCityId;
    tax.requestId = _requestId;
    tax.formInfosModel = [GS_TaxFormInfosModel yy_modelWithDictionary: formInfoDic];
    [_superVC.navigationController pushViewController:tax animated:YES];
}


@end
