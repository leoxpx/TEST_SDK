//
//  GS_TaxInputAlertView.m
//  BaseSDK
//
//  Created by 许墨 on 2018/1/13.
//  Copyright © 2018年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxInputAlertView.h"

// 弹框视图的宽
#define AlertWidth GSScreen_Width-66


@interface GS_TaxInputAlertView() <UITextFieldDelegate>
{
    UIView *_blackView; // 黑色视图
    UIImageView *_loadImage;
    NSString *_requestId;
    NSDictionary *_formInfoDic;
    NSArray *_inputInfos;
    
}
@end

@implementation GS_TaxInputAlertView


- (instancetype)initWithFormInfo:(NSDictionary *)formInfo andRequestId:(NSString *)requestId {
    
    self = [super init];
    if (self) {
        // 赋值
        _requestId = requestId;
        _formInfoDic = formInfo;
        
        _inputTextFieldsArr = [NSMutableArray array];
        _inputDic = [NSMutableDictionary dictionary];
        
        [self setupSelfView:formInfo];
    }
    return self;
}

// MARK: 布局视图
- (void)setupSelfView:(NSDictionary*)feildDict{
    
    if (_blackView) {
        [_blackView removeFromSuperview];
        [self removeFromSuperview];
    }
    // 1.透明遮罩
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.6;
    _blackView = blackView;
    
    // 2.自身弹框
    self.backgroundColor = [UIColor whiteColor];
    [self setupCornerRadius:8];
    
    // title 高70
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AlertWidth, 70)];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    if (![[GS_DataTools filterStrNull:feildDict[@"yzmTip"]] isEqualToString:@""]){
        alertLabel.text = [NSString stringWithFormat:@"%@", feildDict[@"yzmTip"]];
    } else {
        alertLabel.text = @"更新信息";
    }
    alertLabel.textColor = GS_RGB(51, 51, 51);
    alertLabel.numberOfLines = 1;
    alertLabel.font = [UIFont systemFontOfSize:16];
    alertLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:alertLabel];
    
    // 输入框表单
    _inputInfos = [NSArray arrayWithArray: feildDict[@"inputInfos"]];
    
    // 输入框背景
    UIView *totalInputView = [[UIView alloc] initWithFrame:CGRectMake(25, 70, AlertWidth-50, _inputInfos.count * (44+16))];
    [self addSubview:totalInputView];
    
    // 动态创建输入框
    for (int i = 0; i < _inputInfos.count; i++) {
        // 取到输入框信息
        NSDictionary *inputInfos = _inputInfos[i];
        
        // 边框背景
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, (44+16)*i, AlertWidth-50, 44)];
        [inputView setupBorderRadius:0.5 color:GS_Cell_Color];
        [totalInputView addSubview:inputView];
        
        // 输入框
        UITextField *textFie = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, inputView.frame.size.width-15, 44)];
        textFie.backgroundColor = [UIColor clearColor];
        textFie.placeholder = [[GS_DataTools filterStrNull: inputInfos[@"inputInfos"]] isEqualToString:@""] ? @"请输入验证码" :  inputInfos[@"inputInfos"];
        textFie.font = [UIFont systemFontOfSize:15];
        textFie.tag = 5000+i;
        textFie.delegate = self;
        [inputView addSubview:textFie];
        [textFie addTarget:self action:@selector(inputChange:) forControlEvents:UIControlEventEditingChanged];
        
        // 存输入框
        [self.inputTextFieldsArr addObject:textFie];
        // 存id
        [self.inputDic setValue:textFie.text forKey:inputInfos[@"inputId"]];
        
        if ([[GS_DataTools filterStrNull: inputInfos[@"inputType"]] isEqualToString:@"imgCode"]) {
            
            // 更新输入框坐标
            textFie.frame = CGRectMake(15, 0, inputView.frame.size.width-15-80-3, 44);
            
            // 添加验证码
            UIImageView *codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(inputView.frame.size.width - 80 - 3 , 3, 80, 38)];
            codeImg.backgroundColor = GS_Background_Color;
            codeImg.userInteractionEnabled = YES;
            [inputView addSubview:codeImg];
            
            // 添加刷新手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refrenshCode:)];
            [codeImg addGestureRecognizer:tap];
            
            // 下载验证码
            [self downloadCodeImage:codeImg refresh:1];
        }
    }
    
    // 按钮
    UIButton *sureBtn = [[UIButton alloc] initWithMainBackgroundColorText:@""];
    sureBtn.frame = CGRectMake(55, 70 + _inputInfos.count * (44+16) + 10, AlertWidth-110, 40);
    if ([[GS_DataTools filterStrNull:feildDict[@"btnText"]] isEqualToString:@""]) {
        [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    } else {
        [sureBtn setTitle:feildDict[@"btnText"] forState:UIControlStateNormal];
    }
    [self addSubview:sureBtn];
    self.sureBtn = sureBtn;
    
    // X
    UIButton *cancalBtn = [[UIButton alloc] initWithImage:@"gs_closeTip" text:@""];
    cancalBtn.frame = CGRectMake(AlertWidth - 22, 11, 11, 11);
    [self addSubview:cancalBtn];
    self.cancalBtu = cancalBtn;
    
    self.frame = CGRectMake(0, 0, AlertWidth, sureBtn.frame.origin.y + 40 + 22);
    self.center = CGPointMake(GSScreen_Width/2, GSScreen_Height/2 - 50);
}


// MARK: 刷新验证码
- (void)refrenshCode:(UITapGestureRecognizer *)sender{
    
    UIImageView *imageView = (UIImageView *)sender.view;
    [self downloadCodeImage:imageView refresh:YES];
}
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
    requestDic[@"iDQsSGtSEuqERNoITaZiROtHUa"] = _requestId;
    requestDic[@"refresh"] = refresh ? @"1" : @"1"; // refresh 为真为刷新
    
    [GS_NetWorking POSTWithURLString:URL_TaxSiteImgCode Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        
        if (![[GS_DataTools filterStrNull: dic[@"imgBase64"]] isEqualToString:@""]) {
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:dic[@"imgBase64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            imageView.image = [UIImage imageWithData:imageData];
        } else {
            imageView.image = GSImage_Named(@"gs_imageCodeFaild"); // 失败占位图
            
            [GS_ProgressHUD showHUDView:[UIApplication sharedApplication].keyWindow states:NO title:@"" content:[GS_DataTools filterStrNull:dic[@"message"]] time:2.5f andCodes:nil];
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

- (void)inputChange:(UITextField *)textField {
    
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *inputInfos = _inputInfos[textField.tag-5000];
    [self.inputDic setValue:textField.text forKey:inputInfos[@"inputId"]];
}

- (void)showInputAlertView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 动画
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0.8;
    [UIView animateWithDuration:0.35 delay:0.1 usingSpringWithDamping:0.7f initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0;
    } completion: nil];
}

- (void)dismissInputAlertView {
    
    [_blackView removeFromSuperview];
    [self removeFromSuperview];
    
    // 动画
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.alpha = 1;
    [UIView animateWithDuration:0.35 delay:0.1 usingSpringWithDamping:0.999f initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.001;
    } completion: nil];
}


// 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
