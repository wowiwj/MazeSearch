//
//  WJMazeView.m
//  走迷宫
//
//  Created by wangju on 16/1/14.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "WJMazeView.h"
#import "WJPathButton.h"

@implementation WJMazeView

- (void)setStack:(Stack *)stack
{
    _stack = stack;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0;
}

- (void)drawRect:(CGRect)rect
{
    if (self.stack == nil) {
        return;
    }
    WJPathButton *pathButton = self.stack.pop;
    
    //添加路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:pathButton.center];
    
    while (![self.stack isEmpty]) {
        pathButton = self.stack.pop;
        [path addLineToPoint:pathButton.center];
    }
    path.lineWidth = 8;//设置线宽
    [[UIColor greenColor] set];//设置画线颜色
    path.lineJoinStyle = kCGLineJoinRound;//设置线段圆角
    
    [path stroke];

}
@end
