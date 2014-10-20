//
//  FirstViewController.m
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "FirstViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FirstViewController ()

@end
static int delta_height = 0;
static int label_number = 0;
@implementation FirstViewController
-(int)delta_height {return delta_height;}
-(int)label_number {return label_number;}
@synthesize optionLabel, titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                 forKey:@"fbId"];
        [[PFUser currentUser] saveInBackground];
    }];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 623)];
    delta_height = 0;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPoll:(id)sender {
    NSLog(@"SEND POLL CLICKED");
    //combine all labels into array of options and push to parse
    //UILabel *label = (UILabel*)[self viewWithTag:LABEL_TAG+10];
}

- (IBAction)addOption:(id)sender {
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 30 + delta_height, 50)];
    [newLabel setText:@"Option #X"];
    [self.view addSubview:newLabel];
    [newLabel setTag:label_number];
    delta_height+=25;
    label_number+=1;
    NSLog(@"%d",label_number);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag ==1)
    {
        NSString *titleText = textField.text;
        titleLabel.text = titleText;
        titleLabel.textColor = [UIColor blueColor];
        textField.text = @"";
    }
    return YES;
}
@end
