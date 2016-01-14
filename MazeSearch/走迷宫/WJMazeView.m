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
    if (_stack == nil) {
        return;
    }
    
    [self setNeedsDisplay];

}


- (void)drawRect:(CGRect)rect
{
    WJPathButton *pathButton = self.stack.pop;
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //添加路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:pathButton.center];
    
    while (![self.stack isEmpty]) {
        pathButton = self.stack.pop;
        [path addLineToPoint:pathButton.center];
    }
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);

}


@end
