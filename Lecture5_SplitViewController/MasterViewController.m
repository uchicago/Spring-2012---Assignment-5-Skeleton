//
//  MasterViewController.m
//  Lecture5_SplitViewController
//
//  Created by T. Binkowski on 4/25/12.
//  Copyright (c) 2012 Argonne National Laboratory. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize delegate = _delegate;
@synthesize feed = _feed;

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    _delegate = self.detailViewController;
    
    // Download the data in the background
    [self downloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _objects.count;
    return [self.feed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    //NSDate *object = [_objects objectAtIndex:indexPath.row];
    //cell.textLabel.text = [object description];
    NSDictionary *article = [self.feed objectAtIndex:indexPath.row];
    NSLog(@"Article:%@",article);
    cell.textLabel.text = [article objectForKey:@"title"];
    cell.detailTextLabel.text = [article objectForKey:@"pubDate"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDate *object = [_objects objectAtIndex:indexPath.row];
    NSString *articleURL = @"HI";//[[self.feed objectAtIndex:indexPath.row] objectForKey:@"link"];
    self.detailViewController.detailItem = articleURL;

    //
    [self.delegate masterDetailChanged:[self.feed objectAtIndex:indexPath.row]];
}

#pragma mark - Download Data
/*******************************************************************************
 * @method      downloadData
 * @abstract    <# abstract #>
 * @description <# description #>
 *******************************************************************************/
- (void) downloadData
{
    NSURL *url=[NSURL URLWithString:@"http://pipes.yahoo.com/pipes/pipe.run?_id=2FV68p9G3BGVbc7IdLq02Q&_render=json&feedcount=20&feedurl=www.sciencenews.org%2Fview%2Ffeed%2Ftype%2Farticle%2Fname%2Ffeatures.rss"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(),^{
            NSError *error = nil;
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            //NSLog(@"Json as NSDictionary: %@",results);
            //NSLog(@"Json as NSDictionary: %@",[[[results objectForKey:@"value"] objectForKey:@"items"] objectAtIndex:0]);
            
            self.feed = [NSMutableArray arrayWithArray:[[results objectForKey:@"value"] objectForKey:@"items"] ];
            // Process the results (i.e. conver the NSDictionary into an NSArray that will be read by the UITableView dataSource)
            // 
            //NSLog(@"Feed:%@",self.feed);
            // Reload the table
            [self.tableView reloadData];
        });
    });
}


@end























