//
//  WJMainViewController.m
//  走迷宫
//
//  Created by wangju on 16/1/12.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import "WJMainViewController.h"
#import "WJMazeView.h"
#import "WJPathButton.h"
#import "Path.h"
#import "Stack.h"

#define ButtonWH 30
#define Padding 3

@interface WJMainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *MazeScollView;

@property (nonatomic,strong) UIView *MazeView;

@property (nonatomic,strong) WJMazeView *mazePathView;

@property (weak, nonatomic) IBOutlet UIButton *setStartPositionBtn;
@property (weak, nonatomic) IBOutlet UIButton *setEndPositionBtn;
@property (weak, nonatomic) IBOutlet UIButton *setWallBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (nonatomic,strong) WJPathButton *startButton;//迷宫入口按钮
@property (nonatomic,strong) WJPathButton *endButton;//迷宫终点按钮

//按钮状态类型
@property (nonatomic,strong) UIButton *selectStatusButton;

//位置没有按钮是，以墙处理
@property (nonatomic,strong) WJPathButton *wallButton;

@property (nonatomic,strong) NSMutableArray *allButtons;

@property (nonatomic,strong) Stack *stack;
@end

@implementation WJMainViewController

#pragma mark - 视图和模型的懒加载
- (UIView *)MazeView
{
    if (_MazeView == nil) {
        
        _MazeView = [[UIView alloc] init];
        
        _MazeView.backgroundColor = [UIColor orangeColor];
        
        CGFloat ViewW = Padding + (ButtonWH + Padding) * self.MazeCol;
        CGFloat ViewH = Padding + (ButtonWH + Padding) * self.MazeRow;
        CGFloat ViewX = 0;
        CGFloat ViewY = 0;
        
        if (ViewW < self.MazeScollView.bounds.size.width) {
            
            ViewX = (self.MazeScollView.bounds.size.width - ViewW) * 0.5f;
        }
        if (ViewH < self.MazeScollView.bounds.size.height) {
            
            ViewY = (self.MazeScollView.bounds.size.height - ViewH) * 0.5f;
        }
        _MazeView.frame = CGRectMake(ViewX, ViewY, ViewW, ViewH);
        [self.MazeScollView addSubview:_MazeView];
        
    }

    return _MazeView;
}



- (WJMazeView *)mazePathView
{
    if (_mazePathView == nil) {
        
        _mazePathView = [[WJMazeView alloc] init];
        
        _mazePathView.frame = self.MazeView.bounds;
        _mazePathView.alpha = 0;
        
        [self.MazeView addSubview:_mazePathView];
        
    }
    
    return _mazePathView;
    
}

- (NSMutableArray *)allButtons
{
    if (_allButtons == nil) {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}


- (WJPathButton *)wallButton
{

    if (_wallButton == nil) {
        
        Path *path = [[Path alloc] init];
        path.status = PathStatusWall;
        _wallButton = [WJPathButton pathButtonWithPath:path];
    }

    return _wallButton;

}

- (void)viewDidLoad {//主界面加载完成的时候调用
    [super viewDidLoad];
    //设置迷宫可滚动视图的滚动区域
    self.MazeScollView.contentSize = self.MazeView.bounds.size;

    [self addPathButton];//添加按钮
}
#pragma mark - 给视图添加按钮图块，设定按钮位置以及监听点击事件
- (void)addPathButton
{
    for (int i = 0; i < self.MazeRow; i++) {
        
        for (int j = 0; j < self.MazeCol; j++) {
          
            Path *path = [Path pathWithRow:i andCol:j andMazeCol:self.MazeCol];
            
            WJPathButton *pathButton = [WJPathButton pathButtonWithPath:path];
            pathButton.path = path;//给按钮添加路径
            
            [self.MazeView addSubview:pathButton];
            
            pathButton.backgroundColor = [UIColor whiteColor];
            
            [pathButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];//监听点击方法

            [self.allButtons addObject:pathButton];
            
            [self setButtonPosition];//设置添加按钮的位置
        }
        
    }
}

- (void)setButtonPosition
{

    for (WJPathButton *button in self.MazeView.subviews) {
        
        if ([button isKindOfClass:[WJPathButton class]]) {
            Path *buttonPath = button.path;
            
            CGPoint point = buttonPath.point;
            
            CGFloat buttonW = ButtonWH;
            CGFloat buttonH = ButtonWH;
            
            CGFloat padding = Padding;
            
            //pointx 第x列
            //pointy 第y行
            
            CGFloat buttonY = padding + point.y * (buttonW + padding);
            CGFloat buttonX = padding + point.x * (buttonH + padding);
            
            
            
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
 
        }
    }
    
}
//迷宫路径按钮被点击
- (void)buttonClicked:(WJPathButton *)button
{
    
    if (self.selectStatusButton.tag == 1) {//设置按钮为迷宫的入口位置
        self.startButton.path.status = PathStatusEnable;
        button.path.status = PathStatusStart;
        self.startButton = button;
    }
    else if (self.selectStatusButton.tag == 2)//设置按钮的迷宫为终点位置
    {
        self.endButton.path.status = PathStatusEnable;
        button.path.status = PathStatusEnd;
        self.endButton = button;
        
    }
    else if (self.selectStatusButton.tag == 3)//添加不可通过区域
    {
        button.path.status = PathStatusWall;
        
    }
    else//消除不可通过区域
    {
        button.path.status = PathStatusEnable;
      
    }
    

}
- (IBAction)selectButton:(UIButton *)sender {

    self.selectStatusButton.selected = NO;
    
    self.selectStatusButton = sender;
    sender.selected = YES;
    
}

#pragma mark - 走迷宫核心算法
- (IBAction)searchMazepath
{
    [self.stack clear];
    
    [self findPath];//寻找迷宫路径

    if (![self.stack isEmpty])//显示路径
    {
        self.mazePathView.alpha = 0.4;
        self.mazePathView.stack = self.stack;
        
    }
    else//提示没有找到路径
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"寻找失败!" message:@"没有找到路径" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancle];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
    for (WJPathButton *pathButton in self.allButtons) {
        Path *btnPath = pathButton.path;
        
        btnPath.isPass = NO;
        btnPath.nextDireaction = PathDieactionTop;
        pathButton.path = btnPath;
        
    }
    
}

