//
//  CreatePersonViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreatePersonViewController.h"
#import "Person.h"
#import "UserDefaults.h"
#import "OverviewViewController.h"
#import "TEDLocalization.h"
#import "CloudKitErrorMapper.h"
#import "AppDelegate.h"

NSString * const FromCreatePersonToOverviewSegue = @"FromCreatePersonToOverview";

@interface CreatePersonViewController ()
@property (readonly) CKContainer *container;
@property (readonly) CKDatabase *publicDatabase;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITextField *actualTextField;
@property (nonatomic, strong) Person *person;

@end

@implementation CreatePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TEDLocalization localize:self];
    
    self.lastNameLabel.text = NSLocalizedString(@"LABEL_LASTNAME", nil);
    self.firstNameLabel.text = NSLocalizedString(@"LABEL_FIRSTNAME", nil);
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storePerson {
    BOOL isStorable = true;
    NSMutableArray *txtFields = [[NSMutableArray alloc]initWithObjects:self.firstNameTextField.text, self.lastNameTextField.text, nil];
    
    for (NSString *textField in txtFields) {
        if ([textField isEqualToString:@""]) {
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_EMPTY_TEXTFIELD", nil)
                                       message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_EMPTY_TEXTFIELD", nil), textField]
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            isStorable = false;
            break;
        }
    }
    
    if (isStorable) {
        [self.spinner startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        self.person = [[Person alloc] init];
        self.person.firstName = self.firstNameTextField.text;
        self.person.lastName = self.lastNameTextField.text;
        
        [AppDelegate.dao storePerson:self.person completionHandler:^(Person *storedPerson, NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.spinner stopAnimating];
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self.spinner stopAnimating];
            } else {
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_SAVED", nil)
                                           message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_SAVED_PERSON", nil), self.person.firstName, self.person.lastName]
                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }

        }];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.onCompletion) {
        self.onCompletion(self.person);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self.actualTextField = textField;
    return YES;
}

- (void) dismissKeyboard {
    [self.actualTextField resignFirstResponder];
}

@end
