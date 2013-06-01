//
//  PuzzleNewViewController.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/22.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Puzzle.h"

@interface PuzzleNewViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(strong, nonatomic) Puzzle *puzzle;
@end
