//
//  Ranking.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/27.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ranking : NSObject

@property (strong, nonatomic) NSNumber *complete_time;
@property (strong, nonatomic) NSNumber *puzzle_id;
@property (strong, nonatomic) NSString *user_name;

+(Ranking *)rankingWithComplete_time:(NSNumber *)complete_time puzzle_id:(NSNumber *)puzzle_id user_name:(NSString *)user_name;
+(Ranking *) ranking;
+ (NSData *)getRequestToURL:(NSString *)url;

+ (NSArray *)all:(NSNumber *)id;

@end
