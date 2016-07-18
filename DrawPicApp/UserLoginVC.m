//
//  UserLoginVC.m
//  DrawPicApp
//
//  Created by  Ryuki Uetsugu on 2016/07/12.
//  Copyright © 2016年 野村和也. All rights reserved.
//

#import "UserLoginVC.h"
#import "NCMB/NCMB.h"

@interface UserLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailAdressTextField;
// Password
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
// errorLabel
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation UserLoginVC

// 画面表示時に実行される
- (void)viewDidLoad {
    [super viewDidLoad];
    // Passwordをセキュリティ入力に設定する
    self.passwordTextField.secureTextEntry = true;
    
}

// Loginボタン押下時の処理
- (IBAction)loginBtn:(UIButton *)sender {
    // キーボードを閉じる
    [self closeKeyboad];
    
    // 入力確認
    if (self.emailAdressTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        self.errorLabel.text = @"未入力の項目があります";
        // TextFieldを空に
        [self cleanTextField];
        
        return;
        
    }
    
    // ユーザー名とパスワードでログイン
    [NCMBUser logInWithUsernameInBackground:self.emailAdressTextField.text password:self.passwordTextField.text block:^(NCMBUser *user, NSError *error) {
        // TextFieldを空に
        [self cleanTextField];
        
        if (error) {
            // ログイン失敗時の処理
            self.errorLabel.text = [NSString stringWithFormat:@"ログインに失敗しました:%ld", error.code];
            NSLog(@"ログインに失敗しました:%ld", error.code);
            
        }else{
            // ログイン成功時の処理
            [self performSegueWithIdentifier:@"login" sender:self];
            NSLog(@"ログインに成功しました:%@", user.objectId);
            
        }
        
    }];
    
    
    
    
//    // ユーザー名とパスワードでログイン
//    [NCMBUser logInWithUsernameInBackground:self.userNameTextField.text password:self.passwordTextField.text block:^(NCMBUser *user, NSError *error) {
//        // TextFieldを空に
//        [self cleanTextField];
//        
//        if (error) {
//            // ログイン失敗時の処理
//            self.errorLabel.text = [NSString stringWithFormat:@"ログインに失敗しました:%ld", error.code];
//            NSLog(@"ログインに失敗しました:%ld", error.code);
//            
//        }else{
//            // ログイン成功時の処理
//            [self performSegueWithIdentifier:@"login" sender:self];
//            NSLog(@"ログインに成功しました:%@", user.objectId);
//            
//        }
//        
//    }];

    
}

// SignUp画面へ遷移
- (IBAction)toSignUp:(UIButton *)sender {
    // TextFieldを空にする
    [self cleanTextField];
    // errorLabelを空に
    [self cleanErrorLabel];
    // キーボードを閉じる
    [self closeKeyboad];
    
    [self performSegueWithIdentifier: @"loginToSignUp" sender: self];
    
}

// 背景タップするとキーボードを隠す
- (IBAction)tapScreen:(UITapGestureRecognizer *)sender {
    [self.view endEditing: YES];
    
}

// TextFieldを空にする
- (void)cleanTextField {
    self.emailAdressTextField.text = @"";
    self.passwordTextField.text = @"";
    
}

// errorLabelを空にする
- (void)cleanErrorLabel {
    self.errorLabel.text =@"";
    
}

// キーボードを閉じる
- (void)closeKeyboad {
    [self.emailAdressTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}

@end
