//
//  MyProfile.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/29.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "MyProfile.h"

@implementation MyProfile

+(MyProfile *)myprofileWithUser_id:(NSString *)user_id user_name:(NSString *)user_name created_at:(NSString *)created_at follow_num:(NSString *)follow_num follower_num:(NSString*)follower_num
{
    MyProfile *my_profile= [[MyProfile alloc] init];
    my_profile.user_id = user_id;
    my_profile.user_name = user_name;
    my_profile.created_at = created_at;
    my_profile.follow_num = follow_num;
    my_profile.follower_num = follower_num;
    return my_profile;
}

+(MyProfile *)profile
{
    return [MyProfile myprofileWithUser_id:@"" user_name:@"" created_at:@"" follow_num:@"" follower_num:@""];
}

+(MyProfile *)all_tweet:(NSString *)url{
    NSData *data = [self getRequestToURL:url];
    if (!data) {
        return nil;
    }
    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:::::%@", str);
    NSError *error = nil;
    NSDictionary *didProfile = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    MyProfile *myprofile = [MyProfile myprofileWithUser_id:didProfile[@"id"]
                                                 user_name:didProfile[@"name"]
                                                created_at:didProfile[@"created_at"]
                                                follow_num:didProfile[@"followNum"]
                                              follower_num:didProfile[@"followerNum"]];
    
    NSLog(@"created_at::%@",myprofile.created_at);
    return myprofile;

}

+ (MyProfile *)all:(NSString *)url {
    NSData *data = [self getRequestToURL:url];
    if (!data) {
        return nil;
    }
    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:::::%@", str);
    NSError *error = nil;
    NSDictionary *didProfile = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    MyProfile *myprofile = [MyProfile myprofileWithUser_id:didProfile[@"id"]
                                                 user_name:didProfile[@"name"]
                                                created_at:didProfile[@"created_at"]
                                                follow_num:didProfile[@"followNum"]
                                              follower_num:didProfile[@"followerNum"]];

    NSLog(@"created_at::%@",myprofile.created_at);
    return myprofile;
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

@end
