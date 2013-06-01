//
//  Friend.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "Friend.h"

@implementation Friend

+(Friend *)friendWithUser_id:(NSString *)user_id user_name:(NSString *)user_name friend_state:(NSString *)friend_state
{
    Friend *friend = [[Friend alloc] init];
    friend.user_id = user_id;
    friend.user_name = user_name;
    friend.friend_state = friend_state;
    return friend;
}

+(Friend *)friend
{
    return [Friend friendWithUser_id:@"" user_name:@"" friend_state:@""];
}


+ (NSArray *)all:(NSString *)url {
    NSData *data = [self getRequestToURL:url];
    if (!data) {
        return @[];
    }
    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:::::%@", str);
    NSError *error = nil;
    NSArray *friendDictionaryArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!friendDictionaryArray) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return @[];
    }
    NSMutableArray *friends = [NSMutableArray array];
    for (NSDictionary *dictionary in friendDictionaryArray) {
        Friend *friend = [Friend friendWithUser_id:dictionary[@"id"] user_name:dictionary[@"name"] friend_state:dictionary[@"friendState"]];

        [friends addObject:friend];
    }
    return friends;
}


+ (NSData *)getRequestToURL:(NSString *)url {
    NSLog(@"--- getRequestToURL: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!data || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    return data;
}

+(void)httpMethod:(NSString *)method url:(NSURL *)nsUrl friendID:(NSString *)friend_id
{
    
    NSMutableData *sendData = [NSMutableData data];
    NSString *bound = @"--123456789012345678901234567890";
    
    
    [sendData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [sendData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"friend[friend_id]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [sendData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"fridddd:%@",friend_id);
//addObject
    [sendData appendData:[friend_id dataUsingEncoding:NSUTF8StringEncoding]];

    [sendData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // データの終端を表すバウンド（※開始バウンドと異なり、末尾が２つのハイフンになっていることに注意）
    [sendData appendData:[[NSString stringWithFormat:@"--%@--\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:nsUrl];
    NSData *body = sendData;
    
    [req setHTTPMethod:method];
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