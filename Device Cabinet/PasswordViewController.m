//
//  PasswordViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 13.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "PasswordViewController.h"
#import "CloudKitManager.h"
#import "MD5Extension.h"
#import "UserDefaults.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)resetPassword{
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    
    [cloudManager fetchPersonWithUsername:[userDefaults getCurrentUsername] completionHandler:^(Person *person) {
        self.person = person;
        
        [cloudManager resetPasswordFromPersonObjectWithPersonID:self.person.ID password:[self.password.text MD5] completionHandler:^(CKRecord *record) {
            [[[UIAlertView alloc]initWithTitle:@"Passwort zurückgesetzt" message:[NSString stringWithFormat: @"Ihr Passwort wurde geändert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
     
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
