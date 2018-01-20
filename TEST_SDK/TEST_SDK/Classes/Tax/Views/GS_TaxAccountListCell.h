//
//  GS_TaxAccountListCell.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GS_TaxAccountListCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView * consoleView; // 编辑模式背景

- (void)setupNmae:(NSString *)name city:(NSString *)city money:(NSString *)money state:(NSString *)state time:(NSString *)time;

@end
