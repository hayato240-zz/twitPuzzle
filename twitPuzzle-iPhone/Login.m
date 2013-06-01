//
//  Login.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/29.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "Login.h"


@implementation Login


+(NSData *)postWithName:(NSString *) email password:(NSString *)password
{
   
    NSString *url = [NSString stringWithFormat:@"%@/logins.json",SERVER_URL];
    NSString *postString;
    NSMutableURLRequest *request;
    
    // POSTパラメーターを設定
    NSString *loginData = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@", email, password];
    //    NSString *param = @"user[email=%@&password=%@]";
    postString = [NSString stringWithFormat:@"%@", loginData];
    
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    [request setURL:[NSURL URLWithString:url] ];
    [request setTimeoutInterval:20];
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    return data;
}

+ (void)logout:(NSString *)user_id {
    [self requestLogoutToURL:[NSString stringWithFormat:@"/%@/logins/%@.json", SERVER_URL, user_id] method:@"DELETE"];
}

+ (void)requestLogoutToURL:(NSString *)url method:(NSString *)method {
    NSLog(@"--- requestTodoToURL: %@ %@", url, method);
    
    NSError *error = nil;

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!responseData || (response.statusCode != 201 && response.statusCode != 204)) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }    
}
@end
