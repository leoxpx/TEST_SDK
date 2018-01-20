//
//  GS_CityPickerVC.h
//  XCityPicker
//
//  Created by X on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "GS_ParentViewController.h"

typedef NS_ENUM(NSInteger,SectionNumber) {
    LocationSection,
//    HotCitySection,
    CitySection
};

@interface GS_CityPickerVC : GS_ParentViewController

/**
 *  选择的城市回调
 */
@property (nonatomic,copy) void (^selectCityNameAndId)(NSString *cityName, NSString *cityId);

@end
