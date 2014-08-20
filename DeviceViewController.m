//
//  DeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceViewController.h"
#import "CloudKitManager.h"
#import "UserDefaults.h"
#import "TEDLocalization.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TEDLocalization localize:self];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    //set label text
    self.individualDeviceCategoryLabel.text = self.deviceObject.category;
    self.deviceCategoryLabel.text = NSLocalizedString(@"category", nil);
    self.individualDeviceNameLabel.text = self.deviceObject.deviceName;
    self.deviceNameLabel.text = NSLocalizedString(@"devicename", nil);
    self.individualSystemVersionLabel.text = self.deviceObject.systemVersion;
    self.systemVersionLabel.text = NSLocalizedString(@"system-version", nil);
    [self.bookDevice setTitle:NSLocalizedString(@"book-button", nil) forState:UIControlStateNormal];
    self.usernameLabel.text = NSLocalizedString(@"enter-username", nil);
    
    [self showOrHideTextFields];
    
    //toDo: set name after completionHandler
    //set full name of person in name label
    Person *bookedFrom = self.deviceObject.bookedFromPerson;
    [bookedFrom createFullNameWithFirstName];
    self.bookedFromLabelText.text = bookedFrom.fullName;
    
    self.personObject = [[Person alloc] init];
    
}

- (void)storeReference {
    [self.spinner startAnimating];
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager storePersonObjectAsReferenceWithDeviceID:self.deviceObject.recordId personID:self.personObject.recordId completionHandler:^{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"book-success", nil) message:NSLocalizedString(@"book-success-text", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.spinner stopAnimating];
        [self.bookDevice setTitle:NSLocalizedString(@"return-button", nil) forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)deleteReference{
    [self.spinner startAnimating];
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager deleteReferenceInDeviceWithDeviceID:self.deviceObject.recordId completionHandler:^{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"return-success", nil) message:[NSString stringWithFormat: NSLocalizedString(@"return-success-text", nil), self.deviceObject.deviceName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.spinner stopAnimating];
        [self.bookDevice setTitle:NSLocalizedString(@"book-button", nil) forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//Action when user clicks on button
-(IBAction)fetchPersonRecordOnClick {
    
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *username = [userDefaults getUserIdentifier];
    NSString *userType = [userDefaults getUserType];
    
    if ([userType isEqualToString:@"device"]){
        username = self.usernameTextField.text;
    }
    
    if (!self.deviceObject.isBooked){
        self.deviceObject.isBooked = true;
        CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
        [cloudManager fetchPersonWithUsername:username completionHandler:^(Person *person) {
            self.personObject = person;
            [self storeReference];
        }];
    }else{
        [self deleteReference];
    }
}

- (void)showOrHideTextFields{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *currentUserIdentifier = [userDefaults getUserIdentifier];
    NSString *currentUserType = [userDefaults getUserType];
    
    [self.usernameTextField setHidden:true];
    [self.usernameLabel setHidden:true];
    
    if (self.deviceObject.isBooked) {
        if ([currentUserIdentifier isEqualToString:self.deviceObject.bookedFromPerson.userName] || [currentUserType isEqualToString:@"device"]) {
            [self.bookDevice setTitle:NSLocalizedString(@"return-button", nil) forState:UIControlStateNormal];
        }else{
            [self.bookDevice setEnabled:false];
            [self.bookDevice setTitle:NSLocalizedString(@"already-booked", nil) forState:UIControlStateNormal];
        }
    }else{
        [self.bookedFromLabel setHidden:true];
        
        if ([[userDefaults getUserType] isEqualToString:@"device"]){
            [self.usernameTextField setHidden:false];
            [self.usernameLabel setHidden:false];
        }
    }
}

@end
