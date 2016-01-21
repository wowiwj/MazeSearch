//
//  Path.h
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Path;

//路径状态
typedef enum
{
    PathStatusEnable,
    PathStatusWall,
    PathStatusStart,
    PathStatusEnd
}PathStatus;

//路径的方向
typedef enum
{
    PathDieactionTop = 1,
    PathDireactionTopRight,
    PathDieactionRight,
    PathDireactionRightBottom,
    PathDieactionBottom,
    PathDireactionBottomLeft,
    PathDieactionLeft,
    PathDireactionLeftTop

}PathDireaction;

@protocol PathDelegate <NSObject>

@optional
- (void)path:(Path *)path didChangedStatus:(PathStatus)status;

@end

@interface Path : NSObject

//代理
@property (nonatomic,weak) id<PathDelegate> delegate;

//路径的状态
@property (nonatomic,assign) PathStatus status;

@property (nonatomic,assign) CGPoint point;//图块在迷宫中的坐标位置
@property (nonatomic,assign) int ord;//上一个路径的序号
@property (nonatomic,assign) PathDireaction nextDireaction;


@property (nonatomic,assign) BOOL isPass;


+ (instancetype)pathWithRow:(int)row andCol:(int)col andMazeCol:(int)mazeCol;

@end
