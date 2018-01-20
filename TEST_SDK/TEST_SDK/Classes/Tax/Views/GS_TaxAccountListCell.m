//
//  GS_TaxAccountListCell.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxAccountListCell.h"

@implementation GS_TaxAccountListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    self.consoleView = [[UIView alloc] initWithFrame:CGRectMake(GSScreen_Width, 0, GSScreen_Width, 133)];
    // ****这里的高度要和你在vc里写的table的行高要保持一致
    self.consoleView.backgroundColor = GS_Background_Color;
    [self.contentView addSubview:self.consoleView];
    
    UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.backgroundColor = GS_RGB(207, 207, 207);
    delBtn.frame = CGRectMake(0, 10, 65, 123);
    [delBtn setImage:GSImage_Named(@"gs_trash") forState:UIControlStateNormal];
//    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.consoleView addSubview:delBtn];
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
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 133)];
    backView.backgroundColor = GS_Background_Color;
    [self.contentView addSubview:backView];
    
    // 背景白
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, GSScreen_Width, 123)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whiteView];
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:nameLabel];
    _nameLabel = nameLabel;
    // 图标
    UIImageView *locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9.5, 12.5)];
    locationImage.center = CGPointMake(100, nameLabel.center.y);
    locationImage.image = GSImage_Named(@"ios-loc");
    [whiteView addSubview:locationImage];
    // 地点
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, 100, 44)];
    locationLabel.textAlignment = NSTextAlignmentLeft;
    locationLabel.textColor = [UIColor lightGrayColor];
    locationLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:locationLabel];
    _locationLabel = locationLabel;
    // 线
    [UIView setupCellLineTo:whiteView frame:CGRectMake(15, 44, GSScreen_Width-30, 0.5)];
    // 纳税总额
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 60, 13)];
    totalLabel.text = @"纳税总额";
    totalLabel.textAlignment = NSTextAlignmentLeft;
    totalLabel.textColor = [UIColor darkGrayColor];
    totalLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:totalLabel];
    // 金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 85, 150, 25)];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    moneyLabel.textColor = [UIColor darkGrayColor];
    moneyLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    
    // 线
    [UIView setupCellLineTo:whiteView frame:CGRectMake(GSScreen_Width/2-15, 62, 0.5, 45)];
    // 纳税状态提示
    UILabel *stateTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(GSScreen_Width/2+22, totalLabel.frame.origin.y, 60, 13)];
    stateTipLabel.text = @"纳税状态:";
    stateTipLabel.textAlignment = NSTextAlignmentLeft;
    stateTipLabel.textColor = [UIColor darkGrayColor];
    stateTipLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:stateTipLabel];
    // 纳税状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(GSScreen_Width/2+22+60+5, totalLabel.frame.origin.y, 70, 13)];
    stateLabel.textAlignment = NSTextAlignmentLeft;
    stateLabel.textColor = [UIColor blackColor];
    stateLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:stateLabel];
    _stateLabel = stateLabel;
    // 时间提示
    UILabel *timeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateTipLabel.frame.origin.x, 95, 60, 13)];
    timeTipLabel.text = @"更新时间:";
    timeTipLabel.textAlignment = NSTextAlignmentLeft;
    timeTipLabel.textColor = [UIColor darkGrayColor];
    timeTipLabel.font = [UIFont systemFontOfSize:13];
    [whiteView addSubview:timeTipLabel];
    // 时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateLabel.frame.origin.x, 95, 70, 13)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    [whiteView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
}

- (void)setupNmae:(NSString *)name city:(NSString *)city money:(NSString *)money state:(NSString *)state time:(NSString *)time {
    
    self.nameLabel.text = name;
    self.locationLabel.text = city;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", money]];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, money.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:NSMakeRange(0, money.length)];
    self.moneyLabel.attributedText = attStr;
    
    self.stateLabel.text = state;
    self.timeLabel.text = time;
}


@end
