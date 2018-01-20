//
//  GS_CityPickerVC.m
//  XCityPicker
//
//  Created by XPX on 2017/3/9.
//  Copyright © 2017年 XPX. All rights reserved.
//

#import "GS_CityPickerVC.h"
#import "GS_HotCityTableViewCell.h"
#import "GS_LocationCityTableViewCell.h"

@interface GS_CityPickerVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating,GS_LocationCityTableViewCellDelegate,GS_HotCityTableViewCellDelegate> {
    
    UILabel *charLabel;
}
/**
 *  定位城市名称
 */
@property (nonatomic,copy) NSString *locationCity;

/**
 *  定位城市ID
 */
@property (nonatomic,copy) NSString *locationCityId;

@property (nonatomic,retain) UISearchController  *searchController;
@property (nonatomic,strong) NSMutableArray      *searchArray;

@property (nonatomic,retain) UITableView  *cityTableView;
@property (nonatomic,copy)   NSArray      *allCityArrTemp;
@property (nonatomic,copy)   NSArray      *allCityArr;
@property (nonatomic,copy)   NSArray      *hotCityArr;
@property (nonatomic,copy)   NSArray      *indexList;
@property (nonatomic,retain) UIButton     *locationCellBtn;

@end

@implementation GS_CityPickerVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.searchController.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationTitle:@"城市选择"];
     
    self.locationCity = [GS_ShareSingle shareSingle].locationCityName;
    self.locationCityId = [GS_ShareSingle shareSingle].locationCityId;
    
    [self getData]; // 获取数据
    [self creatView];
    
    // 定位 不用单独调, 授权有返回
//    [self netWorkingForGps];
}

#pragma mark - 加载数据
- (void)getData {
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    NSString *plistPath = [NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT,@"/citylist"];
    NSData * data = [NSData dataWithContentsOfFile:plistPath];
    NSDictionary *cityDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
//     如果没有下载
    if (cityDict == nil) {
        plistPath = [GS_Bundle pathForResource:@"citytest" ofType:@"plist"];
        cityDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    
    // 取到所有城市
    NSArray *allCityArrTemp = cityDict[@"allcity"]; //测试 hotcity
    self.allCityArrTemp = allCityArrTemp;
    // 对所有城市升序排序
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"pinyin" ascending:YES];//yes升序排列，no,降序排列
    NSArray *myary = [allCityArrTemp sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd1]];//注意这里的ary进行排序后会生产一个新的数组指针myary，ary还是保持不变的。
    
    // 对所有城市按字母分组
    NSString       *lastKey    = @"";
    NSMutableArray *ABCArr     = [NSMutableArray array];
    NSMutableArray *ABCArrTemp = [NSMutableArray array];
    
    // 索引
    NSMutableArray *list       = [[NSMutableArray alloc]init];
    [list addObject:@"定"];
//    [list addObject:@"热"];
    
    NSMutableArray *myArrTemp = [NSMutableArray arrayWithArray:myary];
    NSDictionary *dicTemp = @{ @"pinyin" : @"@" }; // 会少一组故自己加一组占位
    [myArrTemp addObject:dicTemp];
    for (NSDictionary *dic in myArrTemp) {
        if ([[dic[@"pinyin"] substringToIndex:1] isEqualToString:lastKey]) {
            [ABCArrTemp addObject:dic];
        } else {
            if (ABCArrTemp.count > 0) {
            //
            [list addObject:[lastKey uppercaseString]];
            
            // 首字母不同时添加到分组数组
            [ABCArr addObject:ABCArrTemp];
            }
            
            ABCArrTemp = [NSMutableArray array];
            
            // 已不同, 提前添加
            [ABCArrTemp addObject:dic];
        }
        // 每次取第一个字母
        lastKey = [dic[@"pinyin"] substringToIndex:1];
    }
    // 排序后的数组包含数组包含字典
    if (ABCArr.count == 1) {
        [ABCArr removeAllObjects]; // 只有占位没有数据要清空
    }
    self.allCityArr = [ABCArr copy];
    self.indexList  = [list copy];
    
    
    // 热门城市
