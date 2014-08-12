//
//  DeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceViewController.h"
#import <CloudKit/CloudKit.h>
#import "CloudKitManager.h"

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
    self.bookedFromLabel.text = bookedFrom.fullName;
    
    self.personObject = [[Person alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)storeReference {
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager storePersonObjectAsReferenceWithDeviceID:self.deviceObject.ID personID:self.personObject.ID completionHandler:^(CKRecord *record) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erfolgreich ausgeliehen!" message:[NSString stringWithFormat: @"Sie haben das Gerät erfolgreich ausgeliehen"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

//Action when user clicks on button
-(IBAction)fetchPersonRecordOnClick {
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager fetchPersonRecordWithUserName:@"fbraun" completionHandler:^(NSArray *personObjects) {
        for (Person *person in personObjects){
            self.personObject = person;
        }
        
        [self storeReference];
    }];
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