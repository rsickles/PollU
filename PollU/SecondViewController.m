//
//  SecondViewController.m
//  PollU
//
//  Created by Ryan Sickles on 10/12/14.
//  Copyright (c) 2014 sickles.ryan. All rights reserved.
//

#import "SecondViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SecondViewController ()

@end
static int delta_height = 0;
@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    results = [[NSMutableArray alloc]init];
    options = [[NSMutableArray alloc]init];
    titles = [[NSMutableArray alloc]init];
    [self setFirstScreen];
    [self viewDidAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    //get results for user
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        user_name = [result objectForKey:@"name"];
        PFQuery *query = [PFQuery queryWithClassName:@"Poll"];
        [query whereKey:@"creator" equalTo:user_name];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"THESE ARE YOU RESULTS %lu",(unsigned long)[objects count]);
            if([objects count]>0){
            [self.stepperObject setMaximumValue:[objects count]-1];
            for(int i=0; i<[objects count]; i++)
            {
                NSMutableArray *set = [[objects objectAtIndex:i]objectForKey:@"responses"];
                NSMutableArray *options_set = [[objects objectAtIndex:i]objectForKey:@"options"];
                NSString *title = [[objects objectAtIndex:i] objectForKey:@"poll_title"];
                [results addObject:set];
                [options addObject:options_set];
                [titles addObject:title];
            }
            }
            else {
                [self.stepperObject setMaximumValue:0];
            }
        }];
    }];
}

-(void)setFirstScreen{

        UILabel *resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 50 + delta_height, 400, 100)];
        resultsLabel.text = [NSString stringWithFormat:@"Click Below To View Poll Results"];
        [self.contentView addSubview:resultsLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepper:(UIStepper *)sender {
    //remove labels
    delta_height = 0;
    for (UIView *addedView in [self.contentView subviews])
    {

            if([addedView isKindOfClass:[UILabel class]])
            {
                        UILabel *label = (UILabel *)addedView;
                        [label removeFromSuperview];
            }
    }
    //end of removing labels
    double value = [sender value];
    NSMutableArray *setIndex = [results objectAtIndex:value];
    NSMutableArray *optionsIndex = [options objectAtIndex:value];
    NSString *titlesIndex = [titles objectAtIndex:value];
    for(int i=0; i<[setIndex count];i++)
    {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 250, 30)];
        titleLabel.text = [NSString stringWithFormat:@"%@", titlesIndex];
        UILabel *resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 50 + delta_height, 100, 100)];
        resultsLabel.text = [NSString stringWithFormat:@"%@ - %@", [optionsIndex objectAtIndex:i], [setIndex objectAtIndex:i]];
        [self.contentView addSubview:resultsLabel];
        [self.contentView addSubview:titleLabel];
        delta_height+=25;
    }
}
@end
