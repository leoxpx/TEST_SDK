//
//  GS_TaxLoginHelpModel.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/20.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GS_TaxLoginHelpModel : NSObject

@property (nonatomic, strong) NSArray *siteLoginHelpBtns;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;

@end

@interface GSTaxLoginHelpButtonModel : NSObject

@property (nonatomic, strong) NSString *btnType;
@property (nonatomic, strong) NSString *btnIcon;
@property (nonatomic, strong) NSString *btnText;
@property (nonatomic, strong) NSString *btnTitle;
@property (nonatomic, strong) NSString *btnValue;

@end
