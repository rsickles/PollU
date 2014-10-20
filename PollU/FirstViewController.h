//
//  FirstViewController.h
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scroller;
}
@property (strong, nonatomic) IBOutlet UILabel *optionLabel;
- (IBAction)sendPoll:(id)sender;
- (IBAction)addOption:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *optionTitle;
@property (strong, nonatomic) IBOutlet UITextField *pollTitle;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

