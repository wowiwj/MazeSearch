//
//  WJFirstController.m
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "WJFirstController.h"
#import "WJMainViewController.h"

@interface WJFirstController ()
@property (weak, nonatomic) IBOutlet UITextField *rowTextField;//行数
@property (weak, nonatomic) IBOutlet UITextField *colTextField;//列数
@end
@implementation WJFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowTextField.text = @"9";//给文本框这只初始值
    self.colTextField.text = @"9";
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];//当点击其他区域的时候退出键盘
}

//跳转前控制器间的传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WJMainViewController *destVc = segue.destinationViewController;
    destVc.MazeRow = [self.rowTextField.text intValue];
    destVc.MazeCol = [self.colTextField.text intValue];
}
@end
