//
//  XWMobileAlertView.m
//  GeShuiGuanJia
//
//  Created by xinwang2 on 2018/1/5.
//  Copyright © 2018年 杭州薪王. All rights reserved.
//

#import "GS_MobileAlertView.h"

@interface GS_MobileAlertView() <UITextFieldDelegate>
{
    UIImageView *_loadImage;
    
    NSString *_requestId;
    NSDictionary *_formInfoDic;
}
@property(nonatomic,strong,readwrite)NSArray<UITextField *>* fieldS;

@property(nonatomic,strong,readwrite)NSArray<NSString *>* fielsStrs;

@property(nonatomic,strong,readwrite)NSDictionary* fielsStrDict;

@property(nonatomic,strong)NSArray *inputInfos;


@end


@implementation GS_MobileAlertView


- (instancetype)initWithTextFeildDict:(NSDictionary *)feildDict requestId:(NSString *)requestId {
    
    self = [super initWithFrame:CGRectMake(0, 0, GSScreen_Width, 200)];
    if (self) {
        _requestId = requestId;
        [self setupSelfView:feildDict];
    }
    return self;
}

//暂时取消此用法
//- (instancetype)init{
//
//    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
//    if (self) {
//
//        [self setupSelfView];
//    }
//    return self;
//}



- (void)setupSelfView:(NSDictionary*)feildDict{
    
    self.fieldS = [NSMutableArray array];
    self.fielsStrs = [NSMutableArray array];
    self.fielsStrDict = [NSMutableDictionary dictionary];
    
    // 弹框框宽
    NSInteger selfWidth = GSScreen_Width-66;
    
    
    if (_backView) {
        [_backView removeFromSuperview];
        [self removeFromSuperview];
        [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    // 1.透明遮罩
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    _backView = backView;
    
    // 2.自身弹框
//    self.frame = CGRectMake(0, 0, 307, 226);
//    self.center = CGPointMake(GSScreen_Width/2, GSScreen_Height/2);
    self.backgroundColor = [UIColor whiteColor];
    [self setupCornerRadius:8];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 动画
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0.8;
    [UIView animateWithDuration:0.35 delay:0.1 usingSpringWithDamping:0.7f initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0;
    } completion: nil];
    
    // title
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, selfWidth, 18)];
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
    self.alertLabel = alertLabel;
    
    //    UILabel *alertSubLabel = [[UILabel alloc] init];
    //    alertSubLabel.numberOfLines = 0;
    //    alertSubLabel.textColor = RGB(153, 153, 153, 1);
    //    alertSubLabel.font = [UIFont systemFontOfSize:15];
    //    [alertSubLabel sizeToFit];
    //    [self addSubview:alertSubLabel];
    //    self.alertSubLabel = alertSubLabel;
    //    [self.alertSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self.mas_centerX).offset(0);
    //        make.top.equalTo(self.alertLabel.mas_bottom).offset(0); // 如需开启副标题请开启这个值
    //        make.width.mas_equalTo(206);
    //    }];
    
    NSArray * textfields = [NSArray arrayWithArray:feildDict[@"inputInfos"]];
    
    // 输入框背景
    UIView *totalInputView = [[UIView alloc] initWithFrame:CGRectMake(25, 70, selfWidth-50, textfields.count * (42+16))];
    [self addSubview:totalInputView];
    
    // 动态创建输入框
    self.inputInfos = textfields;
    for (int i = 0; i < textfields.count; i++) {
        
        NSDictionary *inputInfos = textfields[i];
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, (44+16)*i, selfWidth-50, 44)];
        inputView.layer.borderWidth = 0.5;
        inputView.layer.borderColor = GS_Cell_Color.CGColor;
        [totalInputView addSubview:inputView];
        
        
        UITextField *textFie = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, inputView.frame.size.width-15-80, 44)];
        textFie.backgroundColor = [UIColor clearColor];
        textFie.placeholder = [[GS_DataTools filterStrNull: inputInfos[@"inputInfos"]] isEqualToString:@""] ? @"请输入验证码" :  inputInfos[@"inputInfos"];
        textFie.font = [UIFont systemFontOfSize:15];
        textFie.tag = 5000+i;
        textFie.delegate = self;
        [inputView addSubview:textFie];
        self.fieldS = [self.fieldS arrayByAddingObject:textFie];
        self.fielsStrs = [self.fielsStrs arrayByAddingObject:textFie.text];
        [self.fielsStrDict setValue:textFie.text forKey:inputInfos[@"inputId"]];
        
        if ([[GS_DataTools filterStrNull: inputInfos[@"inputType"]] isEqualToString:@"imgCode"]) {
            
            UIImageView *codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(inputView.frame.size.width - 80 - 3 , 3, 80, 38)];
            codeImg.backgroundColor = GS_Background_Color;
            
//            codeImg.image = [UIImage imageWithData:feildDict[@"imgBase64"]];
            
            [self downloadCodeImage:codeImg refresh:1];
            
            codeImg.userInteractionEnabled = YES;
            [inputView addSubview:codeImg];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refrenshCode:)];
            [codeImg addGestureRecognizer:tap];
        } else {
            textFie.frame = CGRectMake(15, 0, inputView.frame.size.width-15, 44);
        }
    }
    
    // 按钮
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(55, 70+ textfields.count * (44+16) + 10, selfWidth-110, 40)];
//    sureBtn.center = CGPointMake(308/2, 95 + textfields.count * (42+16) + 4);
    sureBtn.backgroundColor = GS_Main_Color;
    sureBtn.titleLabel.textColor = GS_RGB(255, 255, 255);
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    if (![[GS_DataTools filterStrNull:feildDict[@"btnText"]] isEqualToString:@""]){
        [sureBtn setTitle:feildDict[@"btnText"] forState:UIControlStateNormal];
    } else {
        [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setupCornerRadius:3];
    self.sureBtn = sureBtn;
    [self addSubview:sureBtn];
    
    // X
    UIButton *cancalBtn = [[UIButton alloc] initWithFrame:CGRectMake(selfWidth-22, 11, 11, 11)];
    [cancalBtn setImage:GSImage_Named(@"gs_closeTip") forState:UIControlStateNormal];
    [cancalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancalBtu = cancalBtn;
    [self addSubview:cancalBtn];
    
    
    self.frame = CGRectMake(33, 0, selfWidth, sureBtn.frame.origin.y + 40 + 22);
    self.center = CGPointMake(GSScreen_Width/2, GSScreen_Height/2 - 30);
}


// MARK: 刷新验证码
- (void)refrenshCode:(UITapGestureRecognizer *)sender{
    
    UIImageView *imageView = (UIImageView *)sender.view;
    [self downloadCodeImage:imageView refresh:YES];
}

// MARK: 3.图片验证码
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSDictionary *inputInfos = self.inputInfos[textField.tag-5000];
    [self.fielsStrDict setValue:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:inputInfos[@"inputId"]];
    
    return YES;
}

// 收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}



#pragma mark: - 优化
- (instancetype)initWithFormInfo:(NSDictionary *)formInfo andRequestId:(NSString *)requestId {
    
    self = [super init];
    
    if (self) {
        
        // 赋值
        _requestId = requestId;
        _formInfoDic = formInfo;
    }
    return self;
}

- (void)showInputAlertView {
    
    
}







@end

