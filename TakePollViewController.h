//
//  TakePollViewController.h
//  PollU
//
//  Created by Ryan Sickles on 10/21/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TakePollViewController : UIViewController
- (IBAction)back:(id)sender;
@property(nonatomic) NSString *titlePoll;
@property(nonatomic) NSMutableArray *options;
@property (strong, nonatomic) IBOutlet UILabel *polltitle;
@property NSInteger lastTag;
- (IBAction)submit:(id)sender;
@property NSString *pollId;
@end
