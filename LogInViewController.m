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

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.whoAmILabel.text = NSLocalizedString(@"Login", nil);
    self.userLabel.text = NSLocalizedString(@"tester", nil);
    self.userNameLabel.text = NSLocalizedString(@"username", nil);
    [self.personRegisterButton setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    [self.deviceRegisterButton setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
    self.deviceLabel.text = NSLocalizedString(@"device", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personLogInOnClick{
    
    if (self.userNameField.text && self.userNameField.text.length > 0) {
        CloudKitManager *manager = [[CloudKitManager alloc]init];
        [manager fetchPersonWithUsername:[self.userNameField text] completionHandler:^(Person *person) {
            self.personObject = person;
            
            if ([self.userNameField.text isEqualToString:self.personObject.userName]) {
                UserDefaults *userDefault = [[UserDefaults alloc]init];
                [userDefault storeUserDefaults:self.personObject.userName userType:@"person"];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"username-not-found", nil) message:NSLocalizedString(@"username-not-found-text", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    } else {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"username-empty", nil) message:NSLocalizedString(@"username-empty-text", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }    
}

- (IBAction)deviceLogInOnClick {
    UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
    NSString *deviceId = [uIdGenerator getDeviceId];
    
    CloudKitManager *manager = [[CloudKitManager alloc]init];
    
    [manager fetchDeviceWithDeviceId:deviceId completionHandler:^(Device *device) {
        NSLog(@"deviceId: %@", deviceId);
        self.deviceObject = device;
        
        if (device) {
            // TODO? What is going on here? Shouldnt that be about devices?
            UserDefaults *userDefault = [[UserDefaults alloc]init];
            [userDefault storeUserDefaults:self.personObject.userName userType:@"person"];

            [self performSegueWithIdentifier:@"fromLoginToDeviceView" sender:self];
        } else {
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"register-device", nil) message:[NSString stringWithFormat:NSLocalizedString(@"register-device-text", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self performSegueWithIdentifier:@"fromLogInToCreateDevice" sender:self];
        }
    }];

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
