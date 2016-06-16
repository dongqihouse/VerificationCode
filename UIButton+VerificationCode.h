//
//  UIButton+VerificationCode.h
//  HomeFlavour
//
//  Created by DQ on 16/6/15.
//  Copyright © 2016年 北京物网科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^handelBlock)(NSError *error);
@interface UIButton (VerificationCode)

//获取验证码
- (void)getCode:(NSString *)phone
          block:(handelBlock)block;
//验证验证码
- (void)VerificationCode:(NSString *)phone
                    Code:(NSString *)code
                   block:(handelBlock)block;
@end
