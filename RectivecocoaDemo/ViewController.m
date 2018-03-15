//
//  ViewController.m
//  RectivecocoaDemo
//
//  Created by 张子豪 on 2018/2/6.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "SignServes.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Account;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIButton *CmitBtn;
@property (strong, nonatomic)SignServes *signInService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.CmitBtn.enabled = NO;
    self.CmitBtn.backgroundColor = [UIColor grayColor];

    
    //************* 1 **************
    
    // 账号值改变 发送信息流到subscribe 执行一次block
//    [self.Account.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    
    //************* 2 **************
    
    //通过 过滤器filter 筛选需要内容。满足筛选条件则执行next
//    RACSignal *racsign = [self.Account.rac_textSignal filter:^BOOL(id value) {
//        NSString *str = value;
//        return str.length>3;
//    }];
//    [racsign subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    
    //************* 3 **************
    
    //通过 map改变事件数据 从而进行不同设置
    //是否满足账号条件 返回bool
    RACSignal *acc = [self.Account.rac_textSignal map:^id(NSString *value) {
        return @([self isAcc:value]);
    }];
    
    //根据bool返回相应设置  RAC(对象1，对象1的属性) 将返回值赋值到对象1的属性中
    RAC(self.Account, backgroundColor) = [acc map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor clearColor]:[UIColor redColor];
    }];
    
    //密码解释 参上
    RACSignal *pas = [self.Password.rac_textSignal map:^id(NSString *value) {
        return @([self isAcc:value]);
    }];
    RAC(self.Password, backgroundColor) = [pas map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor clearColor]:[UIColor redColor];
    }];
    
    //聚合信号 两个中有任何变化时调用block 返回
    RACSignal *max = [RACSignal combineLatest:@[acc,pas] reduce:^id(NSNumber *ac,NSNumber*pa){
        return @([ac boolValue]&&[pa boolValue]);
    }];
    
    //最终执行
    [max subscribeNext:^(NSNumber *x) {
        if([x boolValue]){
            NSLog(@"登录");
            self.CmitBtn.enabled = YES;
            self.CmitBtn.backgroundColor = [UIColor blueColor];
        }else{
            NSLog(@"不能登录");
            self.CmitBtn.enabled = NO;
            self.CmitBtn.backgroundColor = [UIColor grayColor];
        }
    }];
    
    //初始化请求工具类 登录
    self.signInService = [[SignServes alloc]init];

    //创建了even信号 并设置出发block
    // flattenmap 信号内置信号处理／外部信号订阅内部信号
    [[[self.CmitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^id(id d) {
          
          //响应点击 按钮不可用
          self.CmitBtn.enabled = NO;
          self.CmitBtn.backgroundColor = [UIColor grayColor];
          
          //返回内部信号
          return [self signInSignal];
      }]subscribeNext:^(NSNumber *x) {
          
          //内部信号结束处理
          BOOL s = [x boolValue];
          self.CmitBtn.enabled = YES;
          self.CmitBtn.backgroundColor = [UIColor blueColor];
          if (s) {
              NSLog(@"跳转");
          }
      }];
    
}

//创建内部信号。登录请求
- (RACSignal *)signInSignal{
    return [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [self.signInService signInWithUserName:self.Account.text pass:self.Password.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}


- (BOOL)isAcc:(NSString *)acc{
    if ([acc isEqualToString:@"1234"]) {
        return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
