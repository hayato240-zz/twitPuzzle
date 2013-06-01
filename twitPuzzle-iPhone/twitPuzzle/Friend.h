//
//  Friend.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *friend_state;


+(Friend *)friendWithUser_id:(NSString *)user_id user_name:(NSString *)user_name  friend_state:(NSString *)friend_state;
+ (NSData *)getRequestToURL:(NSString *)url;
+(void)httpMethod:(NSString *)method url:(NSURL *)nsUrl friendID:(NSString *)friend_id;
+ (NSArray *)all:(NSString *)url;

@end
