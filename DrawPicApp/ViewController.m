//
//  ViewController.m
//  DrawPicApp
//
//  Created by 野村和也 on 2015/08/14.
//  Copyright (c) 2015年 野村和也. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIBezierPath *bezierPath;
    UIImage *lastDrawImage;
    NSMutableArray *undoStack;
    NSMutableArray *redoStack;
    CGPoint sizePoint;
    float usrwd;
    int flag;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    undoStack = [NSMutableArray array];
    redoStack = [NSMutableArray array];
    
    //テキストフィールドのサブビューを追加。入れ替え。
    CGRect rect = [[UIScreen mainScreen] bounds];
    UITextField *text1 = [[UITextField alloc] init];
    text1.frame = CGRectMake(0 ,0 ,rect.size.width ,rect.size.height/2);
    text1.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:text1];
    [self.view sendSubviewToBack: text1];
    NSLog(@"text1 is %@", NSStringFromClass([text1 class]));
    NSLog(@"self.view is %@", NSStringFromClass([self.view class]));
    
    int i=0;
    /*for(i=0;i<self.view.subviews.count;i++){
        NSLog(@"subview[%d] is %@",i, NSStringFromClass([self.view.subviews[i] class]));
    }*/
    
    // ボタンのenabledを設定します
    self.undoButton.enabled = NO;
    self.redoButton.enabled = NO;
    self.drawButton.enabled = NO;
    
    usrwd=5.00;
    flag=1;
    self.changeLabel.userInteractionEnabled=NO;
    self.canvas.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)undoButtonPlessed:(id)sender {
    // undoスタックからパスを取り出しredoスタックに追加します。
    UIBezierPath *undoPath = undoStack.lastObject;
    [undoStack removeLastObject];
    [redoStack addObject:undoPath];
    
    // 画面をクリアします。
    lastDrawImage = nil;
    self.canvas.image = nil;
    
    // 画面にパスを描画します。
    for (UIBezierPath *path in undoStack) {
        [self drawLine:path];
        lastDrawImage = self.canvas.image;
    }
    
    // ボタンのenabledを設定します。
    self.undoButton.enabled = (undoStack.count > 0);
    self.redoButton.enabled = YES;
}
- (IBAction)redoButtonPlessed:(id)sender {
    UIBezierPath *redoPath = redoStack.lastObject;
    [redoStack removeLastObject];
    [undoStack addObject:redoPath];
    
    // 画面にパスを描画します。
    [self drawLine:redoPath];
    lastDrawImage = self.canvas.image;
    
    // ボタンのenabledを設定します。
    self.undoButton.enabled = YES;
    self.redoButton.enabled = (redoStack.count > 0);

}
- (IBAction)clearButtonPlessed:(id)sender {
    // 保持しているパスを全部削除します。
    [undoStack removeAllObjects];
    [redoStack removeAllObjects];
    
    // 画面をクリアします。
    lastDrawImage = nil;
    self.canvas.image = nil;
    
    // ボタンのenabledを設定します。
    self.undoButton.enabled = NO;
    self.redoButton.enabled = NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    //サイズ変更
    if(CGRectContainsPoint(self.changeLabel.frame, currentPoint)){
        flag=0;
        sizePoint=currentPoint;
        NSLog(@"サイズ変更オン");
    }
    

    
    // ボタン上の場合は処理を終了します。
    if (CGRectContainsPoint(self.undoButton.frame, currentPoint)
        || CGRectContainsPoint(self.redoButton.frame, currentPoint)
        || CGRectContainsPoint(self.clearButton.frame, currentPoint)
        || CGRectContainsPoint(self.changeLabel.frame, currentPoint)
        || CGRectContainsPoint(self.drawButton.frame, currentPoint)){
        return;
    }
    
    // パスを初期化します。
    bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineWidth = 4.0;
    [bezierPath moveToPoint:currentPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    //太さ変更
    if(flag==0){
        usrwd+=(sizePoint.y-currentPoint.y)/100.0;
        if (usrwd<0.1) usrwd=0.1;
    }
    // タッチ開始時にパスを初期化していない場合は処理を終了します。
    if (bezierPath == nil){
        return;
    }
    // パスにポイントを追加します。
    [bezierPath addLineToPoint:currentPoint];
    
    // 線を描画します。
    [self drawLine:bezierPath];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチした座標を取得します。
    CGPoint currentPoint = [[touches anyObject] locationInView:self.canvas];
    //太さ変更
    if(flag==0&&usrwd>0.1){
        usrwd+=( sizePoint.y-currentPoint.y )/ 100.0;
        if (usrwd<0.1) usrwd=0.1;
        flag=1;
        NSLog(@"サイズ変更オフ");
    }
    // タッチ開始時にパスを初期化していない場合は処理を終了します。
    if (bezierPath == nil){
        return;
    }
    // パスにポイントを追加します。
    [bezierPath addLineToPoint:currentPoint];
    
    // 線を描画します。
    [self drawLine:bezierPath];
    
    // 今回描画した画像を保持します。
    lastDrawImage = self.canvas.image;
    
    // undo用にパスを保持して、redoスタックをクリアします。
    [undoStack addObject:bezierPath];
    [redoStack removeAllObjects];
    bezierPath = nil;
    
    // ボタンのenabledを設定します。
    self.undoButton.enabled = YES;
    self.redoButton.enabled = NO;
}
- (void)drawLine:(UIBezierPath*)path
{
    // 非表示の描画領域を生成します。
    UIGraphicsBeginImageContext(self.canvas.frame.size);
    
    // 描画領域に、前回までに描画した画像を、描画します。
    [lastDrawImage drawAtPoint:CGPointZero];
    
    // 色をセットします。
    [[UIColor blackColor] setStroke];
    
    //太さ
    path.lineWidth=usrwd;
    
    // 線を引きます。
    [path stroke];
    
    // 描画した画像をcanvasにセットして、画面に表示します。
    self.canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画を終了します。
    UIGraphicsEndImageContext();
}
//subviewの入れ替えなどで絵画モードとテキストモードの切り替え
- (IBAction)pDrawButton:(id)sender {
   [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    int i=0;
    for(i=0;i<self.view.subviews.count;i++){
        NSLog(@"subview[%d] is %@",i, NSStringFromClass([self.view.subviews[i] class]));
    }
    self.drawButton.enabled=NO;
    self.textButton.enabled=YES;
}
- (IBAction)pTextButton:(id)sender {
    UITextField *text1=[self.view.subviews objectAtIndex:0];
    NSLog(@"text1 is %@", NSStringFromClass([text1 class]));
    NSLog(@"self.view is %@", NSStringFromClass([self.view class]));
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    int i=0;
    for(i=0;i<self.view.subviews.count;i++){
        NSLog(@"subview[%d] is %@",i, NSStringFromClass([self.view.subviews[i] class]));
    }
    self.drawButton.enabled=YES;
    self.textButton.enabled=NO;
}


@end
