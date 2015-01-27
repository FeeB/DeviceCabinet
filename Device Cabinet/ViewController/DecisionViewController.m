//
//  DecisionViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DecisionViewController.h"
#import "CreateDeviceViewController.h"
#import "TEDLocalization.h"

@interface DecisionViewController ()

@end

@implementation DecisionViewController

NSString * const FromDecisionToRegisterDeviceSegue = @"FromDecisionToRegisterDevice";
NSString * const FromDecisionToOverviewSegue = @"FromDecisionToOverview";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    [TEDLocalization localize:self];
}

- (IBAction)onRegisterClick {
    [self performSegueWithIdentifier:FromDecisionToRegisterDeviceSegue sender:nil];
}

- (IBAction)onNoRegisterClick {
    [self performSegueWithIdentifier:FromDecisionToOverviewSegue sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromDecisionToRegisterDeviceSegue]) {
        CreateDeviceViewController *controller = (CreateDeviceViewController *)segue.destinationViewController;
        controller.shouldRegisterLocalDevice = YES;
        controller.onCompletion = ^() {
            [self performSegueWithIdentifier:FromDecisionToOverviewSegue sender:nil];
        };
    }
}

@end