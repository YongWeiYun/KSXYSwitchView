//
//  ViewController.m
//  KSXYSwitchView
//
//  Created by yunyongwei on 2017/9/19.
//  Copyright © 2017年 kunshanxiaoya. All rights reserved.
//

#import "ViewController.h"
#import "KSXYSwitchView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(touches.count == 1) {
        UITouch * touch = touches.anyObject;//获取触摸对象
        CGPoint point = [touch locationInView:self.view];
        [KSXYSwitchView showInView:self.view images:@[@"person_info.png", @"make_call.png", @"make_audio_call.png", @"make_video_call.png"] atPoint:point buttonClicked:^(NSInteger index) {
            if(index == 0) {
                NSLog(@"Click person button index = %ld", (long)index);
            } else if(index == 1) {
                NSLog(@"Click call button index = %ld", (long)index);
            } else if(index == 2) {
                NSLog(@"Click audio call button index = %ld", (long)index);
            } else if(index == 3) {
                NSLog(@"Click video call button index = %ld", (long)index);
            }
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
