//
//  StartViewController.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 13.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "StartViewController.h"
#import "LaunchHandler.h"

NSString * const FromStartToDecisionSegue = @"FromStartToDecisionSegue";
NSString * const FromStartToOverviewSegue = @"FromStartToOverviewSegue";

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LaunchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        if (shouldShowDecision) {
            [self performSegueWithIdentifier:FromStartToDecisionSegue sender:nil];
        } else {
            [self performSegueWithIdentifier:FromStartToOverviewSegue sender:nil];
        }
    }];
}

@end
