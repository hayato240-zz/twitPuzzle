//
//  FollowerViewController.h
//  twitPuzzle
//
//  Created by nishimaru hayato on 2013/05/28.
//  Copyright (c) 2013年 nishimaru hayato. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FollowerViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *followerTableController;


@end
