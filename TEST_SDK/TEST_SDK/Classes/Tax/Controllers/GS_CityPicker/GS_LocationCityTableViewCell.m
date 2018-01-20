//
//  GS_LocationCityTableViewCell.m
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "GS_LocationCityTableViewCell.h"

@implementation GS_LocationCityTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *cityicon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 12, 15)];
        cityicon.image = GSImage_Named(@"ios-loc");
        [self.contentView addSubview:cityicon];
        
        self.currentCity = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, 200, 50)];
        self.currentCity.backgroundColor = [UIColor whiteColor];
        self.currentCity.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.currentCity.layer setCornerRadius:5];
        [self.currentCity addTarget:self action:@selector(buttonTitle:) forControlEvents:UIControlEventTouchUpInside];
        self.currentCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.currentCity setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.currentCity];
        
//        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-25-15, 14, 12, 15)];
//        self.refreshCity = [[UIButton alloc] init];
//        [self.refreshCity setImage:GSImage_Named(@"ios-ref") forState:UIControlStateNormal];
//        [self.contentView addSubview:self.refreshCity];
//        [self.refreshCity mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView.mas_centerY);
//            make.right.equalTo(self.contentView.mas_right).offset(-0);
//            make.width.height.mas_equalTo(40);
//        }];
    }
    return self;
}

- (void)buttonTitle:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickGS_LocationCityTableViewCell:)]) {
        [self.delegate clickGS_LocationCityTableViewCell:button];
    }else
    {
        NSLog(@"定位当前城市代理不响应");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
