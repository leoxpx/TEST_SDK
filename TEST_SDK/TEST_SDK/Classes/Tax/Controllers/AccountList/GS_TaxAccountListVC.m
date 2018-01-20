//
//  GS_TaxAccountListVCViewController.m
//  BaseSDK
//
//  Created by xinwang on 2017/12/14.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxAccountListVC.h"
#import "GS_TaxLoginVC.h" // 登录
#import "GS_TaxDetailnfoVC.h" // 详情
#import "GS_TaxAccountListCell.h" // cell
#import "GS_TaxAccountListModel.h" // model

@interface GS_TaxAccountListVC () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    GS_TaxAccountListModel *_model;
}
@property (nonatomic, strong) UIView *tableViewFooterView;
@end

@implementation GS_TaxAccountListVC

- (void)navigationPopBack {
    if (_dataArray.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationTitle:@"账户列表"];
    
    // 创建视图
    [self setupSelfViews];
    
    _dataArray = [NSMutableArray array];
    
    // 数据
    [self netWorkingForList];
    
}
- (void)setupSelfViews {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height-GSSafeAreaTopHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = GS_Background_Color;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 133;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.bounces = NO;
    [self.view addSubview:tableView];
    tableView.tableFooterView = self.tableViewFooterView;
    _tableView = tableView;
}
// cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
// 头高 控制顶部无按钮或有两个按钮
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section { return nil; }
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { return nil; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GS_TaxAccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[GS_TaxAccountListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    _model = _dataArray[indexPath.row];
    
    [cell setupNmae:_model.accountName city:_model.accountCity money:_model.amount state:_model.accountState time:_model.updateTime];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _model = _dataArray[indexPath.row];
    
    GS_TaxDetailnfoVC *detail = [[GS_TaxDetailnfoVC alloc] init];
    detail.accountId = _model.accountId;
    [self.navigationController pushViewController:detail animated:YES];
}

//编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//删除指定行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 找出模型删除
    _model = _dataArray[indexPath.row];
    [self netWorkingForDelegateAccount];
    
    // 假删除
    [_dataArray removeObjectAtIndex:indexPath.row];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft]; // 删除对应数据的cell
}


#pragma mark:- -------------------- 接口请求 --------------
- (void)netWorkingForList {
    
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_TaxAccountList Parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        NSDictionary *dic = responseObject;
        
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            
            [_dataArray removeAllObjects];
            if ([GS_DataTools isArrayNotDict: dic[@"accountInfoList"]]) {
                NSArray *arr = dic[@"accountInfoList"];
                // 有数据
                for (NSDictionary *dicTemp in arr) {
                    _model = [GS_TaxAccountListModel yy_modelWithDictionary:dicTemp];
                    [_dataArray addObject:_model];
                }
            } else {
                // 无数据
                [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:@"未知错误" time:2.0 andCodes:nil];
            }
        } else {
            [GS_ProgressHUD showHUDView:nil states:NO title:@"" content:dic[@"message"] time:2.0 andCodes:nil];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
    }];
}

// 删除请求
-(void)netWorkingForDelegateAccount {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"dIQsSGtNUOcCaNoITaZiROtHUa"] = _model.accountId;
    
    [GS_NetWorking POSTWithURLString:URL_TaxAccountDelete Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            
            [GS_ProgressHUD showHUDView:self.view states:YES title:@"" content:@"删除成功" time:2.0 andCodes:^{
                // 刷新数据
                [self netWorkingForList];
            }];
            
        } else {
            [GS_ProgressHUD showHUDView:self.view states:NO title:@"" content:dic[@"message"] time:2.0 andCodes:nil];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:self.view states:NO title:@"" content:@"网络连接失败,请稍后重试" time:2.0 andCodes:nil];
    }];
}

#pragma mark: - ------ setter getter
- (UIView *)tableViewFooterView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 90+30)];
    
    UIButton *addBtn = [[UIButton alloc] initWithMainBackgroundColorText:@"添加账户"];
    addBtn.frame =CGRectMake(15, 40, GSScreen_Width-30, 50);
    [backView addSubview:addBtn];
    WeakSelf(weakSelf);
    [addBtn addActionWithBlock:^{
        
        GS_TaxLoginVC *login = [[GS_TaxLoginVC alloc] init];
        [weakSelf.navigationController pushViewController:login animated:YES];
    }];
    
    return backView;
}



@end
