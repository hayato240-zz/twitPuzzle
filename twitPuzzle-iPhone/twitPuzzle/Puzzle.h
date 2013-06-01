//
//  Puzzle.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/17.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Puzzle : NSObject
@property (strong, nonatomic) NSNumber *puzzle_id;
@property (strong, nonatomic) NSString *tweet;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSString *correct_order;
@property (strong, nonatomic) NSString *name;


+(Puzzle *)puzzleWithTweet:(NSString *)tweet puzzle_id:(NSNumber *)puzzle_id image:(NSData *)image correct_order:(NSString *)correct_order name:(NSString *)name;
+(Puzzle *) puzzle;
+(NSMutableArray *)divImage:(UIImage *)image;

-(NSString *)description;

+(NSArray *) all;
-(void)save;
-(void)destroy;

@end
