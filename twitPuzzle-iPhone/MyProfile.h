//
//  MyProfile.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/29.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProfile : NSObject
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *follow_num;
@property (strong, nonatomic) NSString *follower_num;


+(MyProfile *)myprofileWithUser_id:(NSString *)user_id user_name:(NSString *)user_name created_at:(NSString *)created_at follow_num:(NSString *)follow_num follower_num:(NSString*)follower_num;
+(MyProfile *)profile;
+ (NSData *)getRequestToURL:(NSString *)url;
+ (MyProfile *)all:(NSString *)url;

@end