//    NSArray *hotCityArrTemp = cityDict[@"hotcity"];
//    self.hotCityArr = [hotCityArrTemp copy];
}
#pragma mark - 初始化视图
- (void)creatView {
    
    // tableView
    self.cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GSScreen_Width, GSScreen_Height-GSSafeAreaTopHeight-GSSafeAreaBottomHeight)];
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    
    [self.view addSubview:self.cityTableView];
    // 索引字体颜色
    self.cityTableView.sectionIndexColor = GS_Main_Color;
    // 索引背景颜色
    self.cityTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    // searchController
    self.searchArray = [NSMutableArray array];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // 背景不可点
//    self.searchController.hidesNavigationBarDuringPresentation = NO; // 搜索中不隐藏导航栏
    self.searchController.searchBar.placeholder = @"请输入要搜索的城市";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, GSDevice_iPhoneX ? 56 : 44); //默认56
    self.cityTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES; ////
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }
    return self.indexList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchArray.count;
    }
    if (section == LocationSection) {
        return 1;
    }
//    else if (section == HotCitySection) {
//        return 1;
//    }
    else if (self.allCityArr.count > 0) {
        NSArray *charaArray = self.allCityArr[section-1];
        return charaArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.searchArray[indexPath.row][@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
    if (indexPath.section == LocationSection) {
        static NSString *locationIdentifier = @"LocationSection";
        GS_LocationCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier];
        if (!cell) { 
            cell = [[GS_LocationCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        [cell.currentCity setTitle:self.locationCity forState:UIControlStateNormal];
//        [cell.refreshCity addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside]; // 无刷新功能
        self.locationCellBtn = cell.currentCity;
        
        return cell;
    }
//    else if (indexPath.section == HotCitySection) {
//        static NSString *hotIdentifier = @"HotCitySection";
//        GS_HotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotIdentifier];
//        if (!cell) {
//            cell = [[GS_HotCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotIdentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.delegate = self;
//        cell.hotCityArray = self.hotCityArr;
//        return cell;
//    }
    else {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = self.allCityArr[indexPath.section-1][indexPath.row][@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == HotCitySection) {
//        return [GS_HotCityTableViewCell getCellHeight];
//    } else {
        return 50;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return 0.01;
    }
    return 25;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = GS_Background_Color;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 25)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = GS_Main_Color;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:headerLabel];
    if (section == LocationSection) {
        headerLabel.text = @"当前定位";
    }
//    else if (section == HotCitySection) {
//        headerLabel.text = @"热门城市";
//    }
    else {
        NSString *chara = self.indexList[section];
        headerLabel.text = chara;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == LocationSection) {
        return 25;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.searchController.active) {
        return nil;
    }
    
    if (section == LocationSection) {
     
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = GS_Background_Color;
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 25)];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textColor = GS_Main_Color;
    footerLabel.textAlignment = NSTextAlignmentLeft;
    footerLabel.font = [UIFont systemFontOfSize:14];
    footerLabel.text = @"已开通城市";
    [footerView addSubview:footerLabel];
        
        return footerView;
    } else {
        return nil;
    }
}



#pragma mark - 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return nil;
    }
    return self.indexList;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self showBigSelectedCharacter:title];
    if ([title isEqual:@"定"]) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return 0;
    }
//    else if([title isEqual:@"热"]) {
//        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        return 1;
//    }
    else {
        NSInteger selectSection = 0;
        for (int i = 0; i<self.indexList.count; i++) {
            if ([self.indexList[i] isEqual:title]) {
                selectSection = i;
                break;
            }
            selectSection = 0;
        }
        if (self.allCityArr.count > 0) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:selectSection] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return selectSection;
        } else {
            return 0;
        }
    }
}

