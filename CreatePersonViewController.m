//
//  CreatePersonViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreatePersonViewController.h"
#import "Person.h"
#import "CloudKitManager.h"
#import "UserDefaults.h"
#import "OverviewViewController.h"
#import "TEDLocalization.h"
#import "ErrorMapper.h"

NSString * const FromCreatePersonToOverviewSegue = @"FromCreatePersonToOverview";

@interface CreatePersonViewController ()
@property (readonly) CKContainer *container;
@property (readonly) CKDatabase *publicDatabase;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation CreatePersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [TEDLocalization localize:self];
    
    self.lastNameLabel.text = NSLocalizedString(@"LABEL_LASTNAME", nil);
    self.firstNameLabel.text = NSLocalizedString(@"LABEL_FIRSTNAME", nil);
    self.userNameLabel.text = NSLocalizedString(@"LABEL_USERNAME", nil);
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storePerson {
    BOOL isStorable = true;
    NSMutableArray *txtFields = [[NSMutableArray alloc]initWithObjects:self.firstNameTextField.text, self.lastNameTextField.text, self.userNameTextField.text, nil];
    
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
        
        __block Person *person = [[Person alloc] init];
        person.firstName = self.firstNameTextField.text;
        person.lastName = self.lastNameTextField.text;
        person.userName = self.userNameTextField.text;
        
//        NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:3000/devices"];
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//        [urlRequest setHTTPMethod:@"POST"];
//        //do something to fix this
//        [urlRequest setHTTPBody:person];
//        [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        
        CloudKitManager *cloudManager = [[CloudKitManager alloc] init];
        [cloudManager storePerson:person completionHandler:^(NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self.spinner stopAnimating];
            } else {
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_SAVED", nil)
                                           message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_SAVED_PERSON", nil), person.firstName, person.lastName]
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
                UserDefaults *userDefaults = [[UserDefaults alloc]init];
                [userDefaults storeUserDefaults:person.userName userType:@"person"];
                
                [self performSegueWithIdentifier:FromCreatePersonToOverviewSegue sender:self];
            }
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromCreatePersonToOverviewSegue]){
        OverviewViewController *controller = (OverviewViewController *)segue.destinationViewController;
        controller.userIsLoggedIn = YES;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
