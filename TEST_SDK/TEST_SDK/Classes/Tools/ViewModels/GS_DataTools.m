//
//  YGS_DataTools.m
//  XPXBaseProjectTools
//
//  Created by 许 on 2017/6/7.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_DataTools.h"

@implementation GS_DataTools


#pragma mark - ------------------------- 数据处理 ------------------------
//字典转str
+ (NSString *)JSONDictionaryToString:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData  *jsonData = [ NSJSONSerialization  dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
}

//str转字典
+ (NSDictionary *)stringToJSONDictionary:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

/*
//创表
+ (void)createUserDB {
    
    //数据的路径，放在沙盒的cache下面
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"GSGJUserInfo.db"];
    //创建并且打开一个数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    //创建表
    BOOL create =  [db executeUpdate:@"create table if not exists UserInfo (name varchar(20), infovalue text)"];
    
    if (create) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
    }
}

//存数据
+ (void)saveData:(NSDictionary *)dict ToSanBox:(NSString *)pathName{
    
    NSString *dataStr = [XPXDataCache JSONDictionaryToString:dict];//转str
    
    //建表DB
    [XPXDataCache createUserDB];
    
    //数据的路径，放在沙盒的cache下面
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"GSGJUserInfo.db"];
    //创建并且打开一个数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    BOOL flag = [db open];
    if (flag) {
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
    
    //向库表添加数据
    //先删除
    [db executeUpdate:@"delete from UserInfo where name like ?",pathName];
    //再插入
    BOOL insert = [db executeUpdate:@"insert into UserInfo (name,infovalue) values(?,?)",pathName,dataStr];
    if (insert) {
        NSLog(@"插入数据成功");
    }else{
        NSLog(@"插入数据失败");
    }
    
    [db close];
}

//取数据
+ (id)getDataWithSanBox:(NSString *)pathName{
    
    //数据的路径，放在沙盒的cache下面
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"GSGJUserInfo.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    //查找到的结果是FMResultSet类型的对象
    NSString *select_sql = [NSString stringWithFormat:@"select * from UserInfo where name = '%@'",pathName];
    FMResultSet *set = [db executeQuery:select_sql];
    
    NSDictionary *myDic;
    while (set.next) {
        myDic = [XPXDataCache stringToJSONDictionary:[set stringForColumn:@"infovalue"]];//转换成字典
    }
    [db close];
    
    return myDic;
}

//更新
+ (void)uploadDBDate:(NSString *)infoName value:(NSString *)value{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"GSGJUserInfo.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    BOOL update = [db executeUpdate:@"update UserInfo set name = ?  where infovalue = '?'",infoName, value];
    if (update) {
        NSLog(@"更新数据成功");
    }else{
        NSLog(@"更新数据失败");
    }
}

//删数据
+ (void)deleteDBData:(NSString *)infoName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"GSGJUserInfo.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    BOOL delete = [db executeUpdate:@"delete from UserInfo where name like ?",infoName];
    if (delete) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败");
    }
}
*/

//过滤 null 为 @""
+ (NSString *)filterStrNull:(NSString *)oldString{
    /*
     if (oldString != nil && (NSNull *)oldString != [NSNull null] && [oldString isEqual:[NSNull null]]) {
     if ([oldString length]!=0) {
     if ([oldString isEqualToString:@"(null)"]) {
     return @"";
     }
     if ([oldString isEqualToString:@"<null>"]) {
     return @"";
     }
     return  oldString;
     }else{
     return @"";
     }
     }
     else{
     return @"";
     }
     */
    /*
     if (oldString != nil) {
     if (![oldString isKindOfClass:[NSNull class]]) {
     if (![oldString isEqualToString:@"(null)"]) {
     if (![oldString isEqualToString:@"<null>"]) {
     if (![oldString isEqualToString:@"null"]) {
     if ([oldString length] != 0) {
     return oldString;
     }
     return @"";
     }
     return @"";
     }
     return @"";
     }
     return @"";
     }
     return @"";
     }*/
    
    NSString *str = [NSString stringWithFormat:@"%@", oldString];
    
    if (str != nil && (NSNull *)str != [NSNull null] && ![str isKindOfClass:[NSNull class]] && ![str isEqualToString:@"(null)"] && ![str isEqualToString:@"<null>"] && ![str isEqualToString:@"null"] && [str length] != 0) {
        return str;
    }else{
        return @"";
    }
}
//过滤 null 为 "0.00"
+(NSString *)filterStrNullToZero:(NSString *)oldString{
    oldString = [NSString stringWithFormat:@"%@",oldString];
    if (oldString != nil && (NSNull *)oldString != [NSNull null] && ![oldString isEqualToString:@"(null)"] && ![oldString isEqualToString:@"<null>"] && ![oldString isEqualToString:@"null"] && [oldString length] != 0) {
        return oldString;
    }else{
        return @"0.00";
    }
}
// 是否是数组
+(BOOL)isArrayNotDict:(id)responseObject {
    if ([responseObject isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}


//
+ (NSString *)nowTimeIntervalStr {
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];// 获得系统的时区
    //    NSTimeInterval timeless = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSTimeInterval a =([date timeIntervalSince1970])*1000;  //  *1000精确到毫秒 (未加时差)
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    
    return [timeString componentsSeparatedByString:@"."].firstObject;
}
// 转为本地时间
+ (NSString *)getLocationDate:(NSDate *)zeroDate {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateStr = [formatter stringFromDate:zeroDate];
    
    return currentDateStr;
}

//当前时间 显示
+ (NSString *)getDateShow:(NSDate *)oldDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateStr = [formatter stringFromDate:oldDate];
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld年%ld月",(long)year,(long)month];//@"2016年1月";
    
    return dateString;
}

