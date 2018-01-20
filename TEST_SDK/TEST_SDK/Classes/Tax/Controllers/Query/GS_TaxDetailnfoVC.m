//
//  GS_TaxDetailnfoVC.m
//  BaseSDK
//
//  Created by 许墨 on 2017/12/13.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_TaxDetailnfoVC.h"
#import "GS_TaxLoginVC.h" // 登录
#import "GS_TaxAccountListVC.h" // 列表
#import "GS_TaxDetailModel.h" // model
#import "GS_TaxPayInfosModel.h" // 明细model
#import "GS_TaxDetailInfoCell.h" // cell
#import "GS_TaxRefreshVM.h" // 刷新


@interface GS_TaxDetailnfoVC () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_rowDataArray;
    NSMutableArray *_yearDataArray;
    NSArray *_titleArray;
    NSMutableDictionary *_isOpenDic;
    GS_TaxDetailModel *_dataModel;
    GS_TaxPayInfosModel *_dataDetailArrModel;
    UILabel *_topNameLabel; // 姓名
    UILabel *_topTimeLabel; // 时间
    NSString *_taxCount; // 总计纳税额
    NSString *_accountCityId; // 只供刷新失败重新登录使用
    NSString *_accountCityName;
}
@property (nonatomic, strong) UIView *tableHeaderView; // 头视图
@property (nonatomic, strong) UILabel *moneyTotalLabel; // 纳税总额
@property (nonatomic, strong) UIButton *uploadBtn; // 刷新按钮
@end

@implementation GS_TaxDetailnfoVC

// 重写返回
- (void)navigationPopBack {
//    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationTitle:@"纳税明细"];
    
    // 导航栏右按钮
    [self setupNVCRightBtn];
    
    // 创建视图
    [self setupSelfView];
    
    // 请求数据
    [self netWorkingForDetail];
}
// MARK: 导航栏右按钮
- (void)setupNVCRightBtn {
    
    UIButton *rightBtn = [[UIButton alloc] initWithMainTextColorText:@"账户列表"];
    [rightBtn sizeToFit];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addActionWithBlock:^{
        // 跳转账户列表
        GS_TaxAccountListVC *list = [[GS_TaxAccountListVC alloc] init];
        [self.navigationController pushViewController:list animated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)setupSelfView {
    
    _yearDataArray = [NSMutableArray array];
    _rowDataArray = [NSMutableArray array];
    _isOpenDic = [NSMutableDictionary dictionary];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height-GSSafeAreaTopHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = GS_Background_Color;
    _tableView.separatorColor = GS_Background_Color;
//    _tableView.rowHeight = 120;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = self.tableHeaderView;
    [self.view addSubview: _tableView];
}

//datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _yearDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    BOOL isOpen = [[_isOpenDic valueForKey:key] boolValue];
    if (!isOpen) {
        return 0;
    }
    _dataModel = _yearDataArray[section];
    
    return _dataModel.taxPayInfos.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //背景
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.tag = 70 + section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClock:)];
    [headerView addGestureRecognizer:tap];
    
    _dataModel = _yearDataArray[section];
    
    // 年
    UILabel *yearLabel = [[UILabel alloc] initWithTextColor:[UIColor darkTextColor] font:16 textAlignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"%@年", _dataModel.year]];
    yearLabel.frame = CGRectMake(15, 0, 60, 55);
    [headerView addSubview:yearLabel];
    // 纳税总额
    UILabel *totalMoneyLabel = [[UILabel alloc] initWithTextColor:[UIColor darkTextColor] font:16 textAlignment:NSTextAlignmentLeft text:[NSString stringWithFormat:@"%.2f元", _dataModel.totalTax.floatValue]];
    totalMoneyLabel.font = [UIFont boldSystemFontOfSize:16];
    totalMoneyLabel.frame = CGRectMake(100, 0, 200, 50);
    [headerView addSubview:totalMoneyLabel];
    //更多图标
    UIImageView *moreImage = [[UIImageView alloc] initWithImage:GSImage_Named(@"gs_taxdetaildown")];
    moreImage.frame = CGRectMake(GSScreen_Width-15-16, 20, 16, 9);
    [headerView addSubview:moreImage];
    moreImage.tag = 170 + section;
    
    NSString *key = [NSString stringWithFormat:@"%ld",section];
    BOOL isOpenTemp = [[_isOpenDic valueForKey:key] boolValue];
    
    if (isOpenTemp) {
        moreImage.image = GSImage_Named(@"gs_taxdetailup");
    } else {
        moreImage.image = GSImage_Named(@"gs_taxdetaildown");
    }
    
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = GS_Background_Color;
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    _dataModel = _yearDataArray[indexPath.section];
    _dataDetailArrModel = _dataModel.taxPayInfos[_dataModel.taxPayInfos.count-1 - indexPath.row];
    
    if ([[GS_DataTools filterStrNull: _dataDetailArrModel.payPerson] isEqualToString:@""]) {
        return 95;
    }
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GS_TaxDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[GS_TaxDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    _dataModel = _yearDataArray[indexPath.section];
    _dataDetailArrModel = _dataModel.taxPayInfos[_dataModel.taxPayInfos.count-1 - indexPath.row];
    
    [cell setupTime:_dataDetailArrModel.paymentTime money:_dataDetailArrModel.amountPaid type:_dataDetailArrModel.incomeType person:_dataDetailArrModel.payPerson];
    
    return cell;
}

