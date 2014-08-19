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
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"username not found", nil) message:NSLocalizedString(@"username not found text", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"username empty", nil) message:NSLocalizedString(@"username empty text", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
            UserDefaults *userDefault = [[UserDefaults alloc]init];
            [userDefault storeUserDefaults:self.personObject.userName userType:@"person"];
            
            [self performSegueWithIdentifier:@"CreateDeviceToDeviceView" sender:self];
        } else {
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"register device", nil) message:[NSString stringWithFormat:NSLocalizedString(@"register device text", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self performSegueWithIdentifier:@"fromLogInToCreateDevice" sender:self];
        }
    }];

}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.parentViewController viewDidLoad];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
