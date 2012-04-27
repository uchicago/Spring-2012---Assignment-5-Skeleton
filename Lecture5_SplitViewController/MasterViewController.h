//
//  MasterViewController.h
//  Lecture5_SplitViewController
//
//  Created by T. Binkowski on 4/25/12.
//  Copyright (c) 2012 Argonne National Laboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailDelegate.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *feed;
@property (nonatomic, weak) id <MasterDetailDelegate> delegate;

@end