- (BOOL)findPath//走迷宫
{
    Stack *stack = [[Stack alloc] init];

    self.stack = stack;
    
    int cureStep = 1;//探索第一步
    
    WJPathButton *curPosButton = self.startButton;
    
    
    do {
        
        if ([curPosButton pass]) {//没有通过的路径
            
            curPosButton.path.isPass = YES;//留下足迹
            curPosButton.path.ord = cureStep;
            
            [stack push:curPosButton];//加入路径
            
            if (CGPointEqualToPoint(curPosButton.path.point, self.endButton.path.point)) {
                return YES;//到达终点(出口)
            }
            
            curPosButton = [self nextButtonWithLocalBtn:curPosButton];
            cureStep++;//探索下一步
        }
        else//当前位置不能通过
        {
        
            if (![stack isEmpty]) {
                
                curPosButton = [stack pop];
                
                while (curPosButton.path.nextDireaction == PathDireactionLeftTop + 1 && ![stack isEmpty]) {
                    
                    curPosButton.path.isPass = YES;
                    curPosButton = [stack pop];
                }
                
                if (curPosButton.path.nextDireaction <= PathDireactionLeftTop) {
                    
                    curPosButton.path.nextDireaction ++;
                    [stack push:curPosButton];
                    
                    curPosButton = [self nextButtonWithLocalBtn:curPosButton];
                    
                }
            }
        }
        
    } while (![stack isEmpty]);
    
    return NO;

}

//根据当前按钮寻找下一个按钮
- (WJPathButton *)nextButtonWithLocalBtn:(WJPathButton *)button
{
    Path *path = button.path;
    CGPoint nextPoint = path.point;
    
    if (path.nextDireaction == PathDieactionTop)
    {
        nextPoint.y -= 1;
    
    }
    else if(path.nextDireaction == PathDireactionTopRight)
    {
        nextPoint.y -= 1;
        nextPoint.x += 1;
    }
    else if (path.nextDireaction == PathDieactionRight)
    {
        nextPoint.x += 1;
    
    }
    else if (path.nextDireaction == PathDireactionRightBottom)
    {
        nextPoint.x += 1;
        nextPoint.y += 1;
        
    }
    else if (path.nextDireaction == PathDieactionBottom)
    {
        nextPoint.y += 1;
        
    }
    else if (path.nextDireaction == PathDireactionBottomLeft)
    {
        nextPoint.y += 1;
        nextPoint.x -= 1;
        
    }
    else if (path.nextDireaction == PathDieactionLeft)
    {
        nextPoint.x -= 1;
    }
    else if (path.nextDireaction == PathDireactionLeftTop)
    {
        nextPoint.x -= 1;
        nextPoint.y -= 1;
    }
    
    for (WJPathButton *button in self.allButtons)
    {
        CGPoint buttonPoint = button.path.point;
        
        if (CGPointEqualToPoint(buttonPoint, nextPoint))
        {
            return button;
        }
    }
    return self.wallButton;
}
@end
