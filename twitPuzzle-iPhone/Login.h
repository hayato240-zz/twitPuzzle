//
//  Login.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/29.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject
+(NSData *)postWithName:(NSString *) email password:(NSString *)password;
+ (void)logout:(NSString *)user_id;
+ (void)requestLogoutToURL:(NSString *)url method:(NSString *)method;
@end
