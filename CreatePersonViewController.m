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

@interface CreatePersonViewController ()
    @property (readonly) CKContainer *container;
    @property (readonly) CKDatabase *publicDatabase;
@end

@implementation CreatePersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storePerson
{
    __block Person *person = [[Person alloc] init];
    person.firstName = self.firstNameTextField.text;
    person.lastName = self.lastNameTextField.text;
    person.decodedPasswort = self.passwordTextField.text;
    [person encodePassword];
    person.userName = self.userNameTextField.text;
    person.isAdmin = self.isAdminSwitch.on;
    
    CloudKitManager *cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchPersonWithUsername:person.userName completionHandler:^(Person *person) {
        if (person) {
            // ERROR: User already exists
        } else {
            [cloudManager storePerson:person completionHandler:^{
                [[[UIAlertView alloc]initWithTitle:@"Gespeichert!"
                                           message:[NSString stringWithFormat: @"Ihr Name: %@ %@", person.firstName, person.lastName]
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
