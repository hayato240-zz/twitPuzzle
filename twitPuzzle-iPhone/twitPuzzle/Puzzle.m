//
//  Puzzle.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/17.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "Puzzle.h"
@implementation Puzzle
#define DVICOUNT 3
#define PUZZLENUM 9

+(Puzzle *)puzzleWithTweet:(NSString *)tweet puzzle_id:(NSNumber *)puzzle_id image:(NSData *)image correct_order:(NSString *)correct_order name:(NSString *)name
{
    Puzzle *puzzle = [[Puzzle alloc] init];
    
    puzzle.tweet = tweet;
    puzzle.puzzle_id = puzzle_id;
    puzzle.image = image;
    puzzle.correct_order = correct_order;
    puzzle.name = name;


    return puzzle;
}

+(Puzzle *)puzzle
{
    return [Puzzle puzzleWithTweet:@"" puzzle_id:nil image:nil correct_order:nil name:@""];
}



-(NSString *)description
{
    return [NSString stringWithFormat:@"< Tweet id:%@ tweet:%@ image:%@ >", _puzzle_id, _tweet, _image];
    
}

+ (NSArray *)all {
    NSData *data = [self getRequestToURL:[NSString stringWithFormat:@"%@/puzzles.json", SERVER_URL]];
    if (!data) {
        return @[];
    }
//    NSString *str= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"data:::::%@", str);
    NSError *error = nil;
    NSArray *puzzleDictionaryArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!puzzleDictionaryArray) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return @[];
    }
    NSMutableArray *puzzles = [NSMutableArray array];
    for (NSDictionary *dictionary in puzzleDictionaryArray) {
        Puzzle *puzzle = [Puzzle puzzleWithTweet:dictionary[@"tweet"]
                                puzzle_id:dictionary[@"id"]
                                image:dictionary[@"image"]
                                correct_order:dictionary[@"correct_order"]
                                name:dictionary[@"name"]
                          ];
        [puzzles addObject:puzzle];
    }
    
//    NSLog(@"--- all %@", puzzles);
    return puzzles;
}

- (void)save {
    NSLog(@"--- save %@ %@", _puzzle_id, _tweet);
    
    if (_puzzle_id) {
        [self requestPuzzleToURL:[NSString stringWithFormat:@"%@/puzzles/%@.json", SERVER_URL, _puzzle_id] method:@"PUT"];
    } else {
        NSLog(@"save not id");
        [self requestPuzzleToURL:[NSString stringWithFormat:@"%@/puzzles.json", SERVER_URL] method:@"POST"];
    }
}

- (void)destroy {
    NSLog(@"--- destroy %@ %@", _puzzle_id, _tweet);
    [self requestPuzzleToURL:[NSString stringWithFormat:@"%@/puzzles/%@.json", SERVER_URL, _puzzle_id] method:@"DELETE"];
}

- (void)requestPuzzleToURL:(NSString *)url method:(NSString *)method {
    NSLog(@"--- requestPuzzleToURL: %@ %@", url, method);
    
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:
                           @{@"puzzle": @{@"image" : _image, @"tweet" : _tweet}}
                                                          options:0 error:&error];
    if (!requestData) {
        NSLog(@"NSJSONSerialization error:%@ ", error);
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!responseData || (response.statusCode != 201 && response.statusCode != 204)) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }           
}

- (NSString *)stringFromDate:(NSDate *)d {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat stringFromDate:d];
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

+ (NSDate *)dateFromString:(NSString *)s {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormat dateFromString:s];
}

+ (NSMutableArray *)divImage:(UIImage *)image
{
    NSLog(@"ref::%@",image);
    CGImageRef srcImageRef = [image CGImage];
    
    CGFloat blockWith = image.size.width / 3.0;
    CGFloat blockHeight = image.size.height / 3.0;
    
    NSMutableArray *divImages = [[NSMutableArray alloc] init];
    
    for (int heightCount=0; heightCount < DVICOUNT; heightCount++) {
        for(int widthCount=0; widthCount < DVICOUNT; widthCount++){
            CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, CGRectMake(widthCount                                                                               *blockWith, heightCount*blockHeight, blockWith, blockHeight));
            UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef];
            [divImages addObject:trimmedImage];
        }
    }
    return divImages;
}


@end
