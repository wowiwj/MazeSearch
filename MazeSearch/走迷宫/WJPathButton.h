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

@property (nonatomic,strong) Path *path;

+ (instancetype)pathButtonWithPath:(Path *)path;

- (BOOL)pass;


//+ (instancetype)nextButtonWithDirection:(PathDireaction)dir;

@end
