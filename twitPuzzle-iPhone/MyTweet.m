//
//  MyTweet.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/30.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "MyTweet.h"

@implementation MyTweet

+(MyTweet *)mytweetWithPuzzle_id:(NSString *)puzzle_id user_name:(NSString *)user_name tweet:(NSString *)tweet correct_order:(NSString *)correct_order
{
    MyTweet *my_tweet= [[MyTweet alloc] init];
    my_tweet.tweet = tweet;
    my_tweet.user_name = user_name;
    my_tweet.puzzle_id = puzzle_id;
    my_tweet.correct_order = correct_order;
    return my_tweet;
}

+(MyTweet *)tweet
{
    return [MyTweet mytweetWithPuzzle_id:@"" user_name:@"" tweet:@"" correct_order:@""];
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
    NSMutableArray *mytweets = [NSMutableArray array];
    for (NSDictionary *dicTweet in friendDictionaryArray) {
        MyTweet *mytweet = [MyTweet mytweetWithPuzzle_id:dicTweet[@"id"] user_name:dicTweet[@"name"] tweet:dicTweet[@"tweet"] correct_order:dicTweet[@"correct_order"]];
        [mytweets addObject:mytweet];
    }
    return mytweets;
}

+ (void)destroyWithID:(NSString *)tweetID {
    [self requestPuzzleToURL:[NSString stringWithFormat:@"%@/puzzles/%@.json", SERVER_URL, tweetID] method:@"DELETE"];
}

+ (void)requestPuzzleToURL:(NSString *)url method:(NSString *)method {
    NSLog(@"--- requestTodoToURL: %@ %@", url, method);
    
    NSError *error = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:requestData];
    
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!responseData || (response.statusCode != 201 && response.statusCode != 204)) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }    
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
