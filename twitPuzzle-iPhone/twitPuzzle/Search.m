//
//  Search.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "Search.h"
@implementation Search

+(Search *)searchWithName:(NSString *)user_name user_id:(NSNumber *)user_id created_at:(NSString *)created_at friend_state:(NSString *)friend_state
{
    Search *search = [[Search alloc] init];
    
    search.user_name = user_name;
    search.user_id = user_id;
    search.created_at = created_at;
    search.friend_state = friend_state;
    
    return search;
}

+(Search *)search
{
    return [Search searchWithName:@"" user_id:nil created_at:nil friend_state:@""];
}


+ (NSArray *)all:(NSString *)search_name {
    NSData *data = [self getRequestToURL:[NSString stringWithFormat:@"%@/users/search/%@.json", SERVER_URL,search_name]];

    if (!data) {
        return @[];
    }
    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:::::%@", str);
    NSError *error = nil;
    NSArray *userDictionaryArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!userDictionaryArray) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return @[];
    }
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *dictionary in userDictionaryArray) {
        Search *user = [Search searchWithName:dictionary[@"name"] user_id:dictionary[@"id"] created_at:dictionary[@"created_at"]
            friend_state:dictionary[@"friendState"] ];
        [users addObject:user];
    }
    return users;
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
