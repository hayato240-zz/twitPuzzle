//
//  PuzzleGameViewController.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/23.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"
@class CALayer;

@interface PuzzleGameViewController : UIViewController{
    CALayer*    fromTile;
}
    @property(strong, nonatomic) Puzzle *puzzle;
@end

