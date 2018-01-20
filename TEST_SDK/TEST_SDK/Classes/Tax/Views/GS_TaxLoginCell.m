//
//  GS_TaxLoginCell.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/12.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginCell.h"

@implementation GS_TaxLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupCellView];
    }
    return self;
}

- (void)setupCellView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithTextColor:[UIColor darkTextColor] font:15 textAlignment:NSTextAlignmentLeft text:@""];
    titleLabel.frame = CGRectMake(15, 0, 80, 50);
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:titleLabel];
    _titleLabels = titleLabel;
    
    UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(15+80+15, 0, GSScreen_Width - (15+80+15) - 30, 50)];
    input.font = [UIFont systemFontOfSize:14];
    input.delegate = self;
    [backView addSubview:input];
    _inputText = input;
    
    UIImageView *imageCode = [[UIImageView alloc] initWithFrame:CGRectMake(GSScreen_Width-15-80, 8, 80, 50-8-8)];
    imageCode.backgroundColor = [UIColor whiteColor];
    imageCode.userInteractionEnabled = YES;
    [backView addSubview:imageCode];
    _codeImgView = imageCode;
    imageCode.hidden = YES;
    imageCode.image = GSImage_Named(@"gs_imageCodeFaild");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCodeImage)];
    [imageCode addGestureRecognizer:tap];
    
    
    UIImage *imag = GSImage_Named(@"gs_moredown");
    _moreIcon = [[UIImageView alloc] initWithImage:imag];
    _moreIcon.frame = CGRectMake(GSScreen_Width-15-imag.size.width, (50-imag.size.height)/2, imag.size.width, imag.size.height);
    [backView addSubview:_moreIcon];
    self.moreIcon.hidden = YES;
    
//    [UIView setupCellLineTo:backView frame:CGRectMake(0, 49.5, GSScreen_Width, 0.5)];
}

- (void)setupTitlte:(NSString *)title inputText:(NSString *)input inputPlaceholder:(NSString *)placeholder inputAction:(InputAction)inputAction selectAction:(InputAction)selectAction {
    
    _titleLabels.text = title;
    _inputText.text = input;
    _inputText.placeholder = placeholder;
    _codeImgView.hidden = YES;
    _inputText.secureTextEntry = NO;
    
    if (inputAction) {

        _inputAction = inputAction;
        self.moreIcon.hidden = YES;
//        [self.inputText addTarget:self action:@selector(inputClick) forControlEvents:UIControlEventEditingChanged];
    } else if (selectAction) {

        _selectAction = selectAction;
        self.moreIcon.hidden = NO;
//        [self.inputText addTarget:self action:@selector(selectedClick) forControlEvents:UIControlEventEditingDidBegin];
    } else {
        self.moreIcon.hidden = YES;
    }
}
- (void)inputClick {
    self.inputAction();
}
- (void)selectedClick {
    self.selectAction();
}
- (void)refreshCodeImage {
    
    if (self.codeImgViewRefrenshAction) {
        self.codeImgViewRefrenshAction();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (self.inputAction) {
        [self inputClick];
    } else if (self.selectAction) {
        // 上一个输入框需取消
        [self.superview endEditing:YES];
        
        [self selectedClick];
        
        return NO;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.inputAction) {
        [self inputClick];
    } else if (self.selectAction) {
        // 上一个输入框需取消
        [self.superview endEditing:YES];
        
        [self selectedClick];
    }
}

@end
