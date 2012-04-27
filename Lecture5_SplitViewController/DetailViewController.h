//
//  DetailViewController.h
//  Lecture5_SplitViewController
//
//  Created by T. Binkowski on 4/25/12.
//  Copyright (c) 2012 Argonne National Laboratory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailDelegate.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,MasterDetailDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) UIPopoverController *actionPopover;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
