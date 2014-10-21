//
//  FirstViewController.h
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate, FBFriendPickerDelegate>
{
    IBOutlet UIScrollView *scroller;
    NSMutableArray *optionArray;
    NSMutableArray *friendsArray;
    FBFriendPickerViewController *fbFriendPickerController;
}
- (IBAction)sendPoll:(id)sender;
- (IBAction)addOption:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *pollTitle;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addRecip:(id)sender;
- (IBAction)logout:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIButton *addRecip;

@end

