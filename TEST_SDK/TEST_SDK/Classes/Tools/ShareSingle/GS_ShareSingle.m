//
//  GS_ShareSingle.m
//  KidsGrowingNotes
//
//  Created by 薪王iOS1 on 2017/7/12.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import "GS_ShareSingle.h"

@implementation GS_ShareSingle

+ (GS_ShareSingle *)shareSingle {
    
    static GS_ShareSingle *Share = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (Share == nil) {
            Share = [[GS_ShareSingle alloc] init];
            
            
        }
    });
    
    return Share;
}

@end
