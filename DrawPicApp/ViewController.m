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

@interface ViewController ()<menuDidSelectedDelegate>
@property (strong, nonatomic) IBOutlet ACEDrawingView *drawingView;

@end

@implementation ViewController{
    KYGooeyMenu *gooeyMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gooeyMenu = [[KYGooeyMenu alloc]initWithOrigin:CGPointMake(CGRectGetMidX(self.view.frame)-50, 600) andDiameter:100.0f andDelegate:self themeColor:[UIColor cyanColor]];
    gooeyMenu.menuDelegate = self;
    gooeyMenu.radius = 100/4;//大圆的1/4
    gooeyMenu.extraDistance = 20;
    gooeyMenu.MenuCount = 3;
    gooeyMenu.menuImagesArray =  [NSMutableArray arrayWithObjects:
                                 [UIImage imageNamed:@"arrow_carrot-2right"],
                                 [UIImage imageNamed:@"icon_pens"],
                                 [UIImage imageNamed:@"arrow_carrot-2left"],nil];
    
}

-(void)menuDidSelected:(int)index{
    switch (index) {
        case 1:
            [self.drawingView redoLatestStep];
            break;
            
        case 2:
            
            break;
        case 3:
            [self.drawingView undoLatestStep];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
