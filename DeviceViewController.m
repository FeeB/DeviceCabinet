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

@synthesize deviceLabel;
@synthesize deviceName;

@synthesize deviceCategoryLabel;
@synthesize deviceCategory;

@synthesize bookedFromLabel;
@synthesize bookedFrom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    deviceLabel.text = deviceName;
    deviceCategoryLabel.text = deviceCategory;
    bookedFromLabel.text = bookedFrom;
    
    self.personRecord = [[CKRecord alloc] initWithRecordType:@"Persons"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)storeReference {
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    NSLog(@"ID: %@", self.deviceRecord.recordID);
    
    [publicDatabase fetchRecordWithID:self.deviceRecord.recordID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            CKReference *bookedReference = [[CKReference alloc]
                                            initWithRecord:self.personRecord
                                            action:CKReferenceActionNone];
            record[@"booked"] = bookedReference;
            
            [publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@ saved: %@", error, record);
                } else {
                    NSLog(@"Success");
                }
            }];
        }
    }];
}

-(IBAction)bookDevice {
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager fetchRecordWithPersonName:@"braun" completionHandler:^(NSArray *records) {
        for (CKRecord *recordName in records){
            self.personRecord = recordName.copy;
            NSLog(@"Record person in methode: %@", self.personRecord);
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
