//
//  CreatePersonViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreatePersonViewController.h"
#import "Person.h"
@import CloudKit;

@interface CreatePersonViewController ()

@end

@implementation CreatePersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    Person *personObject = [[Person alloc] init];
    personObject.firstName = _firstName.text;
    personObject.lastName = _lastName.text;
    NSLog(@"%@", personObject.firstName);
    [[[UIAlertView alloc]initWithTitle:@"Gespeichert!" message:[NSString stringWithFormat: @"Ihr Name: %1@ %2@", personObject.firstName, personObject.lastName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    
    
    CKContainer* container = [CKContainer defaultContainer];
    [container accountStatusWithCompletionHandler:^(CKAccountStatus status, NSError* err){
        //todo: Account is not recognize in simulator
        if( err == nil ) {
            CKRecord *personRecord = [[CKRecord alloc] initWithRecordType:@"Persons"];
            [personRecord setObject:[personObject firstName] forKey: @"firstName"];
            [personRecord setObject:[personObject lastName] forKey: @"lastName"];
                
            CKDatabase* public = [container publicCloudDatabase];
            [public saveRecord:personRecord completionHandler:^(CKRecord* rec, NSError* err){
                NSLog(@"all done %@ %@", rec, err);
            }];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"ICLOUD" message:@"iCloud is not correctly configured" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
