//
//  Stack.h
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

- (void)push:(id)object;

- (id)pop;

- (BOOL)isEmpty;

- (void)clear;

@end