+ (NSString *)returnDate:(NSString *)seconds {
    int x = [[seconds substringToIndex:10] intValue];
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:x];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateformatter setDateFormat:@"yyyy.MM"];
    NSString *locationDate = [dateformatter stringFromDate:date1];
    return locationDate;
}

// 年月日时分
+ (NSString *)getDateShowYMDS:(NSString *)seconds{
    
    int x = [[seconds substringToIndex:10] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:x];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd hh:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *locationDate = [formatter stringFromDate:date];
    
    return locationDate;
}

#pragma mark - -------------------- 判断输入信息 ---------------
//手机号
+ (BOOL)checkTel:(NSString *)telNumber {
    NSString* number=@"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:telNumber];
}

//判断是否为数字
+ (BOOL)isNoPointNumber:(NSString *)numbers {
    //    NSString *number = @"^[1-9]d*|0$";
    //    [numbers rangeOfString:@"."].location != NSNotFound;
    NSString *number = @"^[0-9]*$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:numbers];
}

//判断是否为数字和小数
+ (BOOL)isNumber:(NSString *)numbers {
    //    NSString *number = @"^[1-9]d*|0$";
    NSString *number = @"^[0-9.]*$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:numbers];
}

//判断最多两位小数
+ (BOOL)isTwoPointNumber:(NSString *)numbers {
    //    NSString *number = @"^([1-9]\d*|0)(\.\d{1,2})?$";
    NSString *number = @"^(([1-9]+)|([0-9]+\.[0-9]{1,2}))$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:numbers];
}

//判断最多两位小数
+ (BOOL)isTwoPointNumberByStr:(NSString *)numbers {
    
    if (numbers.length > 10){
        return NO;
    }
    if ([numbers componentsSeparatedByString:@"."].count > 2) {
        return NO;
    }
    if (numbers.length > 1 && [[numbers substringToIndex:1] isEqualToString:@"."]) {
        return NO;
    }
    if ([numbers componentsSeparatedByString:@".."].count > 1) {
        return NO;
    }
    
    return YES;
}
/** 匹配征信用户名是否合法，6-16位数字和字母或_-/符号*/
+ (BOOL)checkCreditUserName:(NSString *)userName {
    NSString* number=@"^[A-Za-z0-9-_/]{6,16}+$";//+表示至少有一个限定的字符(不为空)
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:userName];
}
/** 匹配征信密码是否合法，6-20位数字和字母组合*/
+ (BOOL)checkCreditPassword:(NSString *)userName {
    NSString* number=@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:userName];
}
/** 匹配身份证号码是否合法*/
+ (BOOL)checkIdentity:(NSString *)identityNum {
    BOOL flag;
    if (identityNum.length <= 14) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    //    NSString *regex2 = @"^\d{14}(\d{1}|\d{4}|(\d{3}[xX]))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityNum];
}
//匹配用户姓名是否合法 中文
+ (BOOL)checkChineseName : (NSString *)userName {
    NSString* number=@"^[\u4e00-\u9fa5]{2,4}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:userName];
}
/** 匹配学信密码是否合法，6-30位数字或字母或特殊字符组合*/
+ (BOOL)checkSchoolPassword:(NSString *)userName {
    NSString* number=@"^[A-Za-z0-9@&+-_/=]{6,30}+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:userName];
}

// 千位符函数
- (NSString *)separatedStrWithStr:(NSString *)string {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    double value = [string doubleValue];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter stringFromNumber:@(value)];
}
- (NSString *)separatedFloatStrWithStr:(NSString *)string {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    double value = [string doubleValue];
    [formatter setPositiveFormat:@"###,##0.00;"];
    return [formatter stringFromNumber:@(value)];
}
// 删除末尾0
- (NSString *)deleteZeroWithString:(NSString *)str {
    NSMutableString *string = [[NSMutableString alloc]initWithFormat:@"%@",str];
    NSArray *array_1 = [string componentsSeparatedByString:@"."];
    if (array_1.count == 2) {
        for (int i =0; i <1000; i++) {
            
            if ([[string substringWithRange:NSMakeRange(string.length -1, 1)] isEqualToString:@"0"]) {
                [string deleteCharactersInRange:NSMakeRange(string.length -1 , 1)];
            } else if([[string substringWithRange:NSMakeRange(string.length -1, 1)] isEqualToString:@"."]) {
                [string deleteCharactersInRange:NSMakeRange(string.length -1, 1)];
                i= 10000;
            } else {
                i= 10000;
            }
        }
    }
    NSArray *array_2 = [string componentsSeparatedByString:@"."];
    if (array_2.count == 2) {
        NSString *intStr = [array_2 objectAtIndex:0];
        intStr = [self separatedStrWithStr:intStr];
        NSString *dotStr = [array_2 objectAtIndex:1];
        string = [[NSMutableString alloc]initWithFormat:@"%@.%@",intStr,dotStr];
    } else {
        string = [[NSMutableString alloc]initWithFormat:@"%@",[self separatedStrWithStr:string]];
    }
    return (NSString *)string;
}
- (NSString *)deleteZeroFormatFloat:(float)f {
    if (fmodf(f, 1)==0) { //如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) { //如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}





@end
