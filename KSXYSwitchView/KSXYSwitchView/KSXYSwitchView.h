//
//  KSXYSwitchView.h
//  CircleButton
//
//  Created by yunyongwei on 2016/11/28.
//  Copyright © 2016年 yunyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSXYSwitchView : UIView

+ (void)showInView:(UIView *)view images:(NSArray *)images atPoint:(CGPoint)point buttonClicked:(void (^)(NSInteger index))buttonClicked;

@end
