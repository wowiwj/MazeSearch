//
//  WJPathButton.h
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Path.h"

@interface WJPathButton : UIButton
//每个按钮包含一个路径，以便迷宫的检索
@property (nonatomic,strong) Path *path;

+ (instancetype)pathButtonWithPath:(Path *)path;

- (BOOL)pass;

@end
