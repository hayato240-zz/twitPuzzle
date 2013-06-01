//
//  LoginViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/20.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "Puzzle.h"
#import "Login.h"


@interface LoginViewController ()
- (IBAction)loginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation LoginViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logo.image = [UIImage imageNamed:@"logo.png"];
    //    _email.text = @"shimada@puzzle.com";
//    _password.text= @"shimada";

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(id)sender {
    NSData *loginCheck = [Login postWithName:_email.text password:_password.text];
    NSString *str= [[NSString alloc] initWithData:loginCheck encoding:NSUTF8StringEncoding];
    NSLog(@"%@ = %@",str, @"true");

    if ([str isEqualToString:@"false"]){
        NSLog(@"false");
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"ログイン失敗"
                              message:@"IDとパスワードを確認してみてください"
                              delegate:self
                              cancelButtonTitle:@"OK！" otherButtonTitles:nil];
        [alert show];
        
    }
    else{

        UINavigationController *timelineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootView"];
        [self presentViewController:timelineVC animated:YES completion:nil];
    }
}

@end
