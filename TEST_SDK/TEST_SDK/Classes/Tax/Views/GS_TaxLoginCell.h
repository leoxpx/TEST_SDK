//
//  GS_TaxLoginCell.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/12.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputAction)(void);

@interface GS_TaxLoginCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabels;
@property (nonatomic, strong) UITextField *inputText;
@property (nonatomic, strong) UIImageView *codeImgView;

@property (nonatomic, strong, readonly) UIImageView *moreIcon;
@property (nonatomic, copy, readonly) InputAction inputAction;
@property (nonatomic, copy, readonly) InputAction selectAction;
@property (nonatomic, copy) InputAction codeImgViewRefrenshAction;

- (void)setupTitlte:(NSString *)title inputText:(NSString *)input inputPlaceholder:(NSString *)placeholder inputAction:(InputAction)inputAction selectAction:(InputAction)selectAction;

@end
