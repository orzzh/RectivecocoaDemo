//
//  SignServes.h
//  RectivecocoaDemo
//
//  Created by 张子豪 on 2018/2/28.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SignServes : NSObject


- (void)signInWithUserName:(NSString *)name pass:(NSString *)pass complete:(void(^)(BOOL success))completeBlock;


@end