//MARK: 获取数据
- (void)netWorkingForDetail {
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    requestDic[@"dIQsSGtNUOcCaNoITaZiROtHUa"] = _accountId;
    
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_TaxAllDetail Parameters:requestDic successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSDictionary *dic = responseObject;
        [GS_ProgressHUD showHUDView:NO];
        
        if ([dic[@"code"] isEqualToString:@"0000"]) {
            
            // 删除数据
            [_yearDataArray removeAllObjects];
            
            // 倒序
            NSArray *arr = dic[@"taxDetails"];
            NSArray *reverseArr =(NSMutableArray *)[[arr reverseObjectEnumerator] allObjects];
           
            for (NSDictionary *dic in reverseArr) {
                _dataModel = [GS_TaxDetailModel yy_modelWithDictionary:dic];
                [_yearDataArray addObject:_dataModel];
            }
            // 头部三个数据
            _taxCount = [NSString stringWithFormat:@"%@", dic[@"taxCount"]];
            self.moneyTotalLabel.text = _taxCount;
            
            _topNameLabel.text = [NSString stringWithFormat:@"姓名: %@    缴纳地区: %@", [GS_DataTools filterStrNull: dic[@"taxPerson"]], [GS_DataTools filterStrNull: dic[@"taxCity"]]];
            _topTimeLabel.text = [NSString stringWithFormat:@"最近更新: %@", [GS_DataTools filterStrNull: dic[@"updateTime"]]];
            // 存账户city
            _accountCityId = [NSString stringWithFormat:@"%@", dic[@"taxCityId"]];
            _accountCityName = [NSString stringWithFormat:@"%@", dic[@"taxCity"]];
            
            [_tableView reloadData];
            
        } else if ([responseObject[@"code"] isEqualToString: @"1000"]) {
            
            [GS_ProgressHUD showHUDView:self.view states:NO title:@"" content:@"请重新登录" time:2.0  andCodes:^{
                
                GS_TaxLoginVC *query = [[GS_TaxLoginVC alloc] init]; // 重新登录
                [self.navigationController pushViewController:query animated:YES];
            }];
        } else {
            [GS_ProgressHUD showHUDView:self.view states:NO title:@"" content:[GS_DataTools filterStrNull: responseObject[@"message"]] time:2.0  andCodes:nil];
        }
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
    }];
}

