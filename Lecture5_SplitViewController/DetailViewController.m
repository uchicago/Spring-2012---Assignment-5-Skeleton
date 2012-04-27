//
//  DetailViewController.m
//  Lecture5_SplitViewController
//
//  Created by T. Binkowski on 4/25/12.
//  Copyright (c) 2012 Argonne National Laboratory. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterDetailDelegate.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end


@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize actionPopover = _actionPopover;
@synthesize webview = _webview;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{ self.detailDescriptionLabel.text =  @"JID";
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text =  @"JID";//[self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.detailDescriptionLabel = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Split view

/*******************************************************************************
 * @method      <# method #>
 * @abstract    Showing the Master View Controller
 * @description <# description #>
 *******************************************************************************/
- (void)splitViewController:(UISplitViewController *)splitController 
     willHideViewController:(UIViewController *)viewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}



/*******************************************************************************
 * @method      <# method #>
 * @abstract    Hiding the master view controller
 * @description <# description #>
 *******************************************************************************/
- (void)splitViewController:(UISplitViewController *)splitController 
     willShowViewController:(UIViewController *)viewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    NSLog(@"Hiding");
}


#pragma MasterDetail Delegate
/*******************************************************************************
 * @method      masterDetailChanged:
 * @abstract    The protocol method to receive messages from the master
 * @description <# description #>
 *******************************************************************************/
- (void)masterDetailChanged:(id)sender
{
    NSDictionary *articleDetails = (NSDictionary*)sender;
    NSLog(@"Master sent this article:%@",articleDetails);
    
    NSURL *url = [NSURL URLWithString:[articleDetails objectForKey:@"link"]];    
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

@end












































