//
//  GS_TaxDetailInfoCell.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_TaxDetailInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *personedLabel;

@property (nonatomic, strong) UIView *whiteView; // 隐藏
@property (nonatomic, strong) UILabel *personedTipLabel;

- (void)setupTime:(NSString *)time money:(NSString *)money type:(NSString *)type person:(NSString *)person;

@end
