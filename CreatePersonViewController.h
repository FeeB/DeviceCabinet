//
//  CreatePersonViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface CreatePersonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isAdminSwitch;

- (IBAction)storePerson;

@end
