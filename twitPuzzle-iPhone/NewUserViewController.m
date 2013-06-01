//
//  NewUserViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/29.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "NewUserViewController.h"
#import "Login.h"

@interface NewUserViewController ()
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation NewUserViewController

-(BOOL) textFieldShouldReturn:(UITextField *)textField
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {

    [self requestTodoToURL:[NSString stringWithFormat:@"%@/users.json", SERVER_URL] method:@"POST"];
    
}



- (void)requestTodoToURL:(NSString *)url method:(NSString *)method {
    NSLog(@"--- requestTodoToURL: %@ %@", url, method);
    
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:
                           @{@"user": @{@"name" : _name.text, @"email" : _email.text, @"password": _password.text}}
                                                          options:0 error:&error];
    if (!requestData) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!responseData || (response.statusCode != 201 && response.statusCode != 204)) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登録失敗"
                                                        message:@"ユーザ登録に失敗しました。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        NSData *loginCheck = [Login postWithName:_email.text password:_password.text];
        NSString *str= [[NSString alloc] initWithData:loginCheck encoding:NSUTF8StringEncoding];
        NSLog(@"%@ = %@",str, @"true");
        
        if ([str isEqualToString:@"false"]){
            NSLog(@"false");
        }
        else{
            
            UINavigationController *timelineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"rootView"];
            [self presentViewController:timelineVC animated:YES completion:nil];
        }

    }

}



-(void)post
{
    NSMutableData *postData = [NSMutableData data];
    NSString *bound = @"--123456789012345678901234567890";
    
    
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"user[name]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[_name.text dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa::::%@",_puzzle.correct_order );
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"user[email]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[_email.text dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa::::%@",_puzzle.correct_order );
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"user[password]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[_password.text dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    

    // データの終端を表すバウンド（※開始バウンドと異なり、末尾が２つのハイフンになっていることに注意）
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURL *nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users",SERVER_URL]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:nsUrl];
    NSData *body = postData;
    
    
    [req setHTTPMethod:@"POST"];
    [req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [req setTimeoutInterval:10.0];
    [req setHTTPBody:body];
    [req setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", bound] forHTTPHeaderField:@"Content-Type"];
    
    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
//    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];

    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *dataResults = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    if (!dataResults || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    
}


@end
