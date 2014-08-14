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

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set label text
    self.deviceCategoryLabel.text = self.deviceObject.category;
    self.deviceLabel.text = self.deviceObject.deviceName;
    
    //set full name of person in name label
    Person *bookedFrom = self.deviceObject.bookedFromPerson;
    [bookedFrom createFullNameWithFirstName];
    self.bookedFromLabelText.text = bookedFrom.fullName;
    
    self.personObject = [[Person alloc] init];
    
    if (self.deviceObject.isBooked) {
        UserDefaults *userDefaults = [[UserDefaults alloc]init];
        NSString *currentUserName = [userDefaults getCurrentUsername];
        if ([currentUserName isEqualToString:self.deviceObject.bookedFromPerson.userName]) {
            [self.bookDevice setTitle:NSLocalizedString(@"return button", nil) forState:UIControlStateNormal];
            [self.bookedFromLabelText setText:NSLocalizedString(@"you", nil)];
        }else{
            [self.bookDevice setEnabled:false];
            [self.bookDevice setTitle:NSLocalizedString(@"already booked", nil) forState:UIControlStateNormal];
        }
    }else{
        [self.bookedFromLabel setHidden:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)storeReference {
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager storePersonObjectAsReferenceWithDeviceID:self.deviceObject.ID personID:self.personObject.ID completionHandler:^{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"book success", nil) message:[NSString stringWithFormat: NSLocalizedString(@"book success text", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

-(void)deleteReference{
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager deleteReferenceInDeviceWithDeviceID:self.deviceObject.ID completionHandler:^{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"return success", nil) message:[NSString stringWithFormat: NSLocalizedString(@"return success text", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

//Action when user clicks on button
-(IBAction)fetchPersonRecordOnClick {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *currentUserName = [userDefaults getCurrentUsername];
    
    if (!self.deviceObject.isBooked){
        [self.bookDevice setTitle:NSLocalizedString(@"return button", nil) forState:UIControlStateNormal];
        self.deviceObject.isBooked = true;
        
        CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
        
        [cloudManager fetchPersonWithUsername:currentUserName completionHandler:^(Person *person) {
            self.personObject = person;
            [self storeReference];
        }];
    }else{
        [self deleteReference];
        [self.bookDevice setTitle:NSLocalizedString(@"book button", nil) forState:UIControlStateNormal];
    }
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
