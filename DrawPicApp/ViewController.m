//
//  ViewController.m
//  DrawPicApp
//
//  Created by 野村和也 on 2015/08/14.
//  Copyright (c) 2015年 野村和也. All rights reserved.
//

#import "ViewController.h"
#import "KYGooeyMenu.h"
#import "ACEDrawingView.h"
#import "XXXRoundMenuButton.h"


@interface ViewController ()<menuDidSelectedDelegate>
@property (strong, nonatomic) IBOutlet ACEDrawingView *drawingView;
@property (strong, nonatomic) IBOutlet XXXRoundMenuButton *roundMenu;

@end

@implementation ViewController{
    KYGooeyMenu *gooeyMenu;
    UIColor *usrClr;
    NSArray *colorArray;
    int clrCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gooeyMenu = [[KYGooeyMenu alloc]initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-50, 600) andDiameter:100.0f andDelegate:self themeColor:[UIColor cyanColor]];
    gooeyMenu.menuDelegate = self;
    gooeyMenu.radius = 100/4;//大圆的1/4
    gooeyMenu.extraDistance = 20;
    gooeyMenu.MenuCount = 4;
    gooeyMenu.menuImagesArray =  [NSMutableArray arrayWithObjects:
                                  [UIImage imageNamed:@"playback_ff_icon"],
                                  [UIImage imageNamed:@"pencil_icon"],
                                  [UIImage imageNamed:@"doc_new_icon"],
                                  [UIImage imageNamed:@"playback_rew_icon"],nil];

    [self setColor];
    clrCount=2;
    usrClr=colorArray[clrCount];
    self.drawingView.lineColor =usrClr;
    [self setupMenu];
    
}

-(void)menuDidSelected:(int)index{
    switch (index) {
        case 1:
            [self.drawingView redoLatestStep];
            break;
        case 2:
            
        case 3:
            [self.drawingView clear];
            break;
        case 4:
            [self.drawingView undoLatestStep];

    }
}

- (void)setupMenu{
    [self.roundMenu loadButtonWithIcons:@[[UIImage imageNamed:@"playback_ff_icon"],
                                          [UIImage imageNamed:@"playback_rew_icon"],
                                           ] startDegree:-M_PI layoutDegree:M_PI/2];
    [self.roundMenu setButtonClickBlock:^(NSInteger idx) {
        
        switch (idx) {
            case 0:
                clrCount=(clrCount+1)%13;
                usrClr=colorArray[clrCount];
                self.roundMenu.mainColor = usrClr;
                self.drawingView.lineColor = usrClr;
                break;
                
            case 1:
                clrCount=(clrCount-1)%13;
                if(clrCount==-1){clrCount=12;}
                NSLog(@"%d",clrCount);
                usrClr=colorArray[clrCount];
                self.roundMenu.mainColor = usrClr;
                self.drawingView.lineColor = usrClr;
            default:
                break;
        }
    }];
    
    [self.roundMenu setCenterIcon:[UIImage imageNamed:@"icon_pos"]];
    [self.roundMenu setCenterIconType:XXXIconTypeCustomImage];
    
    self.roundMenu.tintColor = [UIColor whiteColor];
    
    self.roundMenu.mainColor = usrClr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setColor{
    UIColor *c01 = [UIColor blackColor];
    UIColor *c02 = [UIColor darkGrayColor];
    UIColor *c03 = [UIColor lightGrayColor];
    UIColor *c04 = [UIColor grayColor];
    UIColor *c05 = [UIColor redColor];
    UIColor *c06 = [UIColor greenColor];
    UIColor *c07 = [UIColor blueColor];
    UIColor *c08 = [UIColor cyanColor];
    UIColor *c09 = [UIColor yellowColor];
    UIColor *c10 = [UIColor magentaColor];
    UIColor *c11 = [UIColor orangeColor];
    UIColor *c12 = [UIColor purpleColor];
    UIColor *c13 = [UIColor brownColor];
    colorArray = [NSArray arrayWithObjects:c01, c02, c03, c04, c05, c06, c07, c08, c09, c10, c11, c12, c13, nil];
}


@end
