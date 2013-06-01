//
//  PuzzleDetailViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/20.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "PuzzleDetailViewController.h"
#import "PuzzleGameViewController.h"

@interface PuzzleDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *puzzleImage;
@property (strong, nonatomic) NSMutableArray *rankings;


@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *firstTime;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *secondTime;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;
@property (weak, nonatomic) IBOutlet UILabel *thirdTime;

@end

@implementation PuzzleDetailViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tweet.text = _puzzle.tweet;
    

    
    
    NSMutableString *imagePath = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@/puzzles/",SERVER_URL]];
    [imagePath appendString:[NSString stringWithFormat:@"%@/get_image", _puzzle.puzzle_id]];
    
    //画像URLからUIImageを生成
    NSURL *url = [NSURL URLWithString:imagePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _puzzleImage.image = [UIImage imageWithData:data];
    _rankings = [[Ranking all:_puzzle.puzzle_id] mutableCopy];
    NSLog(@"aaaaaaaaaaaa%d",[_rankings count]);
    
    if([_rankings count]>0){
        Ranking *firstR = _rankings[0];

        _firstName.text = [NSString stringWithFormat:@"%@さん",firstR.user_name];
        _firstTime.text = [NSString stringWithFormat:@"%@秒",[firstR.complete_time stringValue]] ;
    }
    if([_rankings count]>1){
        Ranking *secondR = _rankings[1];
        _secondName.text = [NSString stringWithFormat:@"%@さん", secondR.user_name];
        _secondTime.text = [NSString stringWithFormat:@"%@秒",[secondR.complete_time stringValue]];
    }
    if([_rankings count]>2){
        Ranking *thirdR = _rankings[2];
        _thirdName.text = [NSString stringWithFormat:@"%@さん",thirdR.user_name];
        _thirdTime.text = [NSString stringWithFormat:@"%@秒",[thirdR.complete_time stringValue]];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PuzzleGameViewController *gameViewController = [segue destinationViewController];
    gameViewController.puzzle = _puzzle;
}

@end
