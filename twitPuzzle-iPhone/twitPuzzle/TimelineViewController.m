//
//  ViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/17.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//



#import "TimelineViewController.h"
#import "Puzzle.h"
#import "PuzzleDetailViewController.h"
#import "PuzzleNewViewController.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *puzzles;
@property (strong, nonatomic) NSIndexPath *updateIndexPath;
@end

@implementation TimelineViewController{
    UIRefreshControl *_refreshControl;
}



-(void)setupPuzzle
{
    _puzzles = [[NSMutableArray alloc] init];
    _puzzles = [[Puzzle all] mutableCopy];

}

- (void)viewDidLoad
{
    NSLog(@"vidDID");
    [super viewDidLoad];
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self setupPuzzle];
   [self.tableView reloadData];
	    NSLog(@"viDIDAPPEAR");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"--- nuberOfRowInSection %d", [_puzzles count]);
    return [_puzzles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PuzzleCell" forIndexPath:indexPath];
    Puzzle *puzzle = _puzzles[indexPath.row];

//    NSLog(@"----- cellForRowAtIndexPath %d %@", indexPath.row, puzzle);
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",puzzle.tweet];
    UILabel *idLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *idLabel2=(UILabel *)[cell viewWithTag:2];
    UIImageView *puzzleView = (UIImageView *)[cell viewWithTag:3];

    [idLabel setText:[NSString stringWithFormat:@"%@さん : ", puzzle.name]];
    [idLabel2 setText:[NSString stringWithFormat:@"%@", puzzle.tweet]];
    
    NSMutableString *imagePath = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@/puzzles/",SERVER_URL]];
    [imagePath appendString:[NSString stringWithFormat:@"%@/get_image", puzzle.puzzle_id]];
    NSURL *url = [NSURL URLWithString:imagePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    puzzleView.image = [UIImage imageWithData:data];
    NSLog(@"naaaammmeeee:::%@",imagePath);
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"new"]){
        NSLog(@"new");
        PuzzleNewViewController *newViewController = [segue destinationViewController];
        newViewController.puzzle = [Puzzle puzzleWithTweet:@"" puzzle_id:nil image:nil correct_order:nil name:@""];
        _updateIndexPath = [NSIndexPath indexPathForRow:[_puzzles count] inSection:0];
    }
    else{
        PuzzleDetailViewController *detailViewController = [segue destinationViewController];
        _updateIndexPath = _tableView.indexPathForSelectedRow;
        [self.tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
        detailViewController.puzzle = _puzzles[_updateIndexPath.row];
    }
    NSLog(@"-- prepareForSegue %@ %d",[segue identifier], _updateIndexPath.row);

}

-(void)refresh
{    [self setupPuzzle];
    [self.tableView reloadData];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(endRefresh) userInfo:nil repeats:NO];
    NSLog(@"refresh");

}


- (void)endRefresh
{
    NSLog(@"endddd");
    [_refreshControl endRefreshing];
}

@end
