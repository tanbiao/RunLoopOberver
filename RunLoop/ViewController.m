//
//  ViewController.m
//  RunLoop
//
//  Created by 西厢流水 on 2018/9/2.
//  Copyright © 2018年 西厢流水. All rights reserved.
//

#import "ViewController.h"

// 备注:任务里面出现是耗性能的操作, 会卡顿界面.
// 需求渲染界面, 把系统runloop 一次渲染多个任务,改成一次渲染一次任务.优化UI界面

typedef void(^runTaskBlock)(void);

@interface ViewController ()
//保存任务的代码块儿,
@property(nonatomic,strong) NSMutableArray <runTaskBlock>*tasks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addRunLoopOberver];
}


-(void)addTask:(runTaskBlock)task
{
    [self.tasks addObject:task];
}

/**
 添加runLoop 的观察者
 */
-(void)addRunLoopOberver
{
    //获取当前 runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //创建上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    //创建观察者
    CFRunLoopObserverRef runLoopOberver  = CFRunLoopObserverCreate(NULL,kCFRunLoopBeforeWaiting, true, 0, &callBack, &context);
    //添加观察者 kCFRunLoopCommonModes 是整合了 defaut 模式 和 UI 模式的
    // kCFRunLoopDefaultMode  默认情况下 就是什么都不做的情况
    CFRunLoopAddObserver(runloop,runLoopOberver, kCFRunLoopCommonModes);
    //释放
    CFRelease(runLoopOberver);
}

// C语言函数
void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    ViewController *vc = (__bridge ViewController *) info;
    NSLog(@"vc=============%@",vc);
    //这里进行渲染界面
    if (vc.tasks.count == 0) {return;}
    runTaskBlock task = vc.tasks.firstObject;
    task();
}

@end
