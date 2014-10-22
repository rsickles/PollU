//
//  TakePollViewController.m
//  PollU
//
//  Created by Ryan Sickles on 10/21/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "TakePollViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TakePollViewController ()

@end

@implementation TakePollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.polltitle.text = self.titlePoll;
    self.lastTag = -1;
    int delta = 0;
    for(int i=0; i<[self.options count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(selectButton:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i+1];
        [button setTitle:[self.options objectAtIndex:i] forState:UIControlStateNormal];
        button.frame = CGRectMake(80.0, 150.0 + delta, 250.0, 50.0);
        delta+=75;
        [self.view addSubview:button];
    }
}


- (void)selectButton:(UIButton*)button
{
    if(self.lastTag!=-1)
    {
        UIButton *btnOne = (UIButton *)[self.view viewWithTag:self.lastTag];
        btnOne.layer.borderColor = [UIColor whiteColor].CGColor;
                NSLog(@"SDFDF");
    }
    //new button changes
    UIButton *btn = (UIButton *)[button viewWithTag:[button tag]];
    //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 0.5f;
    btn.layer.cornerRadius = 10.0f;
    self.lastTag = [button tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submit:(id)sender {
    
    if(self.lastTag == -1) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Option Selected"
                                                    message:@"Please Select An Option To Submit."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    }
       else {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Poll"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.pollId block:^(PFObject *poll, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        NSMutableArray *a = poll[@"responses"];
        NSNumber *x = [a objectAtIndex:self.lastTag-1];
        NSNumber *sum = [NSNumber numberWithFloat:([x floatValue] + 1.0)];
        NSMutableArray *newArray = [[NSMutableArray alloc]init];
        for(int i=0; i<[a count];i++)
        {
            if(i==self.lastTag-1)
            {
                [newArray addObject:sum];
            }
            else {
            [newArray addObject:[a objectAtIndex:i]];
            }
        }
        poll[@"responses"] = newArray;
        [poll saveInBackground];
        //removes that poll from your polls to take
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        NSMutableArray *newPollArray = [[NSMutableArray alloc]init];
        [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *user, NSError *error) {
            NSMutableArray *a = [user objectForKey:@"Polls"];
            int i=0;
            while(i<[a count])
            {
                if(![self.pollId isEqualToString:a[i]])
                {
                    [newPollArray addObject:a[i]];
                }
                i++;
            }
            [[PFUser currentUser] setObject:newPollArray forKey:@"Polls"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil userInfo:nil];
            }];
            
        }];
        
    }];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
       }
}
@end
