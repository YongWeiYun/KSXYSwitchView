//
//  KSXYSwitchView.m
//  CircleButton
//
//  Created by yunyongwei on 2016/11/28.
//  Copyright © 2016年 yunyongwei. All rights reserved.
//

#import "KSXYSwitchView.h"

///按钮显示的半径
#define KSXYSwitchViewRadius 100.f
///按钮的宽度
#define KSXYSwitchViewButtonW 40.f

#define KSXYSwitchViewButtonTag 123

@interface KSXYSwitchView ()

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, assign) CGPoint buttonsCenter;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) void (^buttonClicked)(NSInteger index);

@end

@implementation KSXYSwitchView

+ (void)showInView:(UIView *)view images:(NSArray *)images atPoint:(CGPoint)point buttonClicked:(void (^)(NSInteger index))buttonClicked {
    KSXYSwitchView *switchView = [[KSXYSwitchView alloc] initWithFrame:(CGRect){0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height}];
    switchView.backgroundColor = [UIColor clearColor];
    [view addSubview:switchView];
    
    switchView.images = images;
    switchView.buttonsCenter = point;
    switchView.buttonClicked = buttonClicked;
    switchView.isSelected = NO;
    [switchView showAtPoint:point];
}

- (void)startAnimation {
    NSUInteger count = self.images.count;
    for(int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:KSXYSwitchViewButtonTag + i];
        __weak __typeof__(self) ws = self;
        [UIView animateWithDuration:0.2 + i / 10.f animations:^{
            button.center = [[ws.points objectAtIndex:i] CGPointValue];
            button.alpha = 1.f;
            if(i == count - 1) {
                ws.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.6f];
            }
        }];
    }
}

- (void)endAnimation {
    if(self.isSelected) {
        return;
    }
    NSUInteger count = self.images.count;
    for(int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:KSXYSwitchViewButtonTag + i];
        __weak __typeof__(self) ws = self;

        if(i == count - 1) {
            [UIView animateWithDuration:0.2 + i / 10.f animations:^{
                button.center = self.buttonsCenter;
                button.alpha = 0.f;
                ws.backgroundColor = [UIColor clearColor];
            } completion:^(BOOL finished) {
                [ws removeFromSuperview];
            }];
        } else {
            [UIView animateWithDuration:0.2 + i / 10.f animations:^{
                button.center = ws.buttonsCenter;
                button.alpha = 0.f;
            }];
        }
    }
}

- (void)clickedAnimationWithIndex:(NSInteger)index {
    self.isSelected = YES;
    NSUInteger count = self.images.count;
    for(int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:KSXYSwitchViewButtonTag + i];
        if(i == index) {
            [UIView animateWithDuration:0.4 animations:^{
                button.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
                button.center = (CGPoint){[[UIScreen mainScreen] bounds].size.width / 2.f, [[UIScreen mainScreen] bounds].size.height / 2.f};

            } completion:^(BOOL finished) {
                if(self.buttonClicked) {
                    self.buttonClicked(index);
                }
                [self removeFromSuperview];
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                button.alpha = 0.f;
            }];
        }
    }
}

- (void)showAtPoint:(CGPoint)point {
    NSUInteger count = self.images.count;
    CGFloat angle = [self getMaxAngleWithPoint:point] / (count + 1);
    
    self.points = [NSMutableArray array];
    
    for(int i = 0; i < count; i++) {
        NSInteger index = i + 1;
        
        CGFloat buttonAngle = angle * index - 90;
        if(self.startAngle != 0) {
            buttonAngle += self.startAngle;
        }
        CGFloat x = point.x + KSXYSwitchViewRadius * cos(buttonAngle * M_PI / 180.f);
        CGFloat y = point.y + KSXYSwitchViewRadius * sin(buttonAngle * M_PI / 180.f);
        [self.points addObject:[NSValue valueWithCGPoint:(CGPoint){x, y}]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:[self.images objectAtIndex:i]] forState:UIControlStateNormal];
        button.bounds = (CGRect){0, 0, KSXYSwitchViewButtonW, KSXYSwitchViewButtonW};
        button.center = (CGPoint){point.x, point.y};
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = KSXYSwitchViewButtonW / 2.f;
        button.alpha = 0.f;
        button.tag = KSXYSwitchViewButtonTag + i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    [self startAnimation];
}

- (CGFloat)getMaxAngleWithPoint:(CGPoint)point {
    ///180度
    if(point.y >= KSXYSwitchViewRadius && point.y <= [[UIScreen mainScreen] bounds].size.height - KSXYSwitchViewRadius) {
        self.startAngle = 0;
        self.endAngle = 0;

        return 180.f;
    } else {
        if(point.y < KSXYSwitchViewRadius) {
            self.startAngle = 90.f * (KSXYSwitchViewRadius - point.y) / KSXYSwitchViewRadius;
            self.startAngle += 5.f;
            self.endAngle = 180.f;
            return 180.f - self.startAngle;
        } else {
            self.startAngle = 0;
            self.endAngle = 90.f * (KSXYSwitchViewRadius - ([[UIScreen mainScreen] bounds].size.height - point.y)) / KSXYSwitchViewRadius;
            self.endAngle += 5.f;

            return 180.f - self.endAngle;
        }
    }
}

- (void)buttonClicked:(UIButton *)button {
    [self clickedAnimationWithIndex:button.tag - KSXYSwitchViewButtonTag];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endAnimation];
}

@end
