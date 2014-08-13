//
//  PasswordViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 13.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface PasswordViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) Person *person;
-(IBAction)resetPassword;

@end
