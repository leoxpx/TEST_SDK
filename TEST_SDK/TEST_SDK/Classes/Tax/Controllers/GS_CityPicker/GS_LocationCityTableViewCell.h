//
//  GS_LocationCityTableViewCell.h
//  XPXCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GS_LocationCityTableViewCellDelegate <NSObject>
/**
 *  点击定位城市
 *
 *  @param button 点击button
 */
- (void)clickGS_LocationCityTableViewCell:(UIButton *)button;
@end

@interface GS_LocationCityTableViewCell : UITableViewCell
@property(nonatomic,assign)id<GS_LocationCityTableViewCellDelegate>delegate;
/**
 *  当前定位城市
 */
@property(nonatomic,retain)UIButton *currentCity;


/**
   刷新城市按钮
 */
@property(nonatomic,strong)UIButton *refreshCity;
@end
