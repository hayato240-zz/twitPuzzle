//
//  Ranking.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/27.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "Ranking.h"
@implementation Ranking

+(Ranking *)rankingWithComplete_time:(NSNumber *)complete_time puzzle_id:(NSNumber *)puzzle_id user_name:(NSString *)user_name
{
    Ranking *ranking = [[Ranking alloc] init];
    
    ranking.complete_time = complete_time;
    ranking.user_name = user_name;
    ranking.puzzle_id = puzzle_id;
    
    return ranking;
}

+(Ranking *)ranking
{
    return [Ranking rankingWithComplete_time:nil puzzle_id:nil user_name:nil];
}


+ (NSArray *)all:(NSNumber *)id {
    NSData *data = [self getRequestToURL:[NSString stringWithFormat:@"%@/rankings/eachRanking/%@.json", SERVER_URL,id]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/rankings/eachRanking/%@.json", SERVER_URL,id]);
    if (!data) {
        return @[];
    }
        NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"data:::::%@", str);
    NSError *error = nil;
    NSArray *puzzleDictionaryArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!puzzleDictionaryArray) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return @[];
    }
    NSMutableArray *rankings = [NSMutableArray array];
    for (NSDictionary *dictionary in puzzleDictionaryArray) {
        Ranking *ranking = [Ranking rankingWithComplete_time:dictionary[@"complete_time"] puzzle_id:dictionary[@"puzzle_id"] user_name:dictionary[@"user_name"]];
        [rankings addObject:ranking];
    }
    return rankings;
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
