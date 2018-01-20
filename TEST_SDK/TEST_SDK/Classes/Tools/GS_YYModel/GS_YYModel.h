//
//  YYModel.h
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/10.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<GS_YYModel/GS_YYModel.h>)
FOUNDATION_EXPORT double YYModelVersionNumber;
FOUNDATION_EXPORT const unsigned char YYModelVersionString[];
#import <GS_YYModel/NSObject+GS_YYModel.h>
#import <GS_YYModel/GS_YYClassInfo.h>
#else
#import "NSObject+GS_YYModel.h"
#import "GS_YYClassInfo.h"
#endif
