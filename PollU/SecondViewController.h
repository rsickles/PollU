//
//  SecondViewController.h
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
{
        NSString *user_name;
        NSMutableArray *results;
        NSMutableArray *options;
        NSMutableArray *titles;
}
- (IBAction)stepper:(UIStepper *)sender;
@property (strong, nonatomic) IBOutlet UIStepper *stepperObject;
@property (strong, nonatomic) IBOutlet UIView *contentView;



@end

