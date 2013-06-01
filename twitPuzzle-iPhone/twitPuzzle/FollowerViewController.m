//
//  FollowerViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "FollowerViewController.h"
#import "Friend.h"

@interface FollowerViewController ()
- (IBAction)followerBtn:(id)sender;
@property (strong, nonatomic) NSMutableArray *follower;
@property (weak, nonatomic) IBOutlet UITableView *followerTable;

@property (strong, nonatomic) NSString *friend_id;
@end

@implementation FollowerViewController

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
-(void)viewWillAppear:(BOOL)animated
{
    [self setupFriendship];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupFriendship
{
    
    _follower = [[Friend all:[NSString stringWithFormat:@"%@/friend/follower",SERVER_URL]] mutableCopy];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_follower count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];
    
    UILabel *idLabel=(UILabel *)[cell viewWithTag:1];
    UIButton *buttonl = (UIButton *)[cell viewWithTag:2];

    Friend *friendship = _follower[indexPath.row];
    idLabel.text = [NSString stringWithFormat:@"%@ : %@", friendship.user_id, friendship.user_name];
   NSLog(@"follo;;;;;;;;;;;;;%@",friendship.friend_state);
    [buttonl setTitle:friendship.friend_state forState:UIControlStateNormal];
    if ([friendship.friend_state isEqualToString:@"フォロー"]) {
        [buttonl setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    else{
        [buttonl setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

    return cell;
}

- (IBAction)followerBtn:(id)sender {
    NSIndexPath *indexPath = [_followerTableController indexPathForCell:(UITableViewCell*)[[sender superview] superview]];
    NSLog(@"aaaaaaaa%@",indexPath);
    Friend *f = _follower[indexPath.row];
    _friend_id = [NSString stringWithFormat:@"%@",f.user_id];
    
    if ([f.friend_state isEqualToString:@"フォロー"]) {
        
        [Friend httpMethod:@"POST" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/friend",SERVER_URL]] friendID:_friend_id];
    }
    else{

        [Friend httpMethod:@"DELETE" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/friend/%@",SERVER_URL,_friend_id]] friendID:_friend_id];
    }

    [self setupFriendship];
    [_followerTable reloadData];
}
@end
