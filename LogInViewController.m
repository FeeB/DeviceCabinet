//
//  LogInViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 12.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "LogInViewController.h"
#import "Person.h"
#import "UserDefaults.h"
#import "UIdGenerator.h"
#import "DeviceViewController.h"
#import "TEDLocalization.h"
#import "OverviewViewController.h"
#import "AppDelegate.h"
#import "CreateDeviceViewController.h"
#import "CreatePersonViewController.h"

@protocol LoginViewControllerDelegate;

@interface LogInViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation LogInViewController

NSString *FromLogInToCreateDeviceSegue = @"FromLogInToCreateDevice";
NSString *FromLogInToCreatePersonSegue = @"FromLogInToCreatePerson";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    [TEDLocalization localize:self];
    
    self.userLabel.text = NSLocalizedString(@"LABEL_TESTER", nil);
    self.userNameLabel.text = NSLocalizedString(@"LABEL_USERNAME", nil);
    self.deviceLabel.text = NSLocalizedString(@"LABEL_DEVICE", nil);
    
    if (self.comesFromDeviceOverview) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)personLogInOnClick{
    [self.spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (self.userNameField.text && self.userNameField.text.length > 0) {
        [AppDelegate.dao fetchPersonWithUsername:[self.userNameField text] completionHandler:^(Person *person, NSError *error) {
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
                if ([self.userNameField.text isEqualToString:self.personObject.username]) {
                    UserDefaults *userDefault = [[UserDefaults alloc]init];
                    [userDefault storeUserDefaults:self.personObject.username userType:@"person"];
                    
                    [self dissmissLogInViewToOverview];
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
    
    [AppDelegate.dao fetchDeviceWithDeviceId:deviceId completionHandler:^(Device *device, NSError *error) {
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
            
            [self dissmissLogInViewToDeviceView];
        }
    }];

}

- (IBAction)backOnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dissmissLogInViewToDeviceView{
    if (self.onCompletion) {
        self.onCompletion(self.deviceObject, LogInTypeDevice);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dissmissLogInViewToOverview{
    if (self.onCompletion) {
        self.onCompletion(nil, LogInTypeUser);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromLogInToCreateDeviceSegue]) {
        CreateDeviceViewController *controller = (CreateDeviceViewController *)segue.destinationViewController;
        
        controller.onCompletion = ^(id result) {
            self.deviceObject = result;
            [self dissmissLogInViewToDeviceView];
        };
    } else if ([segue.identifier isEqualToString:FromLogInToCreatePersonSegue]) {
        CreatePersonViewController *controller = (CreatePersonViewController *)segue.destinationViewController;
        
        controller.onCompletion = ^(void) {
            [self dissmissLogInViewToOverview];
        };
    }
    
}

@end
