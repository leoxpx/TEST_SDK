//
//  GS_TaxLoginVC.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/8.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginVC.h"
#import "GS_CityPickerVC.h" // 城市登录
#import "GS_TaxLoginModel.h" // model
#import "GS_TaxFormInfosModel.h" // 左右model
#import "GS_TaxInputInfosModel.h" // 输入model
#import "GS_TaxLoginCell.h" // cell
#import "GS_UIWebViewPublicVC.h" // 协议
#import "GS_TaxLoginAnimationView.h" // 登录动画
#import "GS_TaxDetailnfoVC.h" // 详情页
#import "GS_TaxLoginHelpVC.h" // 登录帮助
#import "GS_TaxInputAlertView.h" // 弹框
#import "GS_TaxLoginOverdueVC.h" // 180天


@interface GS_TaxLoginVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSString *_requestId; // 请求id
    UITableView *_tableView;
    UIView *_headerView; // 头部按钮试图
    GS_TaxLoginModel *_model;
    GS_TaxFormInfosModel *_formInfosModel;
    GS_TaxInputInfosModel *_inputInfosModel;
    GS_TaxUrlInfosModel *_urlInfosModel;
    UIImageView *_codeImage; // 验证码
    UIImageView *_loadImage; // 验证码菊花
    GS_TaxLoginAnimationView *_animationView; // 登录进度视图
    UIButton *_agreeBtn; // 服务协议
    GS_TaxInputAlertView *_alertView;
}
@end

@implementation GS_TaxLoginVC

// 重写返回
- (void)navigationPopBack {
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        // 退出授权
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // 返回上一级
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果是刷新进入, 取传值
    if (self.cityId) {
        //
        
    } else {
        // 如果是直接进入登录, 取选择城市
        self.cityId = [GS_ShareSingle shareSingle].selectCityId;
        self.cityName = [GS_ShareSingle shareSingle].selectCityName;
    }
    
    // 标题
    if ([[GS_ShareSingle shareSingle].businessType isEqualToString:@"AUTH"]) {
        // 1.授权
        [self setupNavigationTitle: [NSString stringWithFormat:@"%@个税授权", self.cityName]];
    } else if ([[GS_ShareSingle shareSingle].businessType isEqualToString:@"DETAIL"]) {
        // 2.个税详情
        [self setupNavigationTitle: [NSString stringWithFormat:@"%@个税登录", self.cityName]];
    }
    
    // 导航栏右按钮
    [self setupNVCRightBtn];
    
    // 1.获取登录表单
    [self netWorkingForInputText];
}