// 展开收起
- (void)closeClock:(UITapGestureRecognizer *)tap {
    
    NSString *key = [NSString stringWithFormat:@"%d",(int)tap.view.tag-70];
    BOOL isOpenTemp = [[_isOpenDic valueForKey:key] boolValue];
    NSString *isOpen = isOpenTemp ? @"0" : @"1";
    [_isOpenDic setValue:isOpen forKey:key];
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:key.integerValue];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark: - ------ setter getter
- (UIView *)tableHeaderView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 160)];
    backView.backgroundColor = GS_Background_Color;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, GSScreen_Width, 140)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whiteView];
    // 累计
    UILabel *topTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, 16)];
    topTotalLabel.center = CGPointMake(GSScreen_Width/2, 25);
    topTotalLabel.text = @"累计纳税总额(元)";
    topTotalLabel.textColor = [UIColor darkGrayColor];
    topTotalLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:topTotalLabel];
    
    // 钱
    UILabel *moneyTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
    moneyTotalLabel.center = CGPointMake(GSScreen_Width/2 - 20, 60);
    moneyTotalLabel.textColor = [UIColor darkGrayColor];
    moneyTotalLabel.font = [UIFont systemFontOfSize:27];
    moneyTotalLabel.text = @"0.00";
    moneyTotalLabel.textAlignment = NSTextAlignmentRight;
//    [moneyTotalLabel sizeToFit];
    [whiteView addSubview:moneyTotalLabel];
    self.moneyTotalLabel = moneyTotalLabel;
    
    // 刷新
    UIButton *uploadBtn = [[UIButton alloc] init];
    [uploadBtn setImage:[GSImage_Named(@"gs_taxrefrensh") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    uploadBtn.tintColor = GS_Main_Color;
    uploadBtn.frame = CGRectMake(0, 0, 44, 44);
    uploadBtn.center = CGPointMake(moneyTotalLabel.center.x + 1/2 + 22, 60);
    [whiteView addSubview:uploadBtn];
    self.uploadBtn = uploadBtn;
    [uploadBtn addActionWithBlock:^{
        // 刷新登录
        GS_TaxRefreshVM *refresh = [[GS_TaxRefreshVM alloc] init];
        refresh.superVC = self;
        refresh.accountId = _accountId;
        refresh.accountCityId = _accountCityId;
        refresh.accountCityName = _accountCityName;
        
        [refresh startRefreshTaxDataSuccessBlock:^(NSDictionary *dict) {
            // ** 刷新成功后的dict数据不一样 不用 **
            
            // 刷新成功后 刷新本页数据
            [self netWorkingForDetail];
        }];
    }];
    
    // 姓名
    UILabel *topNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 88, GSScreen_Width, 12)];
    topNameLabel.text = @"姓名: 成龙    缴纳地区: 杭州市";
    topNameLabel.textAlignment = NSTextAlignmentCenter;
    topNameLabel.textColor = [UIColor lightGrayColor];
    topNameLabel.font = [UIFont systemFontOfSize:11];
    [whiteView addSubview:topNameLabel];
    _topNameLabel = topNameLabel;
    
    // 最近更新
    UILabel *topTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 112, GSScreen_Width, 12)];
    topTimeLabel.text = @"最近更新: 2017.12.12";
    topTimeLabel.textAlignment = NSTextAlignmentCenter;
    topTimeLabel.textColor = [UIColor lightGrayColor];
    topTimeLabel.font = [UIFont systemFontOfSize:11];
    [whiteView addSubview:topTimeLabel];
    _topTimeLabel = topTimeLabel;
    
    return backView;
}


- (UILabel *)moneyTotalLabel {

    // 宽度
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:27]};  //指定字号
    CGRect rect = [_taxCount boundingRectWithSize:CGSizeMake(0, 40)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    CGFloat moneyWidth = rect.size.width;
    
    
    // 刷新
    _moneyTotalLabel.frame = CGRectMake(0, 0, moneyWidth, 40);
    _moneyTotalLabel.center = CGPointMake(GSScreen_Width/2 - 20, 60);
    self.uploadBtn.center = CGPointMake(_moneyTotalLabel.center.x + moneyWidth/2 + 22, 60);

    return _moneyTotalLabel;
}



@end
