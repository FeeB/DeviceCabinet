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

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UILabel *passwordLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *logInButton;

@property (nonatomic, weak) Person *personObject;

-(IBAction)logInOnClick;
- (void)viewWillDisappear:(BOOL)animated;

@end
