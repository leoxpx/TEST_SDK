//
//  GS_TaxLoginOverdueVC.m
//  BaseSDK
//
//  Created by xinwang on 2018/1/8.
//  Copyright © 2018年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginOverdueVC.h"
#import "GS_TaxInputAlertView.h" // 弹框
#import "GS_TaxLoginCell.h" // cell
#import "GS_TaxInputInfosModel.h" // 输入项的model
#import "GS_TaxLoginAnimationView.h" // 动画
#import "GS_TaxDetailnfoVC.h" // 详情

@interface GS_TaxLoginOverdueVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    GS_TaxInputAlertView *_alertView;
    UITableView *_tableView;
    UIImageView *_codeImage; // 验证码
    UIImageView *_loadImage; // 验证码菊花
    GS_TaxInputInfosModel *_inputInfosModel;
    GS_TaxLoginAnimationView *_animationView; // 动画
}
@end

@implementation GS_TaxLoginOverdueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 标题
    [self setupNavigationTitle:[NSString stringWithFormat:@"%@个税登录",self.cityName]];
    
    //解析表单
    [self setupSelfView];
}

- (void)setupSelfView {
    
    [_tableView removeFromSuperview];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height) style:UITableViewStylePlain];
    tableView.backgroundColor = GS_Background_Color;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    [self.view addSubview:tableView];
    _tableView = tableView;
}
// cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _formInfosModel.inputInfos.count;
}
// 头高 提示语
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    // 高度
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};  // 指定字号
    CGRect rect = [_formInfosModel.yzmTip boundingRectWithSize:CGSizeMake(GSScreen_Width - 40, 0) /*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat moneyHeights = rect.size.height;
    
    return moneyHeights + 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = GS_RGB(251, 254, 207);
    [self.view addSubview:backView];
    
    // 高度
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};  // 指定字号
    CGRect rect = [_formInfosModel.yzmTip boundingRectWithSize:CGSizeMake(GSScreen_Width - 40, 0) /*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat moneyHeights = rect.size.height;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, GSScreen_Width-40, moneyHeights)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textColor = GS_RGB(244, 37, 101);
    textLabel.numberOfLines = 0;
    [backView addSubview:textLabel];
    
    textLabel.text = [GS_DataTools filterStrNull:_formInfosModel.yzmTip];
    
    return backView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = GS_Background_Color;
    
    // 登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, GSScreen_Width-30, 45)];
    loginBtn.backgroundColor = GS_Main_Color;
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.cornerRadius = 2;
    loginBtn.layer.masksToBounds = YES;
    [backView addSubview:loginBtn];
    [loginBtn addActionWithBlock:^{
        
        // 提交
        [self netWorkingForLogin];
    }];
    
    // 提示语
    if ([GS_DataTools filterStrNull:self.formInfosModel.formTipBottom].length > 0) {
        
        loginBtn.frame = CGRectMake(15, 50, GSScreen_Width-30, 45);
        
        UIImageView *jingao = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
        jingao.image = GSImage_Named(@"gs_taxmoreinputtip");
        [backView addSubview:jingao];
        
        UILabel *jingaoText = [[UILabel alloc] initWithTextColor:nil font:12 textAlignment:NSTextAlignmentLeft text: _formInfosModel.formTipBottom];
        jingaoText.frame = CGRectMake(35, 10, GSScreen_Width-35, 15);
        jingaoText.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:jingaoText];
    }
    
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GS_TaxLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID2"];
    if (cell == nil) {
        cell = [[GS_TaxLoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    _inputInfosModel = _formInfosModel.inputInfos[indexPath.row];
    
    if ([_inputInfosModel.inputType isEqualToString:@"input"]) { // 输入
        
        [cell setupTitlte:_inputInfosModel.inputLabel inputText:_inputInfosModel.defaultValue inputPlaceholder:_inputInfosModel.inputTip inputAction:^{
            
            // 存值
            GS_TaxInputInfosModel *inputModel = _formInfosModel.inputInfos[indexPath.row];
            inputModel.defaultValue = cell.inputText.text;
            [_formInfosModel.inputInfos[indexPath.row] yy_modelSetWithDictionary: [inputModel yy_modelToJSONObject]];
            
        } selectAction:nil];
        cell.inputText.clearButtonMode = UITextFieldViewModeAlways; // 测试
        
    } else if ([_inputInfosModel.inputType isEqualToString:@"select"]) { // 选择
        NSMutableArray *idArr  = [NSMutableArray array];
        NSMutableArray *showArr  = [NSMutableArray array];
        for (NSDictionary *dicTemp in _inputInfosModel.options) {
            [idArr addObject:dicTemp[@"key"]];
            [showArr addObject:dicTemp[@"value"]];
        }
        
        [cell setupTitlte:_inputInfosModel.inputLabel inputText:showArr.firstObject inputPlaceholder:_inputInfosModel.inputTip inputAction:nil selectAction:^{
            
            GS_ActionSheetStringPicker * picker = [[GS_ActionSheetStringPicker alloc]initWithTitle:@"请选择登录类型" rows:showArr initialSelection:0 doneBlock:^(GS_ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                // 显示用
                cell.inputText.text = showArr[selectedIndex];
                // 存值
                GS_TaxInputInfosModel *inputModel = _formInfosModel.inputInfos[indexPath.row];
                inputModel.defaultValue = idArr[selectedIndex];
                [_formInfosModel.inputInfos[indexPath.row] yy_modelSetWithDictionary: [inputModel yy_modelToJSONObject]];
                
            } cancelBlock:nil origin:self.view];
            [picker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成"  style:UIBarButtonItemStylePlain target:nil action:nil]];
            [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消"  style:UIBarButtonItemStylePlain target:nil action:nil]];
            [picker showActionSheetPicker];
        }];
    } else if ([_inputInfosModel.inputType isEqualToString:@"password"]) { // 密码
        
        [cell setupTitlte:_inputInfosModel.inputLabel inputText:_inputInfosModel.defaultValue inputPlaceholder:_inputInfosModel.inputTip inputAction:^{
            
            // 存值
            GS_TaxInputInfosModel *inputModel = _formInfosModel.inputInfos[indexPath.row];
            inputModel.defaultValue = cell.inputText.text;
            [_formInfosModel.inputInfos[indexPath.row] yy_modelSetWithDictionary: [inputModel yy_modelToJSONObject]];
            
        } selectAction:nil];
        cell.inputText.secureTextEntry = YES;
    } else if ([_inputInfosModel.inputType isEqualToString:@"imgCode"]) { // 图片
        // 验证码
        _codeImage = cell.codeImgView;
        
        [cell setupTitlte:_inputInfosModel.inputLabel inputText:_inputInfosModel.defaultValue inputPlaceholder:_inputInfosModel.inputTip inputAction:^{
            
            // 存值
            GS_TaxInputInfosModel *inputModel = _formInfosModel.inputInfos[indexPath.row];
            inputModel.defaultValue = cell.inputText.text;
            [_formInfosModel.inputInfos[indexPath.row] yy_modelSetWithDictionary: [inputModel yy_modelToJSONObject]];
            
        } selectAction:nil];
        
        // 下载图片
        [self downloadCodeImage:cell.codeImgView refresh:NO];
        
        // 刷新下载图片
        WeakSelf(weakSelf);
        __weak GS_TaxLoginCell *weakCell = cell;
        
        cell.codeImgView.hidden = NO;
        cell.codeImgViewRefrenshAction = ^{
            
            [weakSelf downloadCodeImage:weakCell.codeImgView refresh:YES];
        };
    } else if ([_inputInfosModel.inputType isEqualToString:@"constants"]) { // 默认值 不可输入
        [cell setupTitlte:_inputInfosModel.inputLabel inputText:_inputInfosModel.defaultValue inputPlaceholder:_inputInfosModel.inputTip inputAction:nil selectAction:nil];
        cell.inputText.userInteractionEnabled = NO;
    } else {
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark:- -------------------- 接口请求 --------------
// MARK: 1.1 图片验证码
- (void)downloadCodeImage:(UIImageView *)imageView refresh:(BOOL)refresh {
    
    // 图片加载菊花
    [_loadImage removeFromSuperview];
    _loadImage = nil;
    UIImageView *loadImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    loadImage.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
    loadImage.image = GSImage_Named(@"gs_codeloading");
    loadImage.userInteractionEnabled = YES;
    [imageView addSubview:loadImage];
    _loadImage = loadImage;
    
    [GS_ViewTools startRotate:YES theView: loadImage];
    imageView.image = nil;
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"formId"] = _formInfosModel.formId;
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    requestDic[@"refresh"] = refresh ? @"1" : @"1"; // refresh 为真为刷新
    
    [GS_NetWorking POSTWithURLString:URL_TaxSiteImgCode Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        
        if (![[GS_DataTools filterStrNull: dic[@"imgBase64"]] isEqualToString:@""]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dic[@"imgBase64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            imageView.image = [UIImage imageWithData:imageData];
        } else {
            imageView.image = GSImage_Named(@"gs_imageCodeFaild"); // 失败占位图
        }
        
        [GS_ViewTools startRotate:NO theView: loadImage];
        loadImage.hidden = YES;
        [loadImage removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ViewTools startRotate:NO theView: loadImage];
        loadImage.hidden = YES;
        [loadImage removeFromSuperview];
        imageView.image = GSImage_Named(@"gs_imageCodeFaild"); // 失败占位图
    }];
}

// MARK: 1.2 提交
- (void)netWorkingForLogin {
    
    [self dismissKeyboard];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"cityId"] = [GS_ShareSingle shareSingle].selectCityId;
    requestDic[@"formId"] = _formInfosModel.formId;
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    
    NSMutableDictionary *loginParamsDic = [NSMutableDictionary dictionary];
    for (_inputInfosModel in _formInfosModel.inputInfos) {
        if ([_inputInfosModel.inputType isEqualToString:@"input"]) {
            NSString *key = _inputInfosModel.inputId;
            NSString *value = _inputInfosModel.defaultValue;
            if ([[GS_DataTools filterStrNull: value] isEqualToString: @""]) {
                [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:@"请完善信息" time:2.0 andCodes:nil];
                return;
            }
            loginParamsDic[key] = value;
        }
    }
    requestDic[@"loginParams"] = loginParamsDic;
    
    // 开始请求
    [self netWorkingLogin:requestDic];
}
- (void)netWorkingLogin:(NSDictionary *)requestDic {
    
    NSString * urlStr = [NSString stringWithFormat:@"%@", URL_TaxSiteSubmit];
    [GS_ProgressHUD showHUDView:YES];
    // 加密
    NSString *rsaStr = [GS_NetWorking RSAAndBASE64Encryptor:requestDic];
    [GS_NetWorking POSTWithURLString:urlStr Parameters:@{@"str" : rsaStr} successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        NSDictionary * dic = responseObject;
        
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            // 提交成功
            [self netWorkingForLoginState];
            
        } else {
            // 刷新验证码
            [self downloadCodeImage:_codeImage refresh:YES];
            
            [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:dic[@"message"] time:2.0 andCodes:nil];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:@"网络连接失败" time:2.0 andCodes:nil];
    }];
}

// MARK: 1.3 登录状态
- (void)netWorkingForLoginState {
    
    _animationView = [GS_TaxLoginAnimationView GS_ShareSingle];
    [_animationView startAnimation];
    [self.view addSubview:_animationView];
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    
    [GS_NetWorking POSTWithURLString:URL_TaxStatus Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        
        // 提示语
        _animationView.tipLabel.text = [GS_DataTools filterStrNull: dic[@"percentMsg"]];
        NSLog(@"登录状态 -> %@ %@", dic[@"status"], dic[@"percentMsg"]);
        
        if ([[GS_DataTools filterStrNull:dic[@"status"]] isEqualToString:@"1"]) {
            // 1.登录成功
            [GS_ShareSingle shareSingle].accountIdTax = dic[@"accountId"];
            
            [_animationView stopAnimation];
            _animationView = nil;
            
            // 成功操作
            if ([[GS_ShareSingle shareSingle].businessType isEqualToString: @"AUTH"]) {
                // 1.1 授权
                GS_TaxResultView *resultView = [[GS_TaxResultView alloc] initWithImageName:@"gs_resultright" tipsStr:@"授权成功" btnTitle:@"返回"];
                resultView.buttonClickBlock = ^{
                    
                    // 通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:TaxResultNotification object:nil userInfo:@{@"code":@"0000"}];
                    // 返回
                    [self.navigationController popViewControllerAnimated:YES];
                };
                [self.view addSubview:resultView];
                
            } else if ([[GS_ShareSingle shareSingle].businessType isEqualToString: @"DETAIL"]) {
                // 1.2 查询
                GS_TaxDetailnfoVC *detail = [[GS_TaxDetailnfoVC alloc] init];
                detail.accountId = dic[@"accountId"];
                [self.navigationController pushViewController:detail animated:YES];
            }
        } else if ([[GS_DataTools filterStrNull:dic[@"status"]] isEqualToString:@"-1"]) {
            
            [_animationView stopAnimation];
            _animationView = nil;
            
            NSDictionary *formInfoDic = dic[@"formInfo"];
            GS_TaxFormInfosModel *formInfosModelTemp = [GS_TaxFormInfosModel yy_modelWithDictionary:dic[@"formInfo"]];
            
            if (formInfoDic != nil && ![formInfoDic isKindOfClass:[NSNull class]]) {
//                NSDictionary *detailDic = formInfoDic[@"inputInfos"][0];
                
                // 2.1 再次输入
                if ([formInfosModelTemp.isFormPanel isEqualToString:@"0"]) {
                    
                    // 2.1.1 弹框图片验证码框 基本不存在
                    [self inputSMSNumView:formInfoDic];
                    
                } else if ([formInfosModelTemp.isFormPanel isEqualToString:@"1"]) {
                    
                    // 2.1.2 页面样式
                    [self moreInputItemsView];
                }
                
                return ;
            }
            // 刷新验证码
            [self downloadCodeImage:_codeImage refresh:YES];
            
            // 登录失败
            [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:[GS_DataTools filterStrNull:dic[@"errorMessage"]] time:2.5f andCodes:nil];
            
        } else if ([[GS_DataTools filterStrNull:dic[@"status"]] isEqualToString:@"0"]) {
            // 仍在登录中
            sleep(1);
            [self netWorkingForLoginState];
        } else {
            
            [_animationView stopAnimation];
            _animationView = nil;
            
            // 不存在
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [_animationView stopAnimation];
        _animationView = nil;
        
        // 通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TaxResultNotification object:nil userInfo:@{@"code":@"404404"}];
        // 失败
        [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:@"网络连接失败" time:2.0 andCodes:nil];
        
    }];
}

// MARK: 1.2 弹框样式
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
        [selfWeak.view endEditing:YES];
        // 删除动画
        [_alertViewWeak dismissInputAlertView];
        // 提交验证码
        [selfWeak uploadSMSNumberClick:_alertViewWeak.inputDic];
    }];
    
    // 取消按钮 返回
    [_alertView.cancalBtu addActionWithBlock:^{
        [_alertViewWeak dismissInputAlertView];
        // 只有180天取消是返回上级页面,其余是在当前页面无操作
        [selfWeak.navigationController popViewControllerAnimated:YES];
    }];
    
    
    // 弹出
    [_alertView showInputAlertView];
}
// 上传弹框验证码
- (void)uploadSMSNumberClick:(NSDictionary *)parameters{
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"formId"] = _formInfosModel.formId;
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    requestDic[@"loginParams"] = parameters;
    
    [self netWorkingLogin:requestDic];
}
// MARK: 1.6 页面样式
- (void)moreInputItemsView {
    
    GS_TaxLoginOverdueVC *tax = [[GS_TaxLoginOverdueVC alloc] init];
    tax.cityName = [GS_ShareSingle shareSingle].selectCityName;
    tax.cityId = [GS_ShareSingle shareSingle].selectCityId;
    tax.requestId = _requestId;
    tax.formInfosModel = _formInfosModel;
    [self.navigationController pushViewController:tax animated:YES];
}


// 当键盘改变了frame(位置和尺寸)的时候调用
-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify{
    
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY;
    if (_alertView.frame.origin.y+_alertView.frame.size.height >= keyboardFrame.origin.y) {
        transformY = _alertView.frame.origin.y+_alertView.frame.size.height - keyboardFrame.origin.y;
    } else {
        transformY = 0;
        _alertView.center = CGPointMake(_alertView.center.x, GSScreen_Height/2);
    }
    [UIView animateWithDuration:duration animations:^{
        _alertView.center = CGPointMake(_alertView.center.x, _alertView.center.y-transformY);
    }];
}
// 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
