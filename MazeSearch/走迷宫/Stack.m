//
//  Stack.m
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "Stack.h"

@interface Stack()

@property (nonatomic,strong) NSMutableArray *StackArray;

@end


@implementation Stack

- (NSMutableArray *)StackArray
{

    if (_StackArray == nil) {
        
        _StackArray = [NSMutableArray array];
        
    }

    return _StackArray;
}

- (void)push:(id)object
{
    if (object == nil) {
        return;
    }
    
    [self.StackArray addObject:object];
    
}


- (id)pop
{
    if (self.StackArray.count == 0) {
        return nil;
    }
    
    id object = [self.StackArray lastObject];
    
    [self.StackArray removeLastObject];
    
    return object;
    

}


- (BOOL)isEmpty
{

    if (self.StackArray.count > 0) {
        return NO;
    }
    
    return YES;

}

@end
