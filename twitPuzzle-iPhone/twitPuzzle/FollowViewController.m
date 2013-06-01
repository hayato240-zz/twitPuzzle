//
//  FollowViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "FollowViewController.h"
#import "Friend.h"

@interface FollowViewController ()

@property (strong, nonatomic) NSMutableArray *follows;
@property (retain, nonatomic) NSString *friend_id;
@property (weak, nonatomic) IBOutlet UITableView *followTable;

- (IBAction)followBtn:(id)sender;
@end

@implementation FollowViewController

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
    [self setupFriendship];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupFriendship
{
    
    _follows = [[Friend all:[NSString stringWithFormat:@"%@/friend/follow",SERVER_URL]] mutableCopy];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_follows count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowCell" forIndexPath:indexPath];
    
    UILabel *idLabel=(UILabel *)[cell viewWithTag:1];
    Friend *friendship = _follows[indexPath.row];
    idLabel.text = [NSString stringWithFormat:@"%@ : %@", friendship.user_id, friendship.user_name];
    
    UIButton *buttonl = (UIButton *)[cell viewWithTag:2];
    [buttonl setTitle:@"アンフォロー" forState:UIControlStateNormal];
    [buttonl setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    


//    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", friendship.user_id, friendship.user_name];
    return cell;
}


- (IBAction)followBtn:(id)sender {
    NSIndexPath *indexPath = [_followTableView indexPathForCell:(UITableViewCell*)[[sender superview] superview]];
    Friend *f = _follows[indexPath.row];
    _friend_id = [NSString stringWithFormat:@"%@",f.user_id];

   
    
//    [self httpMethod];
    [Friend httpMethod:@"DELETE" url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/friend/%@", SERVER_URL,_friend_id]] friendID:_friend_id];
    
    [self setupFriendship];
    [_followTable reloadData];
}

/*

-(void)httpMethod
{
    
    NSMutableData *sendData = [NSMutableData data];
    NSString *bound = @"--123456789012345678901234567890";
    
    //nsdata
    
    [sendData appendData:[[NSString stringWithFormat:@"--%@\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]]; // データ単位の開始を表すバウンド
    [sendData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", @"friend[friend_id]"] dataUsingEncoding:NSUTF8StringEncoding]];
    [sendData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *tmpID = [NSString stringWithFormat:@"%@",_friend_id];
    NSLog(@"aaa%@",_friend_id);
    NSData *data_id = [[NSData alloc] initWithData:[tmpID dataUsingEncoding:NSUTF8StringEncoding]];
    [sendData appendData:data_id];
    
    [sendData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // データの終端を表すバウンド（※開始バウンドと異なり、末尾が２つのハイフンになっていることに注意）
    [sendData appendData:[[NSString stringWithFormat:@"--%@--\r\n", bound] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [NSString stringWithFormat:@"%@/friend/$@"]
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:3000/friend/4"]];
    NSData *body = sendData;
    
    [req setHTTPMethod:@"DELETE"];
    [req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [req setTimeoutInterval:10.0];
    [req setHTTPBody:body];
    [req setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", bound] forHTTPHeaderField:@"Content-Type"];
    
    
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
//    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *dataResults = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    if (!dataResults || response.statusCode != 200) {
        NSLog(@"NSURLConnection error:%@ status:%d", error, response.statusCode);
    }
    
}
*/

@end
