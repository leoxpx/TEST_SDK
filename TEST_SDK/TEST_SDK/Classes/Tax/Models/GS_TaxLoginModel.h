//
//  GS_TaxLoginModel.h
//  BaseSDK
//
//  Created by xinwang on 2017/12/11.
//  Copyright © 2017年 杭州薪王信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GS_TaxFormInfosModel.h"
#import "GS_TaxSiteHelpModel.h"
#import "GS_TaxUrlInfosModel.h"

// 总
@interface GS_TaxLoginModel : NSObject

@property (nonatomic, strong) NSArray *formInfos; // 表单
@property (nonatomic, strong) NSDictionary *siteHelp; // 帮助
@property (nonatomic, strong) NSArray *urlInfos; // 注册找回密码
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code; // 成功过不存在 失败存在
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *dataParserUrl;

@end


/*
{
    formInfos =     (
                     {
                         formId = 4;
                         formName = "\U7528\U6237\U540d\U767b\U5f55";
                         inputInfos =             (
                                                   {
                                                       defaultValue = "";
                                                       inputId = 17;
                                                       inputLabel = "\U8d26\U6237";
                                                       inputName = yhm;
                                                       inputTip = "\U7528\U6237\U540d/\U90ae\U7bb1/\U624b\U673a\U53f7\U7801";
                                                       inputType = input;
                                                       options = "<null>";
                                                   },
                                                   {
                                                       defaultValue = "";
                                                       inputId = 21;
                                                       inputLabel = "\U5bc6\U7801";
                                                       inputName = mm;
                                                       inputTip = "<null>";
                                                       inputType = password;
                                                       options = "<null>";
                                                   },
                                                   {
                                                       defaultValue = "<null>";
                                                       inputId = imgCode5;
                                                       inputLabel = "\U9a8c\U8bc1\U7801";
                                                       inputName = authCode;
                                                       inputTip = "<null>";
                                                       inputType = imgCode;
                                                       options = "<null>";
                                                   }
                                                   );
                         yzmTip = "<null>";
                     },
                     {
                         formId = 5;
                         formName = "\U8bc1\U4ef6\U767b\U5f55";
                         inputInfos =             (
                                                   {
                                                       defaultValue = 201;
                                                       inputId = 24;
                                                       inputLabel = "\U8bc1\U4ef6\U7c7b\U578b";
                                                       inputName = idType;
                                                       inputTip = "<null>";
                                                       inputType = select;
                                                       options =                     (
                                                                                      {
                                                                                          key = 201;
                                                                                          value = "\U5c45\U6c11\U8eab\U4efd\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 202;
                                                                                          value = "\U519b\U5b98\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 203;
                                                                                          value = "\U6b66\U8b66\U8b66\U5b98\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 204;
                                                                                          value = "\U58eb\U5175\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 208;
                                                                                          value = "\U5916\U56fd\U62a4\U7167";
                                                                                      },
                                                                                      {
                                                                                          key = 210;
                                                                                          value = "\U6e2f\U6fb3\U5c45\U6c11\U6765\U5f80\U5185\U5730\U901a\U884c\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 213;
                                                                                          value = "\U53f0\U6e7e\U5c45\U6c11\U6765\U5f80\U5927\U9646\U901a\U884c\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 219;
                                                                                          value = "\U9999\U6e2f\U8eab\U4efd\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 220;
                                                                                          value = "\U53f0\U6e7e\U8eab\U4efd\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 221;
                                                                                          value = "\U6fb3\U95e8\U8eab\U4efd\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 227;
                                                                                          value = "\U4e2d\U56fd\U62a4\U7167";
                                                                                      },
                                                                                      {
                                                                                          key = 233;
                                                                                          value = "\U5916\U56fd\U4eba\U6c38\U4e45\U5c45\U7559\U8bc1";
                                                                                      },
                                                                                      {
                                                                                          key = 216;
                                                                                          value = "\U5916\U4ea4\U5b98\U8bc1";
                                                                                      }
                                                                                      );
                                                   },
                                                   {
                                                       defaultValue = "";
                                                       inputId = 25;
                                                       inputLabel = "\U8bc1\U4ef6\U53f7\U7801";
                                                       inputName = idNumber;
                                                       inputTip = "<null>";
                                                       inputType = input;
                                                       options = "<null>";
                                                   },
                                                   {
                                                       defaultValue = "";
                                                       inputId = 26;
                                                       inputLabel = "\U5bc6\U7801";
                                                       inputName = mm;
                                                       inputTip = "<null>";
                                                       inputType = password;
                                                       options = "<null>";
                                                   },
                                                   {
                                                       defaultValue = "<null>";
                                                       inputId = imgCode5;
                                                       inputLabel = "\U9a8c\U8bc1\U7801";
                                                       inputName = authCode;
                                                       inputTip = "<null>";
                                                       inputType = imgCode;
                                                       options = "<null>";
                                                   }
                                                   );
                         yzmTip = "<null>";
                     }
                     );
    message = "\U8be5\U5730\U533a\U7a0e\U52a1\U7cfb\U7edf\U95ed\U5173\U4fee\U70bc\U4e2d\Uff01";
    siteHelp =     {
        bottomMsg = "<null>";
        siteHelpSteps =         (
                                 {
                                     siteLoginHelpBtns =                 (
                                                                          {
                                                                              btnIcon = "<null>";
                                                                              btnText = "\U7acb\U5373\U6ce8\U518c";
                                                                              btnTitle = "<null>";
                                                                              btnType = url;
                                                                              btnValue = "http://gr.tax.sh.gov.cn/webchart/m_login.xhtml#/register/yhxz";
                                                                          },
                                                                          {
                                                                              btnIcon = "<null>";
                                                                              btnText = "\U5fd8\U8bb0\U5bc6\U7801";
                                                                              btnTitle = "<null>";
                                                                              btnType = url;
                                                                              btnValue = "https://gr.tax.sh.gov.cn/webchart/?from=singlemessage&isappinstalled=0#/forgetPassword";
                                                                          }
                                                                          );
                                     text = "\U901a\U8fc7\U94f6\U884c\U5361\U5b9e\U540d\U8ba4\U8bc1\U6ce8\U518c
                                     \n\U4f7f\U7528\U94f6\U8054\U94f6\U884c\U5361\U8fdb\U884c\U5b9e\U540d\U8eab\U4efd\U4fe1\U606f\U8fdb\U884c\U8ba4\U8bc1
                                     \n\U540c\U610f\U6ce8\U518c\U534f\U8bae\U540e\Uff0c\U9009\U62e9\U201c\U4e2a\U4eba\U53ef\U4fe1\U8eab\U4efd\U591a\U6e90\U8ba4\U8bc1\U6ce8\U518c\U201d\U540e\U901a\U8fc7\U94f6\U8054\U94f6\U884c\U5361\U8fdb\U884c\U8eab\U4efd\U8ba4\U8bc1\U3002";
                                     tip = "<null>";
                                     title = "\U65b9\U5f0f\U4e00  \U901a\U8fc7\U94f6\U884c\U5361\U5b9e\U540d\U8ba4\U8bc1\U6ce8\U518c";
                                     type = method;
                                 },
                                 {
                                     siteLoginHelpBtns =                 (
                                                                          {
                                                                              btnIcon = "<null>";
                                                                              btnText = "\U67e5\U770b\U7f51\U70b9";
                                                                              btnTitle = "<null>";
                                                                              btnType = url;
                                                                              btnValue = "https://www.igeshui.com/share/map/index.html?cityid=310100";
                                                                          }
                                                                          );
                                     text = "\U9700\U643a\U5e26\U672c\U4eba\U8eab\U4efd\U8bc1\U81f3\U7a0e\U52a1\U4e2d\U5fc3\U7f51\U70b9\U7533\U8bf7\U6ce8\U518c\U7801\U3002";
                                     tip = "<null>";
                                     title = "\U65b9\U5f0f\U4e8c  \U4f7f\U7528\U201d\U6ce8\U518c\U7801\U201c\U6ce8\U518c";
                                     type = method;
                                 }
                                 );
        topMsg = "\U901a\U8fc7\U4ee5\U4e0b\U65b9\U5f0f\U6b65\U9aa4,\U83b7\U53d6\U67e5\U8be2\U8d26\U6237";
    };
    status = 1;
    urlInfos =     (
                    {
                        backUrl = "www.baidu.com";
                        id = 3;
                        siteId = 4;
                        url = "http://oauth.iiap.sheca.com/h5/oauth/authorize?response_type=code&scope=read,write&client_id=6a7fadf4-a1e6-4262-bcf8-899f37aa0bf3&redirect_uri=https://gr.tax.sh.gov.cn/webchart/?dyrzType=1&state=75d353bb-1b9d-4e1e-af2f-60719609c32e";
                        urlType = register;
                    },
                    {
                        backUrl = "www.baidu.com";
                        id = 4;
                        siteId = 4;
                        url = "https://gr.tax.sh.gov.cn/webchart/?from=singlemessage&isappinstalled=0#/forget/password/authorization";
                        urlType = findPassword;
                    }
                    );
}
*/
