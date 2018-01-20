// GS_AFNetworking.h
//
// Copyright (c) 2013 GS_AFNetworking (http://GS_AFNetworking.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <Availability.h>
#import <TargetConditionals.h>

#ifndef _GS_AFNetworking_
    #define _GS_AFNetworking_

    #import "GS_AFURLRequestSerialization.h"
    #import "GS_AFURLResponseSerialization.h"
    #import "GS_AFSecurityPolicy.h"

#if !TARGET_OS_WATCH
    #import "GS_AFNetworkReachabilityManager.h"
#endif

    #import "GS_AFURLSessionManager.h"
    #import "GS_AFHTTPSessionManager.h"

#endif /* _GS_AFNetworking_ */
