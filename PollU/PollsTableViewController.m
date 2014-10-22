//
//  PollsTableViewController.m
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "PollsTableViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PollsTableViewController ()

@end

@implementation PollsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    //to refresh the table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshTable" object:nil];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getPolls];
}

// Add this method just beneath viewDidLoad:
- (void)refreshTableWithNotification:(NSNotification *)notification
{
    [self getPolls];
}


-(void)getPolls{
    NSMutableArray *polls = [[PFUser currentUser]objectForKey:@"Polls"];
    //now look for all polls that user has
    PFQuery *query = [PFQuery queryWithClassName:@"Poll"];
    [query whereKey:@"objectId" containedIn:polls];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            poll_list = objects;
            NSLog(@"THIS IS HTE POLL LIST %lu",(unsigned long)[poll_list count]);
            [self.tableView reloadData];
            // Do something with the found objects
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [poll_list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text= [[poll_list objectAtIndex:indexPath.row] valueForKey:@"creator"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TakePollViewController *take_poll = [[TakePollViewController alloc]initWithNibName:@"TakePollViewController" bundle:[NSBundle mainBundle]];
    take_poll.titlePoll = [[poll_list objectAtIndex:indexPath.row] valueForKey:@"poll_title"];
    take_poll.options = [[poll_list objectAtIndex:indexPath.row] valueForKey:@"options"];
    take_poll.pollId = [[poll_list objectAtIndex:indexPath.row] valueForKey:@"objectId"];
    [self presentViewController:take_poll animated:YES completion:nil];
}

@end
