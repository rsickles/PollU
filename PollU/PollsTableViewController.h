//
//  PollsTableViewController.h
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePollViewController.h"

@interface PollsTableViewController : UITableViewController <UITableViewDelegate>
{
    NSArray *poll_list;
}
@end
