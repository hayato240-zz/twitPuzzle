//
//  NaviViewController.m
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/31.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import "NaviViewController.h"

@interface NaviViewController ()

@end

@implementation NaviViewController

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
    
    self.navigationBar.tintColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
