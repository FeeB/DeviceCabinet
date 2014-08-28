//
//  LogInViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 12.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "LogInViewController.h"
#import "CloudKitManager.h"
#import "Person.h"
#import "UserDefaults.h"
#import "UIdGenerator.h"
#import "DeviceViewController.h"
#import "TEDLocalization.h"
#import "OverviewViewController.h"

@interface LogInViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation LogInViewController

NSString *FromLogInToOverviewSegue = @"FromLogInToOverview";
NSString *FromLogInToDeviceViewSegue = @"FromLoginToDeviceView";
NSString *FromLogInToCreateDeviceSegue = @"FromLogInToCreateDevice";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    [TEDLocalization localize:self];
    
    self.whoAmILabel.text = NSLocalizedString(@"LABEL_LOGIN", nil);
    self.userLabel.text = NSLocalizedString(@"LABEL_TESTER", nil);
    self.userNameLabel.text = NSLocalizedString(@"LABEL_USERNAME", nil);
    [self.personRegisterButton setTitle:NSLocalizedString(@"BUTTON_REGISTER", nil) forState:UIControlStateNormal];
    [self.deviceRegisterButton setTitle:NSLocalizedString(@"BUTTON_REGISTER", nil) forState:UIControlStateNormal];
    self.deviceLabel.text = NSLocalizedString(@"LABEL_DEVICE", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personLogInOnClick{
    [self.spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (self.userNameField.text && self.userNameField.text.length > 0) {
        CloudKitManager *cloudManager = [[CloudKitManager alloc]init];
        [cloudManager fetchPersonWithUsername:[self.userNameField text] completionHandler:^(Person *person, NSError *error) {
            if (error) {
                if (error.code == 1) {
                    [self.spinner stopAnimating];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_NOT_FOUND", nil) message:NSLocalizedString(@"MESSAGE_USERNAME_NOT_FOUND", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                } else {
                    [self.spinner stopAnimating];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                }
            } else {
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                self.personObject = person;
                if ([self.userNameField.text isEqualToString:self.personObject.userName]) {
                    UserDefaults *userDefault = [[UserDefaults alloc]init];
                    [userDefault storeUserDefaults:self.personObject.userName userType:@"person"];
                    
                    [self performSegueWithIdentifier:FromLogInToOverviewSegue sender:nil];
                } else {
                    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_NOT_FOUND", nil) message:NSLocalizedString(@"MESSAGE_USERNAME_NOT_FOUND", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
        }];
    } else {
        [self.spinner stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_EMPTY", nil) message:NSLocalizedString(@"MESSAGE_USERNAME_EMPTY", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }    
}

- (IBAction)deviceLogInOnClick {
    [self.spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
    NSString *deviceId = [uIdGenerator getDeviceId];
    
    CloudKitManager *cloudManager = [[CloudKitManager alloc]init];
    
    [cloudManager fetchDeviceWithDeviceId:deviceId completionHandler:^(Device *device, NSError *error) {
        if (error) {
            if (error.code == 1) {
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_REGISTER_DEVICE", nil) message:[NSString stringWithFormat:NSLocalizedString(@"MESSAGE_REGISTER_DEVICE", nil)] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        } else {
            [self.spinner stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            self.deviceObject = device;
            
            [self performSegueWithIdentifier:FromLogInToDeviceViewSegue sender:self];
        }
        
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromLogInToDeviceViewSegue]){
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.comesFromStartView = YES;
        controller.deviceObject = self.deviceObject;
    } else if ([segue.identifier isEqualToString:FromLogInToOverviewSegue]) {
        OverviewViewController *controller = (OverviewViewController *)segue.destinationViewController;
        controller.userIsLoggedIn = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:FromLogInToCreateDeviceSegue sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.parentViewController viewDidLoad];
}

@end
