//
//  CreatePersonViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreatePersonViewController.h"
#import "Person.h"
#import <CloudKit/CloudKit.h>

NSString * const PersonsRecordType = @"Persons";
NSString * const FirstNameField= @"firstName";
NSString * const LastNameField = @"lastName";
NSString * const PasswordField = @"password";
NSString * const UsernameField = @"userName";
NSString * const IsAdminSwitch = @"isAdmin";

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

-(IBAction)storePerson
{
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    Person *personObject = [[Person alloc] init];
    CKRecord *personRecord = [[CKRecord alloc] initWithRecordType:PersonsRecordType];
    
    personObject.firstName = self.firstName.text;
    personObject.lastName = self.lastName.text;
    personObject.decodedPasswort = self.password.text;
    [personObject encodePassword];
    personObject.userName = self.userName.text;
    
    if (self.isAdmin.on){
        personObject.isAdmin = true;
        personRecord[IsAdminSwitch] = @"true";
    }
    
    
    personRecord[FirstNameField] = personObject.firstName;
    personRecord[LastNameField] = personObject.lastName;
    personRecord[PasswordField] = personObject.encodedPasswort;
    personRecord[UsernameField] = personObject.userName;
    
    
    [publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *savedPerson, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ saved: %@", error, savedPerson);
        } else {
            NSLog(@"Saved: %@", savedPerson);
        }
    }];
    
//    [[[UIAlertView alloc]initWithTitle:@"Gespeichert!"
//                              message:[NSString stringWithFormat: @"Ihr Name: %1@ %2@", personObject.firstName, personObject.lastName]
//                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
