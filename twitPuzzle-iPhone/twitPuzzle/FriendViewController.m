//
//  FriendViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/27.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "FriendViewController.h"
#import "SearchViewController.h"
#import "Friend.h"


@interface FriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name_field;
@property (strong, nonatomic) NSMutableArray *follow;
@property (strong, nonatomic) NSMutableArray *follower;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;

@end

@implementation FriendViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{

    _follow = [[Friend all:[NSString stringWithFormat:@"%@/friend/follow",SERVER_URL]] mutableCopy];
    _follower = [[Friend all:[NSString stringWithFormat:@"%@/friend/follower",SERVER_URL]] mutableCopy];
    
    [_followBtn setTitle:[[NSString alloc] initWithFormat:@"%d人",[_follow count]] forState:UIControlStateNormal];
    [_followerBtn setTitle:[[NSString alloc] initWithFormat:@"%d人",[_follower count]] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"search"]) {
        NSLog(@"new");
        SearchViewController *searchViewController = [segue destinationViewController];
        searchViewController.user_name = _name_field.text;
    }


}


@end
