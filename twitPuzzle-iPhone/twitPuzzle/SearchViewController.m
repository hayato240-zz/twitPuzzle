//
//  SearchViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/27.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "SearchViewController.h"
#import "Search.h"
#import "Friend.h"


@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *id_field;
@property (weak, nonatomic) IBOutlet UILabel *name_field;
@property (weak, nonatomic) IBOutlet UILabel *create_field;
@property (weak, nonatomic) IBOutlet UIButton *followBtnField;
@property (weak, nonatomic) IBOutlet UIButton *unfollowBtnField;

- (IBAction)followBtn:(id)sender;
- (IBAction)unfollowBtn:(id)sender;

@property(strong, nonatomic) Search *search;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSString *friend_id;
@end

@implementation SearchViewController

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
    NSLog(@"name::::%@",_user_name);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"eeeeeeeeeeeeeeeeeeeeeeeee");
    _users = [[Search all:_user_name] mutableCopy];
    
    
    if([_users count] > 0){
        Search *user = _users[0];
        NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        NSLog(@"id:%@ name:%@", user.user_name, user.user_id);
        _friend_id = [user.user_id stringValue];
        _id_field.text = _friend_id;
        _name_field.text = user.user_name;
        _create_field.text = [user.created_at substringToIndex:10];
        [_followBtnField setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_unfollowBtnField setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        if ([user.friend_state isEqualToString:@"フォロー"]) {
            [_unfollowBtnField setEnabled:NO];
            [_followBtnField setEnabled:YES];
            _unfollowBtnField.alpha = 0.3;
            _followBtnField.alpha = 1.0;
        }
        else{
            [_followBtnField setEnabled:NO];
            [_unfollowBtnField setEnabled:YES];
            _followBtnField.alpha = 0.3;
            _unfollowBtnField.alpha = 1.0;
        }
        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No User"
                                                        message:@"ユーザが見つかりませんでした"
                                                       delegate:self
                              
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
    }

}

-(void)viewDidAppear:(BOOL)animated
{
 }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)followBtn:(id)sender {
    
    [Friend httpMethod:@"POST" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/friend",SERVER_URL]] friendID:_friend_id];
    [self viewWillAppear:YES];
}

- (IBAction)unfollowBtn:(id)sender {
    
    NSLog(@"URL::%@",[NSString stringWithFormat:@"%@/friend/%@",SERVER_URL,_friend_id]);
    NSLog(@"userID::%@",_friend_id);
    [Friend httpMethod:@"DELETE" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/friend/%@",SERVER_URL,_friend_id]] friendID:_friend_id];
        [self viewWillAppear:YES];
}
@end
