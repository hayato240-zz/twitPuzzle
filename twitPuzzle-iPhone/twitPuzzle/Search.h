//
//  Search.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSNumber *user_id;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *friend_state;



+(Search *)searchWithName:(NSString *)user_name user_id:(NSNumber *)user_id created_at:(NSDate *)created_at friend_state:(NSString *)friend_state;
+(Search *) search;
+ (NSData *)getRequestToURL:(NSString *)url;

+ (NSArray *)all:(NSString *)search_name;

@end
