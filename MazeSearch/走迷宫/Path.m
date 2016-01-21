//
//  Path.m
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "Path.h"
@interface Path()
@end
@implementation Path

+ (instancetype)pathWithRow:(int)row andCol:(int)col andMazeCol:(int)mazeCol
{
    
    Path *path = [[Path alloc] init];
    
    path.ord = 0;
    //列表示X
    //行表示Y
    path.point = CGPointMake(col, row);
    
    path.status = PathStatusEnable;
    
    path.nextDireaction = PathDieactionTop;
    
    return path;
}

- (void)setStatus:(PathStatus)status
{
    _status = status;
    
    if ([self.delegate respondsToSelector:@selector(path:didChangedStatus:)]) {
        [self.delegate path:self didChangedStatus:status];
    }
}
@end
