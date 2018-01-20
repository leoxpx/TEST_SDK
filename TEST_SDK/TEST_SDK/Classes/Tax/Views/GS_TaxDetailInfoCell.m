//
//  GS_TaxDetailInfoCell.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxDetailInfoCell.h"

@implementation GS_TaxDetailInfoCell

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
    
    // 背景
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 120)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteView];
    _whiteView = whiteView;
    
    // 所属期
    UILabel *timeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 65, 12)];
    timeTipLabel.text = @"纳税所属期:";
    timeTipLabel.textAlignment = NSTextAlignmentLeft;
    timeTipLabel.textColor = [UIColor darkGrayColor];
    timeTipLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:timeTipLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 100, 12)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    // 税额
    UILabel *moneyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 65, 12)];
    moneyTipLabel.text = @"实缴税额:";
    moneyTipLabel.textAlignment = NSTextAlignmentLeft;
    moneyTipLabel.textColor = [UIColor darkGrayColor];
    moneyTipLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:moneyTipLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 100, 12)];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.textColor = [UIColor darkGrayColor];
    moneyLabel.font = [UIFont boldSystemFontOfSize: 12];
    [whiteView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    // 项目
    UILabel *projectTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 68, 65, 12)];
    projectTipLabel.text = @"纳税项目:";
    projectTipLabel.textAlignment = NSTextAlignmentLeft;
    projectTipLabel.textColor = [UIColor darkGrayColor];
    projectTipLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:projectTipLabel];
    
    UILabel *projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 68, 200, 12)];
    projectLabel.textAlignment = NSTextAlignmentLeft;
    projectLabel.textColor = [UIColor darkGrayColor];
    projectLabel.font = [UIFont systemFontOfSize: 12];
    [whiteView addSubview:projectLabel];
    _typeLabel = projectLabel;
    
    // 义务人
    UILabel *personedTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 96, 65, 12)];
    personedTipLabel.text = @"扣缴义务人:";
    personedTipLabel.textAlignment = NSTextAlignmentLeft;
    personedTipLabel.textColor = [UIColor darkGrayColor];
    personedTipLabel.font = [UIFont systemFontOfSize:12];
    [whiteView addSubview:personedTipLabel];
    _personedTipLabel = personedTipLabel;
    
    UILabel *personedLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 96, 200, 12)];
    personedLabel.textAlignment = NSTextAlignmentLeft;
    personedLabel.textColor = [UIColor darkGrayColor];
    personedLabel.font = [UIFont systemFontOfSize: 12];
    [whiteView addSubview:personedLabel];
    _personedLabel = personedLabel;
}

- (void)setupTime:(NSString *)time money:(NSString *)money type:(NSString *)type person:(NSString *)person {
    
    self.timeLabel.text = time;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元", money.floatValue];
    self.typeLabel.text = type;
    
    if ([[GS_DataTools filterStrNull: person] isEqualToString:@""]) {
        self.whiteView.frame = CGRectMake(0, 0, GSScreen_Width, 95);
        self.personedTipLabel.hidden = YES;
        self.personedLabel.hidden = YES;
    } else {
        self.whiteView.frame = CGRectMake(0, 0, GSScreen_Width, 120);
        self.personedTipLabel.hidden = NO;
        self.personedLabel.hidden = NO;
        self.personedLabel.text = person;
    }
}

@end
