//
//  PuzzleGameViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/23.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "PuzzleGameViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GameView.h"
#import "AppDelegate.h"

#define GROW_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.
#define TILES 9

@interface PuzzleGameViewController ()
@property (readwrite) int touchImageNumber;
- (IBAction)startBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) GameView *gameView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn_outlet;
@property BOOL myBoolValue;
@property (strong, nonatomic) NSMutableArray *resultImages2;
@end

@implementation PuzzleGameViewController
NSDate *startDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTile
{

    
    
    
    NSMutableString *imagePath = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@/puzzles/",SERVER_URL]];
    [imagePath appendString:[NSString stringWithFormat:@"%@/get_image", _puzzle.puzzle_id]];
    
    //画像URLからUIImageを生成
    NSURL *url = [NSURL URLWithString:imagePath];
    NSData
    *data = [NSData dataWithContentsOfURL:url];
    //    _image1.image = [UIImage imageWithData:data];
    
    NSMutableArray *resultImages = [Puzzle divImage:[UIImage imageWithData:data]];
    
    _gameView = [[GameView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 360.0)];
    

    
    [self.view addSubview:_gameView];
    [_gameView setTile:resultImages correct_order:_puzzle.correct_order];
    _gameView.userInteractionEnabled = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(cancellBtn)];
    [self setupTile];
   
}

- (IBAction)startBtn:(id)sender {
    _myBoolValue = NO;
    _gameView.userInteractionEnabled = YES;

    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.001)
                                             target:self
                                           selector:@selector(onTimer:)
                                           userInfo:nil repeats:YES];
    startDate = [NSDate date];
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.puzzleFlag = [[NSNumber alloc] initWithBool:YES];
    _startBtn_outlet.alpha = 0.3;
}

- (void) onTimer:(NSTimer*)timer {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];


    if ([delegate.puzzleFlag isEqualToNumber:[[NSNumber alloc] initWithBool:YES]]) {
		NSDate *now = [NSDate date];
		_timeLabel.text = [NSString stringWithFormat:@"%.3f秒", [now timeIntervalSinceDate:startDate]];
	}
    else{
        if(_myBoolValue){
            [timer invalidate];
            return;
        }
            
        [timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"パズル正解"
                              message:@"正解"
                              delegate:self
                              cancelButtonTitle:@"OK！" otherButtonTitles:nil];
        [alert show];
        [self post];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)post
{
    NSMutableData *postData = [NSMutableData data];
    NSString *bound = @"--123456789012345678901234567890";
    
    
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"ranking[puzzle_id]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[_puzzle.puzzle_id stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaa::::%@",_puzzle.correct_order );
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"ranking[complete_time]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[_timeLabel.text dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        // データの終端を表すバウンド（※開始バウンドと異なり、末尾が２つのハイフンになっていることに注意）
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURL *nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/rankings.json",SERVER_URL]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:nsUrl];
    NSData *body = postData;
    
    
    [req setHTTPMethod:@"POST"];
    [req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [req setTimeoutInterval:10.0];
    [req setHTTPBody:body];
    [req setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", bound] forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
}

-(void)cancellBtn
{    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    delegate.puzzleFlag = [[NSNumber alloc] initWithBool:NO];
    _myBoolValue = YES;
    /*
    _gameView.userInteractionEnabled = NO;
     */
    _startBtn_outlet.alpha = 1.0;
    for (UIView *view in [self.view subviews]) {
        NSLog(@"uiview;;;%@",view.class);
        NSString *className = [NSString stringWithFormat:@"%@",view.class];
        if ([className isEqualToString:@"GameView"]) {
              [view removeFromSuperview];
        }
    }
    _timeLabel.text = @"0.00秒";
    [self setupTile];

}

@end
