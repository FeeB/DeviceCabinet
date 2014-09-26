//
//  LogInViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 12.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface LogInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *whoAmILabel;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UIButton *personLogInButton;
@property (nonatomic, weak) IBOutlet UIButton *deviceLogInButton;
@property (nonatomic, weak) IBOutlet UIButton *personRegisterButton;
@property (nonatomic, weak) IBOutlet UIButton *deviceRegisterButton;

typedef enum {
    LogInTypeDevice,
    LogInTypeUser
}LogInType;

@property (nonatomic, strong) void (^onCompletion)(id result, LogInType);

@property (nonatomic, weak) Person *personObject;
@property (nonatomic, weak) Device *deviceObject;

- (IBAction)personLogInOnClick;
- (IBAction)deviceLogInOnClick;
- (IBAction)backOnClick;
- (void)viewWillDisappear:(BOOL)animated;

@end
