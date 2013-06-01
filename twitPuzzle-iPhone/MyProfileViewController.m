//
//  MyProfileViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/29.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfile.h"
#import "MyTweet.h"
#import "Login.h"
#import "PuzzleDetailViewController.h"
#import "Puzzle.h"

@interface MyProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *user_id;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *created_at;
@property (strong, nonatomic) MyProfile *profiles;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *myTweetTable;
@property (strong, nonatomic) NSIndexPath *updateIndexPath;
- (IBAction)logoutBtn:(id)sender;


@end

@implementation MyProfileViewController

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

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_myTweetTable setEditing:editing animated:animated];
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSLog(@"-- commitEditingStyle %d", indexPath.row);
        //DELETE
        MyTweet *mytweet = _tweets[indexPath.row];
        [MyTweet destroyWithID:mytweet.puzzle_id];
        [self setTableItems];
        [_myTweetTable reloadData];
        
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{

    [self setTableItems];
    [_myTweetTable reloadData];
    
}


-(void)setTableItems
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _profiles = [MyProfile all:[NSString stringWithFormat:@"%@/users/profile/self.json",SERVER_URL]];
    NSString *my_id = [NSString stringWithFormat:@"%@",_profiles.user_id];
    NSString *tweetPath = [NSString stringWithFormat:@"/puzzles/user/%@.json",my_id];
    _tweets = [[MyTweet all:[SERVER_URL stringByAppendingString:tweetPath]] mutableCopy] ;
    
    _user_id.text = [NSString stringWithFormat:@"%@", _profiles.user_id];
    _user_name.text = _profiles.user_name;
    _created_at.text = [_profiles.created_at substringToIndex:10];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tweets count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTweet" forIndexPath:indexPath];
    MyTweet *mytweet = _tweets[indexPath.row];
    
    UILabel *idLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *idLabel2=(UILabel *)[cell viewWithTag:2];
    UIImageView *puzzleView = (UIImageView *)[cell viewWithTag:3];
    idLabel.text = [NSString stringWithFormat:@"%@さん :", mytweet.user_name];
    idLabel2.text = [NSString stringWithFormat:@"%@", mytweet.tweet];
    
    NSMutableString *imagePath = [NSMutableString stringWithString:SERVER_URL];
    [imagePath appendString:[NSString stringWithFormat:@"/puzzles/%@/get_image", mytweet.puzzle_id]];
    
    //画像URLからUIImageを生成
    NSURL *url = [NSURL URLWithString:imagePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    puzzleView.image = [UIImage imageWithData:data];
    NSLog(@"URL::%@",imagePath);
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    _updateIndexPath = _myTweetTable.indexPathForSelectedRow;
    NSLog(@"aiueo::%d",_updateIndexPath.row);
    MyTweet *tweet = _tweets[_updateIndexPath.row];
    
    Puzzle *puzzle = [Puzzle puzzleWithTweet:tweet.tweet puzzle_id:[NSString stringWithFormat:@"%@",tweet.puzzle_id] image:nil correct_order:tweet.correct_order name:tweet.user_name];
    
    PuzzleDetailViewController *detailViewController = [segue destinationViewController];
    [_myTweetTable deselectRowAtIndexPath:_myTweetTable.indexPathForSelectedRow animated:YES];
    detailViewController.puzzle = puzzle;
    
}



- (IBAction)logoutBtn:(id)sender {
    NSString *user_id = [NSString stringWithFormat:@"%@",_profiles.user_id];
    [Login logout:user_id];
    UINavigationController *timelineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:timelineVC animated:NO completion:nil];
}
@end
