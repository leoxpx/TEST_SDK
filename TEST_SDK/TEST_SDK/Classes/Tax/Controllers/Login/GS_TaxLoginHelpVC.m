//
//  GS_TaxLoginHelpVC.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/20.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxLoginHelpVC.h"
#import "GS_TaxLoginHelpModel.h" // model
#import "GS_UIWebViewPublicVC.h" // 按钮跳转

@interface GS_TaxLoginHelpVC () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    GS_TaxLoginHelpModel *_model;
    GSTaxLoginHelpButtonModel *_btnModel;
}
@end

@implementation GS_TaxLoginHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationTitle:@"如何获取账户"];
    
    // 解析数据
    _dataArray = [NSMutableArray array];
    for (NSDictionary *dic in _data[@"siteHelpSteps"]) {
        _model = [GS_TaxLoginHelpModel yy_modelWithDictionary:dic];
        [_dataArray addObject:_model];
    }
    
    // 创建视图
    [self setupSelfViews];
}

- (void)setupSelfViews {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = GS_Background_Color;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 80.0f;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tableView];
    _tableView = tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
// cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// 头高 控制顶部无按钮或有两个按钮
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    _model = _dataArray[section];
    if (_model.siteLoginHelpBtns.count < 1) {
        return 0;
    }
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _model = _dataArray[section];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 60)];
    backView.backgroundColor = GS_Background_Color;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, GSScreen_Width, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whiteView];
    [UIView setupCellLineTo:whiteView frame:CGRectMake(0, 49, GSScreen_Width, 0.5)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, GSScreen_Width-30, 50)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:titleLabel];
    titleLabel.text = _model.title;
    
    return backView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 60)];
    backView.backgroundColor = [UIColor whiteColor];
    
    _model = _dataArray[section];
    for (int i = 0; i < _model.siteLoginHelpBtns.count; i++) {
        
        _btnModel = _model.siteLoginHelpBtns[i];
        // 2个: 0.33,0.66                  1/3, 1/1.5
        // 3个: 0.25,0.5,0.75              1/4, 1/2, 1/1.33
        // 4个: 0.125 0.375 0.625 0.875    1/8, 1/2.66, 1/1.6, 1/1.14  1 20,2 10,3 5
        NSInteger weight = (GSScreen_Width-40)/_model.siteLoginHelpBtns.count;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (weight+20-_model.siteLoginHelpBtns.count*3)*i, 0, _model.siteLoginHelpBtns.count > 1 ? weight-20 : (GSScreen_Width-40)/2-20, 28)];
        [btn setTitle:_btnModel.btnText forState:UIControlStateNormal];
        [btn setTitleColor:GS_Main_Color forState:UIControlStateNormal];
        [btn setupCornerRadius:2];
        [btn setupBorderRadius:0.5 color:GS_Main_Color];
        btn.tag = 100 + section*10 + i;
        [backView addSubview:btn];
        [btn addActionWithBlock:^{
            
            NSInteger sec = (btn.tag-100)/10;
            NSInteger cou = btn.tag % 10;
            
            _model = _dataArray[sec];
            _btnModel = _model.siteLoginHelpBtns[cou];
            
            if ([_btnModel.btnType isEqualToString:@"url"]) {
                GS_UIWebViewPublicVC *web = [[GS_UIWebViewPublicVC alloc] init];
                web.links = _btnModel.btnValue;
                [self.navigationController pushViewController:web animated:YES];
            } else if ([_btnModel.btnType isEqualToString:@"phone"]) {
                // @available(iOS 10.0, *)
                if ([UIDevice currentDevice].systemVersion.floatValue > 10.0) {
                    /// 大于等于10.0系统使用此openURL方法
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _btnModel.btnValue] options:@{} completionHandler:nil];
                    } else {
                        // Fallback on earlier versions
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _btnModel.btnValue]];
                    }
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _btnModel.btnValue]];
                }
            } else if ([_btnModel.btnType isEqualToString:@"qq"]) {
                //QQ
                NSURL *url = [NSURL URLWithString:@"mqq://"];
                if([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url];
                } else {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [controller addAction:act1];
                    [self presentViewController:controller animated:YES completion:nil];
                }
            } else if ([_btnModel.btnType isEqualToString:@"weixin"]) {
                //微信
                NSURL *url = [NSURL URLWithString:@"weixin://"];
                if([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url];
                } else {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有安装手机微信，请安装手机微信后重试。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [controller addAction:act1];
                    [self presentViewController:controller animated:YES completion:nil];
                }
            }
        }];
    }
    
    return backView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    _model = _dataArray[indexPath.section];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = _model.text;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
