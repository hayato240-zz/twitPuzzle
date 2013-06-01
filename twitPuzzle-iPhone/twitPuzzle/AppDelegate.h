//
//  AppDelegate.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/17.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"


@class TimelineViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSNumber *puzzleFlag;

@end
