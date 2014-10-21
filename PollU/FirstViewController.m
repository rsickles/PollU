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
static int label_number = 10;
@implementation FirstViewController
-(int)delta_height {return delta_height;}
-(int)label_number {return label_number;}
@synthesize titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
            if(error)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:error.localizedDescription
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                else
                {
                    FBRequest *request = [FBRequest requestForMe];
                    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        // handle response
                        [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                                 forKey:@"fbId"];
                        [[PFUser currentUser] saveInBackground];
                    }];
                }
        }];
        }
    else {
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
            NSLog(@"ID OF FACEBOOK USER %@",result);
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                     forKey:@"fbId"];
            [[PFUser currentUser] saveInBackground];
        }];
    }
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 623)];
    delta_height = 0;
    self.addButton.frame = CGRectMake(30, 260, 105, 50);
    self.addRecip.frame = CGRectMake(190, 260, 105, 50);
    self.sendButton.frame = CGRectMake(110, 350, 105, 30);
    optionArray = [[NSMutableArray alloc]init];
    friendsArray = [[NSMutableArray alloc]init];
    fbFriendPickerController = [[FBFriendPickerViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPoll:(id)sender {
    NSLog(@"SEND POLL CLICKED");
    //combine all labels into array of options and push to parse
    //UILabel *label = (UILabel*)[self viewWithTag:LABEL_TAG+10];
//        [PFUser logOut]; // Log out
    
        // Return to Login view controller
//        [self dismissViewControllerAnimated:YES completion:nil];
    
    //save in polls array
    if([friendsArray count]>0 && self.titleLabel.text != nil && [optionArray count]>0)
    {
        PFObject *poll_table = [PFObject objectWithClassName:@"Poll"];
        poll_table[@"options"] = optionArray;
        poll_table[@"poll_title"] = self.titleLabel.text;
        NSMutableArray *response_array = [[NSMutableArray alloc]init];
        //fill array with # of zeros per amount of options
        for(int i=0; i<[optionArray count]; i++)
        {
            [response_array addObject:[NSNumber numberWithInteger:0]];
        }
        poll_table[@"responses"] = response_array;
        [poll_table saveInBackground];
        for (NSString *user in friendsArray)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"foreign_key" equalTo:user];
            //get the array of ids
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSLog(@"THIS THE SUERSS %@",objects);
                    PFObject *user_name = objects.firstObject;
                    NSMutableArray *polls = user_name[@"Polls"];
                    if([polls count]>0) {
                    [polls addObject:poll_table.objectId];
                    [[PFUser currentUser] setObject:polls
                                             forKey:@"Polls"];
                    [[PFUser currentUser] saveInBackground];
                    }
                 else {
                    //if there is no poll table or polls array yet
                        NSMutableArray *polls = [[NSMutableArray alloc]initWithObjects:poll_table.objectId, nil];
                        [[PFUser currentUser] setObject:polls
                                                 forKey:@"Polls"];
                        [[PFUser currentUser] saveInBackground];
                }
            }];
        }
    }
}

- (IBAction)addOption:(id)sender {
    //move add button
    self.addButton.frame = CGRectMake(30, 260 + delta_height, 105, 50);
    self.addRecip.frame = CGRectMake(190, 260 + delta_height, 105, 50);
    self.sendButton.frame = CGRectMake(110, 350 + delta_height, 105, 30);
    //add text label
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 190 + delta_height, 150, 50)];
    [newLabel setText:[NSString stringWithFormat:@"Option %d", label_number-9]];
    [newLabel setTag:label_number];
    [scroller addSubview:newLabel];
    //now add textfield
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 230 + delta_height, 120, 25)];
    textField.delegate = self;
    textField.tag = label_number;
    [scroller addSubview:textField];
    textField.borderStyle = UITextBorderStyleLine;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyDone;
    delta_height+=50;
    label_number+=1;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    if(textField.tag == 99)
    {
        NSString *titleText = textField.text;
        self.titleLabel.text = titleText;
        self.titleLabel.textColor = [UIColor blueColor];
        textField.text = @"";
    }
    else
    {
        NSString *optionName = textField.text;
        for (UIView *addedView in [self.view subviews])
        {
            for (UIView *sub in [addedView subviews])
            {
                if([sub isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)sub;
                    if(label.tag == textField.tag)
                    {
                        label.text = [NSString stringWithFormat:@"%d. %@",textField.tag-9,optionName];
                        label.textColor = [UIColor blueColor];
                    }
                }
            }
        }
        [optionArray addObject:optionName];
        [textField removeFromSuperview];
    }
    return YES;
}
- (IBAction)addRecip:(id)sender {
    if (fbFriendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        fbFriendPickerController = [[FBFriendPickerViewController alloc] init];
        fbFriendPickerController.title = @"Pick Friends";
        fbFriendPickerController.delegate = self;
    }
    else {
        fbFriendPickerController.title = @"Pick Friends";
        fbFriendPickerController.delegate = self;
    }
    
    [fbFriendPickerController loadData];
    [fbFriendPickerController clearSelection];
    
    [self presentViewController:fbFriendPickerController animated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)facebookViewControllerDoneWasPressed:(id)sender{
    //code goes here
    for (id<FBGraphUser> user in fbFriendPickerController.selection) {
        NSLog(@"%@",user);
        [[PFUser currentUser] setObject:user.id
                                 forKey:@"foreign_key"];
        [[PFUser currentUser] saveInBackground];
        [friendsArray addObject:user.id];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)facebookViewControllerCancelWasPressed:(id)sender{
[self dismissViewControllerAnimated:YES completion:NULL];
}
@end
