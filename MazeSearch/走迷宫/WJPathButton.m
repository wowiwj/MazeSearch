//
//  WJPathButton.m
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "WJPathButton.h"


@interface WJPathButton()<PathDelegate>

@end

@implementation WJPathButton



+(instancetype)pathButtonWithPath:(Path *)path
{
    WJPathButton *button = [[WJPathButton alloc] init];
    
    
    button.path = path;

    return button;
}


- (void)setPath:(Path *)path
{
    _path = path;

    path.delegate = self;
     

}


- (BOOL)pass
{
    if (self.path.status == PathStatusWall) {
        return NO;
    }
    
    if (self.path.isPass == YES) {
        return NO;
    }

    return YES;

}


- (void)path:(Path *)path didChangedStatus:(PathStatus)status
{
    if (path.status == PathStatusEnable) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    else if(path.status == PathStatusStart)
    {
        self.backgroundColor = [UIColor greenColor];
    }
    else if(path.status == PathStatusEnd)
    {
        self.backgroundColor = [UIColor redColor];
    }
    else if(path.status == PathStatusWall)
    {
        self.backgroundColor = [UIColor blackColor];
    }
    else if(path.status == PathStatusTest)
    {
        self.backgroundColor = [UIColor orangeColor];
    }
}

@end
