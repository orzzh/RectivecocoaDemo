//
//  SignServes.m
//  RectivecocoaDemo
//
//  Created by 张子豪 on 2018/2/28.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "SignServes.h"

@implementation SignServes


- (void)signInWithUserName:(NSString *)name pass:(NSString *)pass complete:(void (^)(BOOL))completeBlock{
    
    NSLog(@"acc:%@ pas:%@",name,pass);
    
    //假装在登陆
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completeBlock(YES);
    });
}
@end
