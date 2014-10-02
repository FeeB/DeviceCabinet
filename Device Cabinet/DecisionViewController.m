//
//  DecisionViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DecisionViewController.h"
#import "UserDefaults.h"
#import "CreateDeviceViewController.h"

@interface DecisionViewController ()

@end

@implementation DecisionViewController

NSString * const FromDecisionToRegisterDeviceSegue = @"FromDecisionToRegisterDevice";
NSString * const FromDecisionToOverviewSegue = @"FromDecisionToOverview";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onRegisterClick {
    [self performSegueWithIdentifier:FromDecisionToRegisterDeviceSegue sender:nil];
}

- (IBAction)onNoRegisterClick {
    [self performSegueWithIdentifier:FromDecisionToOverviewSegue sender:nil];
    UserDefaults *userDefaults = [[UserDefaults alloc] init];
    [userDefaults storeUserDefaults:nil userType:@"person"];
}

-(void)dissmissLogInViewDeviceView{
    if (self.onCompletion) {
        self.onCompletion(self.deviceObject);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromDecisionToRegisterDeviceSegue]) {
        CreateDeviceViewController *controller = (CreateDeviceViewController *)segue.destinationViewController;
        
        controller.onCompletion = ^(id result) {
            self.deviceObject = result;
            [self dissmissLogInViewDeviceView];
        };
    }
}

@end