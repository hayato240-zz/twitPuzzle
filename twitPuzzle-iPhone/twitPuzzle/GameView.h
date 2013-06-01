//
//  GameView.h
//  twitPuzzle
//
//  Created by Nishimaru Hayato on 13/05/26.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameView : UIView{
    CALayer*    fromTile;
}


-(void)setTile:(NSMutableArray *)resultImages correct_order:(NSString *)correct_order;
@end