- (void)showBigSelectedCharacter:(NSString *)title {
    if (charLabel) {
        [charLabel removeFromSuperview];
    }
    
    charLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    charLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-50);
    charLabel.backgroundColor = GS_Main_Color;
    charLabel.text = title;
    charLabel.textAlignment = NSTextAlignmentCenter;
    charLabel.font = [UIFont boldSystemFontOfSize:35];
    charLabel.textColor = [UIColor whiteColor];
    charLabel.layer.cornerRadius = 2;
    charLabel.layer.masksToBounds = YES;
    [self.view addSubview:charLabel];
    
    [UIView animateWithDuration:1 animations:^{
        charLabel.alpha = 0;
    }];
}
#pragma mark - UISearchController delegate
- (void)viewDidLayoutSubviews {
    
    if (self.searchController.active) {
        self.cityTableView.frame = CGRectMake(0, 20, GSScreen_Width, GSScreen_Height-20-GSSafeAreaBottomHeight);
    } else {
        self.cityTableView.frame = CGRectMake(0, 0, GSScreen_Width, GSScreen_Height-GSSafeAreaTopHeight-GSSafeAreaBottomHeight);
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // @available(iOS 11.0, *)
    if ([UIDevice currentDevice].systemVersion.floatValue > 10.0) {
        // 11反而不需要
    } else {
        // 防止上移20
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.searchArray removeAllObjects];
    for (NSDictionary *dic in self.allCityArrTemp) {
        NSString *name = [NSString stringWithFormat:@"%@", dic[@"name"]];
        NSString *pinyin = [NSString stringWithFormat:@"%@", dic[@"pinyin"]];
        NSString *text = [NSString stringWithFormat:@"%@", self.searchController.searchBar.text];
        
        if ([name containsString:text] || [[pinyin lowercaseString] containsString:[text lowercaseString]]) {
            [self.searchArray addObject:dic];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cityTableView reloadData];
    });
}
#pragma mark - 点击返回
//点击定位城市
- (void)clickGS_LocationCityTableViewCell:(UIButton *)button
{
    if (button.titleLabel.text.length != 0 && ![button.titleLabel.text isEqualToString:@"正在定位..."] && ![button.titleLabel.text isEqualToString:@"定位失败"]) {
        if (self.selectCityNameAndId) {
            self.selectCityNameAndId(self.locationCity, self.locationCityId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//点击热门城市
- (void)clickGS_HotCityTableViewCell:(UIButton *)button
{
    NSString *name = self.hotCityArr[button.tag-1000][@"name"];
    NSString *cityid = self.hotCityArr[button.tag-1000][@"city_id"];
    if (self.selectCityNameAndId) {
        self.selectCityNameAndId(name, cityid);
    }
    if (button.titleLabel.text.length != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//点击tableViewCell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) {
        NSString *name = self.searchArray[indexPath.row][@"name"];
        NSString *cityid = self.searchArray[indexPath.row][@"city_id"];
        if (self.selectCityNameAndId) {
            self.selectCityNameAndId(name, cityid);
        }
//        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (indexPath.section >= 1) {
        NSString *name = self.allCityArr[indexPath.section-1][indexPath.row][@"name"];
        NSString *cityid = self.allCityArr[indexPath.section-1][indexPath.row][@"city_id"];
        if (self.selectCityNameAndId) {
            self.selectCityNameAndId(name, cityid);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)netWorkingForGps {
    
    [GS_ProgressHUD showHUDView:YES];
    [GS_NetWorking POSTWithURLString:URL_TaxLoginGps Parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
        NSDictionary *dic = responseObject;
        
        self.locationCity = [GS_DataTools filterStrNull:dic[@"cityName"]];
        [self.locationCellBtn setTitle:self.locationCity forState:UIControlStateNormal];
        self.locationCityId = [GS_DataTools filterStrNull:dic[@"cityNumber"]];
        
    } failure:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [GS_ProgressHUD showHUDView:NO];
    }];
}


- (void)dealloc {
    self.searchController.active = NO;
    self.searchController = nil;
}

@end
