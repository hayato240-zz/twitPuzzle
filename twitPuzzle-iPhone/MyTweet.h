//
//  MyTweet.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/30.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTweet : NSObject
@property (strong, nonatomic) NSString *puzzle_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *tweet;
@property (strong, nonatomic) NSString *correct_order;


+(MyTweet *)mytweetWithPuzzle_id:(NSString *)puzzle_id user_name:(NSString *)user_name tweet:(NSString *)tweet correct_order:(NSString *)correct_order;
+(MyTweet *)tweet;
+ (NSData *)getRequestToURL:(NSString *)url;
+ (NSArray *)all:(NSString *)url;
+ (void)destroyWithID:(NSString *)tweetID;
+ (void)requestPuzzleToURL:(NSString *)url method:(NSString *)method ;
@end