// MARK: 导航栏右按钮
- (void)setupNVCRightBtn {
    
    UIButton *rightBtn = [[UIButton alloc] initWithMainTextColorText:@"切换城市"];
    [rightBtn sizeToFit];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addActionWithBlock:^{
        // 跳转城市选择
        [self jumpToCityPicker];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
// 跳转城市选择
- (void)jumpToCityPicker {
    
    GS_CityPickerVC *city = [[GS_CityPickerVC alloc] init];
//    city.locationCity = [GS_ShareSingle shareSingle].locationCityName;
//    city.locationCityId = [GS_ShareSingle shareSingle].locationCityId;
    city.selectCityNameAndId = ^(NSString *cityName, NSString *cityId) {
        
        [GS_ShareSingle shareSingle].selectCityName = cityName;
        [GS_ShareSingle shareSingle].selectCityId = cityId;
        
        self.cityId = cityId;
        self.cityName = cityName;
        
        [self setupNavigationTitle: [NSString stringWithFormat:@"%@个税登录", self.cityName]];
        
        // 获取登录表单
        [self netWorkingForInputText];
    };
    [self.navigationController pushViewController:city animated:YES];
}


//MARK: 2.1 输入界面
- (void)setupSelfTableView {
    
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
// 头高 控制顶部无按钮或有两个按钮
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_model.formInfos.count == 1) {
        return 10;
    } else {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 190;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_model.formInfos.count == 1) {
        return nil;
    } else if (_model.formInfos.count == 2) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        
        // 两个按钮
        GS_TaxFormInfosModel *model1 = _model.formInfos.firstObject;
        GS_TaxFormInfosModel *model2 = _model.formInfos.lastObject;
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width/2, 48)];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [leftBtn setTitle:model1.formName forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:GS_Main_Color forState:UIControlStateSelected];
        [backView addSubview:leftBtn];
        [leftBtn addActionWithBlock:^{
           
            _formInfosModel = model1;
            [tableView reloadData];
        }];
        
        UIButton *rightBtn =  [[UIButton alloc] initWithFrame:CGRectMake(GSScreen_Width/2, 0, GSScreen_Width/2, 48)];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [rightBtn setTitle:model2.formName forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:GS_Main_Color forState:UIControlStateSelected];
        [backView addSubview:rightBtn];
        [rightBtn addActionWithBlock:^{
            
            _formInfosModel = model2;
            [tableView reloadData];
        }];
        
        UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42, GSScreen_Width/2, 2)];
        blueLine.backgroundColor = GS_Main_Color;
        [backView addSubview:blueLine];
        if (_formInfosModel == model1) {
            leftBtn.selected = YES;
            rightBtn.selected = NO;
        } else {
            leftBtn.selected = NO;
            rightBtn.selected = YES;
            blueLine.frame = CGRectMake(GSScreen_Width/2, 42, GSScreen_Width/2, 2);
        }
        
        return backView;
    } else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = GS_Background_Color;
    
    // 服务协议
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 35, 12, 12)];
    [agreeBtn setImage:GSImage_Named(@"gs_agreebutton@2x") forState:UIControlStateNormal];
    [agreeBtn setImage:GSImage_Named(@"gs_agreebutton@2x") forState:UIControlStateSelected];
    agreeBtn.backgroundColor = GS_Main_Color;
    agreeBtn.layer.cornerRadius = 2;
    agreeBtn.layer.masksToBounds = YES;
    agreeBtn.selected = YES;
    [backView addSubview:agreeBtn];
    _agreeBtn = agreeBtn;
    
    __weak UIButton *weakAgreeBtn = agreeBtn;
    [agreeBtn addActionWithBlock:^{
      
        weakAgreeBtn.selected = !weakAgreeBtn.selected;
        if (weakAgreeBtn.selected == YES) {
            weakAgreeBtn.backgroundColor = GS_Main_Color;
        } else {
            weakAgreeBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }];
    
    UIButton *agreeTextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+12+10, 34, 190, 15)];
    agreeTextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"我同意《数据解析服务协议》"];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 3)];
    [attStr addAttribute:NSForegroundColorAttributeName value:GS_Main_Color range:NSMakeRange(3, 10)];
    [agreeTextBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    [backView addSubview:agreeTextBtn];
    [agreeTextBtn addActionWithBlock:^{
        
        GS_UIWebViewPublicVC *web = [[GS_UIWebViewPublicVC alloc] init];
        web.links = _model.dataParserUrl;
        [self.navigationController pushViewController:web animated:YES];
    }];
    
    // 找回密码
    UIButton *backPassBtn = [[UIButton alloc] initWithFrame:CGRectMake(GSScreen_Width-15-60, 12, 60, 15)];
    [backPassBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [backPassBtn setTitleColor:GS_Main_Color forState:UIControlStateNormal];
    backPassBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backPassBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:backPassBtn];
    [backPassBtn addActionWithBlock:^{
        
//        for (_urlInfosModel in _model.urlInfos) {
//            if ([_urlInfosModel.urlType isEqualToString:@"findPassword"]) {
//                GS_UIWebViewPublicVC *web = [[GS_UIWebViewPublicVC alloc] init];
//                web.links = _urlInfosModel.url;
//                web.successLinks = _urlInfosModel.backUrl;
//                [self.navigationController pushViewController:web animated:YES];
//                return;
//            }
//        }
        GS_TaxLoginHelpVC *help = [[GS_TaxLoginHelpVC alloc] init];
        help.data = _model.siteHelp;
        [self.navigationController pushViewController:help animated:YES];
    }];
    
    // 登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 65, GSScreen_Width-30, 45)];
    loginBtn.backgroundColor = GS_Main_Color;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.cornerRadius = 2;
    loginBtn.layer.masksToBounds = YES;
    [backView addSubview:loginBtn];
    [loginBtn addActionWithBlock:^{
        
        [self netWorkingForLogin];
    }];
    
    // 注册
    UIButton *registBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 130, GSScreen_Width-30, 45)];
    registBtn.backgroundColor = [UIColor whiteColor];
    [registBtn setTitle:@"没有账户，立即注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:GS_Main_Color forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    registBtn.layer.cornerRadius = 2;
    registBtn.layer.masksToBounds = YES;
    [backView addSubview:registBtn];
    [registBtn addActionWithBlock:^{
        
        for (_urlInfosModel in _model.urlInfos) {
            if ([_urlInfosModel.urlType isEqualToString:@"register"]) {
                GS_UIWebViewPublicVC *web = [[GS_UIWebViewPublicVC alloc] init];
                web.links = _urlInfosModel.url;
                web.successLinks = _urlInfosModel.backUrl;
                [self.navigationController pushViewController:web animated:YES];
                return;
            }
        }
        GS_TaxLoginHelpVC *help = [[GS_TaxLoginHelpVC alloc] init];
        help.data = _model.siteHelp;
        [self.navigationController pushViewController:help animated:YES];
    }];
    
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
    } else if ([_inputInfosModel.inputType isEqualToString:@"smsCode"]) { // 短信
        
        
    } else {
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark:- -------------------- 接口请求 --------------
// MARK:- 1.1 获取登录表单
- (void)netWorkingForInputText {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"cityId"] = self.cityId;
    
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_TaxSiteInfo Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        NSDictionary *dic = responseObject;
        
        GS_TaxLoginModel *model = [GS_TaxLoginModel yy_modelWithDictionary: dic];
        _model = model;
        _formInfosModel = _model.formInfos.firstObject; // 默认左按钮 需提前设置
        _requestId = _model.orderNo;
        
        if ([[GS_DataTools filterStrNull: model.code] isEqualToString:@"0000"]) {
         
            if ([model.status isEqualToString:@"-1"]) {
            
                // 1.没有开通
                GS_TaxResultView *resultView = [[GS_TaxResultView alloc] initWithImageName:@"gs_resultwrong" tipsStr:@"该地区未开通，请切换城市" btnTitle:@"重新选择"];
                resultView.buttonClickBlock = ^{
                
                    // 跳转城市选择
                    [self jumpToCityPicker];
                };
            
                [self.view addSubview:resultView];
            
            } else if ([model.status isEqualToString:@"0"]) {
                
                // 2.维护
                GS_TaxResultView *resultView = [[GS_TaxResultView alloc] initWithImageName:@"gs_resultwarning" tipsStr:@"系统维护中" btnTitle:@"重新选择"];
                resultView.buttonClickBlock = ^{
                    
                    // 跳转城市选择
                    [self jumpToCityPicker];
                };
                
                [self.view addSubview:resultView];
                
            } else if ([model.status isEqualToString:@"1"]) {
                // 3.正常
                [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                // 创建视图 解析数据
                [self setupSelfTableView];
            }
        } else if ([model.code isEqualToString:@"9994"]) {
            // 重新登录
            [self netWorkingForInputText];
        } else {
            [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:model.message time:2.0 andCodes:nil];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:@"网络连接失败" time:2.0 andCodes:nil];
    }];
}

