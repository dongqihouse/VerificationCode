//
//  UIButton+VerificationCode.m
//  HomeFlavour
//
//  Created by DQ on 16/6/15.
//  Copyright © 2016年 北京物网科技有限公司. All rights reserved.
//

#import "UIButton+VerificationCode.h"
#import <SMS_SDK/SMSSDK.h>
#import <objc/runtime.h>

const NSString *beginTimeKey;
const NSString *timerKey;
@implementation UIButton (VerificationCode)

#pragma mark --  public
//获取验证码
- (void)getCode:(NSString *)phone
          block:(handelBlock)block {
    self.userInteractionEnabled = NO;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *error) {
        block(error);
    }];
    [self configureTimer];
     
}
//验证验证码
- (void)VerificationCode:(NSString *)phone
                    Code:(NSString *)code
                   block:(handelBlock)block {
    [SMSSDK commitVerificationCode:code  phoneNumber:phone zone:@"86" result:^(NSError *error) {
        block(error);
    }];

}

#pragma mark 计时器
- (void)configureTimer {
    NSInteger beginTime = 60;

    NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeClock) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    [self setTimer:timer];
    [self setBeginTime:beginTime];

}
- (void)timeClock {
    [self setBeginTime:([self beginTime]-1)];
    NSInteger beginTime = [self beginTime];
    NSTimer *timer = [self timer];
    if (beginTime == 0) {
        [timer invalidate];
        self.userInteractionEnabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];

    }else {
        self.userInteractionEnabled = NO;
        [self setTitle:[NSString stringWithFormat:@"%lds",(long)beginTime] forState:UIControlStateNormal];
    }
    
    
}
#pragma mark -- set get
- (NSInteger)beginTime {
    return [objc_getAssociatedObject(self, &beginTimeKey) integerValue];
}
- (void)setBeginTime:(NSInteger)beginTime {
    objc_setAssociatedObject(self, &beginTimeKey, @(beginTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimer *)timer {
    return objc_getAssociatedObject(self, &timerKey);
}
- (void)setTimer:(NSTimer *)timer {
     objc_setAssociatedObject(self, &timerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
