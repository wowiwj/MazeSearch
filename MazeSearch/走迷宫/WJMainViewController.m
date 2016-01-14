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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MazeScollView.contentSize = self.MazeView.bounds.size;
    
    [self MazeView];
    
    
    [self addPathButton];
    
    
    
}


- (void)addPathButton
{
    
    for (int i = 0; i < self.MazeRow; i++) {
        
        for (int j = 0; j < self.MazeCol; j++) {
          
            
            Path *path = [Path pathWithRow:i andCol:j andMazeCol:self.MazeCol];
            
            WJPathButton *pathButton = [WJPathButton pathButtonWithPath:path];
            pathButton.path = path;
            
            [self.MazeView addSubview:pathButton];
            
            pathButton.backgroundColor = [UIColor whiteColor];
            
            [pathButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [self.allButtons addObject:pathButton];
            
            [self setButtonPosition];
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

- (IBAction)searchMazepath
{
    

    [self findPath];
    
    
//    if (![self.stack isEmpty])
//    {
//        self.MazeView.stack = self.stack;
//        
//    }
    
    while (![self.stack isEmpty]) {
            
        WJPathButton *button = [self.stack pop];
            
        if (button == self.startButton || button == self.endButton) {
                continue;
            }
            
        button.backgroundColor = [UIColor blueColor];
            
    }
    
 
}


- (BOOL)findPath
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