// MARK:- 1.2 图片验证码
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

// MARK:- 1.3 登录
- (void)netWorkingForLogin {
    
    [self dismissKeyboard];
    
    if (_agreeBtn.selected == NO) {
        [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:@"请先同意数据解析服务协议" time:2.0 andCodes:nil];
        return;
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"cityId"] = self.cityId;
    requestDic[@"formId"] = _formInfosModel.formId;
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    
    NSMutableDictionary *loginParamsDic = [NSMutableDictionary dictionary];
    for (_inputInfosModel in _formInfosModel.inputInfos) {
        
        NSString *key = _inputInfosModel.inputId;
        NSString *value = _inputInfosModel.defaultValue;
        if ([[GS_DataTools filterStrNull: value] isEqualToString: @""]) {
            [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:@"请完善信息" time:2.0 andCodes:nil];
            return;
        }
        loginParamsDic[key] = value;
    }
    requestDic[@"loginParams"] = loginParamsDic;
    
    // 开始请求
    [self netWorkingLogin:requestDic];
}
- (void)netWorkingLogin:(NSDictionary *)requestDic {
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",URL_TaxSiteSubmit];
    [GS_ProgressHUD showHUDView:YES];
    // 加密
    NSString *rsaStr = [GS_NetWorking RSAAndBASE64Encryptor:requestDic];
    [GS_NetWorking POSTWithURLString:urlStr Parameters:@{@"str":rsaStr} successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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

// MARK:- 1.4 登录状态
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
                    [self navigationPopBack];
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
            
            GS_TaxFormInfosModel *formInfosModelTemp = [GS_TaxFormInfosModel yy_modelWithDictionary:dic[@"formInfo"]];
            NSDictionary *formInfoDic = dic[@"formInfo"];
            
            if (formInfosModelTemp != nil && ![formInfosModelTemp isKindOfClass:[NSNull class]]) {
//                NSDictionary *detailDic = formInfoDic[@"inputInfos"][0];
                
                // 2.1 再次输入
                if ([formInfosModelTemp.isFormPanel isEqualToString:@"0"]) {
                    
                    // 2.1.1 弹框图片验证码框 基本不存在
                    [self inputSMSNumView:formInfoDic];
                    
                } else if ([formInfosModelTemp.isFormPanel isEqualToString:@"1"]) {
                    
                    // 2.1.2 页面样式
                    [self moreInputItemsView: formInfoDic];
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
            
            // 不存在情况
            [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:@"未知错误 status" time:2.0 andCodes:nil];
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


// MARK:- 1.5 弹框样式
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
        
//        [selfWeak setupSelfTableView];
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

// MARK:- 1.6 页面样式
- (void)moreInputItemsView:(NSDictionary *)formInfoDic {
    
    GS_TaxLoginOverdueVC *tax = [[GS_TaxLoginOverdueVC alloc] init];
    tax.cityName = self.cityName;
    tax.cityId = self.cityId;
    tax.requestId = _requestId;
    tax.formInfosModel = [GS_TaxFormInfosModel yy_modelWithDictionary: formInfoDic];
    [self.navigationController pushViewController:tax animated:YES];
}


// 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
