//
//  UserNamePickerViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface UserNamePickerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *userNames;
@property (nonatomic, strong) NSArray *sortedArray;
@property (nonatomic, strong) void (^onCompletion)(Person *person);
@property (nonatomic, strong) Person *personObject;

- (IBAction)addPerson;
- (IBAction)backButton;

@end
