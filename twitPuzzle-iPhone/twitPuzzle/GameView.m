//
//  GameView.m
//  twitPuzzle
//
//  Created by Nishimaru Hayato on 13/05/26.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GameView.h"
#import "AppDelegate.h"

@interface GameView()
@property (strong, nonatomic) NSMutableArray *tiles;
@end

@implementation GameView

BOOL *complete;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIImage*)resizedImage:(UIImage *)img size:(CGSize)size
{
    CGFloat widthRatio  = size.width  / img.size.width;
    CGFloat heightRatio = size.height / img.size.height;
    
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    CGSize resizedSize = CGSizeMake(img.size.width*ratio, img.size.height*ratio);
    
    UIGraphicsBeginImageContext(resizedSize);
    
    [img drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (UIImage *)resize:(UIImage *)image
               rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    UIGraphicsEndImageContext();
    return resizedImage;
}



-(void)setTile:(NSMutableArray *)resultImages correct_order:(NSString *)correct_order
{
    _tiles = [[NSMutableArray alloc] init];
    NSArray *puzzleNum = [correct_order componentsSeparatedByString:@","];
    for (int heigh=0; heigh<3; heigh++) {
        for (int width=0;width<3; width++){
            int num = width+heigh*3;
            UIImageView *tileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];

            tileImage.image = [self resize:[resultImages objectAtIndex:width+heigh*3]
                                            rect:CGRectMake(0, 0, 90, 70)];
            
//            tileImage.image = [self resizedImage:[resultImages objectAtIndex:width+heigh*3] size:CGSizeMake(90, 90)];
            CGRect r = CGRectZero;
            r.size.width = tileImage.image.size.width;
            r.size.height = tileImage.image.size.height;
            CALayer* tile = [CALayer layer];
            
            tile.frame = CGRectMake(15+(r.size.width*width+5*width), 70+(r.size.height*heigh+5*heigh), r.size.width, r.size.height);
            tile.name = puzzleNum[num];
            tile.contents = (id)tileImage.image.CGImage;
            [_tiles addObject:tile];
            [self.layer addSublayer:tile];
            
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    [self.layer convertPoint:pt toLayer:self.layer.superlayer];
    CALayer* tile = [self.layer hitTest:pt];

    if (tile == nil) {
        return;
    }
    if(tile.name == NULL){
        return;
    }
    if (fromTile) {
        if (fromTile == tile) {
            fromTile.frame = CGRectOffset(fromTile.frame, 20, 20);
            fromTile = nil;
            return;
        }
        [self swapTile:tile];


        return;
    }
    tile.frame = CGRectOffset(tile.frame, -20, -20);
    fromTile = tile;
}

-(void)swapTile:(CALayer*)tile
{
    NSLog(@"swap::");
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        id col =  tile.contents;
        NSString *name = tile.name;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        tile.contents = fromTile.contents;
        tile.name = fromTile.name;
        
        fromTile.contents = col;
        fromTile.name = name;
        [CATransaction commit];
        
        fromTile.frame = CGRectOffset(fromTile.frame, 20, 20);
        fromTile = nil;
        if([self checkOrder]){
            complete = FALSE;
            AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
            delegate.puzzleFlag = [[NSNumber alloc] initWithBool:NO];
        }
        
    }];

    CABasicAnimation* move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.toValue = [NSValue valueWithCGPoint:tile.position];
    [fromTile addAnimation:move forKey:@"move"];

    move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.toValue = [NSValue valueWithCGPoint:fromTile.position];
    [tile addAnimation:move forKey:@"move"];
    [CATransaction commit];
    NSLog(@"swapEnd:");


}

-(BOOL)checkOrder
{
    NSMutableString *orderStr = [NSMutableString string];
    for(int i=0;i<9;i++){
        CALayer *tile = [_tiles objectAtIndex:i];
        NSLog(@"order::%@",tile.name);
        [orderStr appendString:tile.name];
    }
    if([orderStr isEqualToString:@"123456789"])
        return TRUE;
    else
        return FALSE;
        
}

@end
