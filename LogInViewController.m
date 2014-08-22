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
#import "MD5Extension.h"
#import "UserDefaults.h"
#import "UIdGenerator.h"
#import "DeviceViewController.h"
#import "TEDLocalization.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

NSString *FromLogInToOverviewSegue = @"FromLogInToOverview";
NSString *FromLogInToDeviceViewSegue = @"FromLoginToDeviceView";
NSString *FromLogInToCreateDeviceSegue = @"FromLogInToCreateDevice";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TEDLocalization localize:self];
    
    self.whoAmILabel.text = NSLocalizedString(@"LABEL_LOGIN", nil);
    self.userLabel.text = NSLocalizedString(@"LABEL_TESTER", nil);
    self.userNameLabel.text = NSLocalizedString(@"LABEL_USERNAME", nil);
    [self.personRegisterButton setTitle:NSLocalizedString(@"BUTTON_REGISTER", nil) forState:UIControlStateNormal];
    [self.deviceRegisterButton setTitle:NSLocalizedString(@"BUTTON_REGISTER", nil) forState:UIControlStateNormal];
    self.deviceLabel.text = NSLocalizedString(@"LABEL_DEVICE", nil);
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personLogInOnClick{
    
    if (self.userNameField.text && self.userNameField.text.length > 0) {
        CloudKitManager *manager = [[CloudKitManager alloc]init];
        [manager fetchPersonWithUsername:[self.userNameField text] completionHandler:^(Person *person, NSError *error) {
            self.personObject = person;
            
            if ([self.userNameField.text isEqualToString:self.personObject.userName]) {
                UserDefaults *userDefault = [[UserDefaults alloc]init];
                [userDefault storeUserDefaults:self.personObject.userName userType:@"person"];
                
                [self performSegueWithIdentifier:FromLogInToOverviewSegue sender:nil];
            } else {
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_NOT_FOUND", nil) message:NSLocalizedString(@"MESSAGE_USERNAME_NOT_FOUND", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    } else {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_EMPTY", nil) message:NSLocalizedString(@"MESSAGE_USERNAME_EMPTY", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }    
}

- (IBAction)deviceLogInOnClick {
    UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
    NSString *deviceId = [uIdGenerator getDeviceId];
    
    CloudKitManager *manager = [[CloudKitManager alloc]init];
    
    [manager fetchDeviceWithDeviceId:deviceId completionHandler:^(Device *device, NSError *error) {
        self.deviceObject = device;
        
        if (device) {
            [self performSegueWithIdentifier:FromLogInToDeviceViewSegue sender:self];
        } else {
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_REGISTER_DEVICE", nil) message:[NSString stringWithFormat:NSLocalizedString(@"MESSAGE_REGISTER_DEVICE", nil)] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromLogInToDeviceViewSegue]){
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.deviceObject = self.deviceObject;
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
