//
//  LogInViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 12.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "LogInViewController.h"
#import "CloudKitManager.h"
#import "Person.h"
#import "MD5Extension.h"
#import "UserDefaults.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordField.secureTextEntry = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInOnClick{
    CloudKitManager *manager = [[CloudKitManager alloc]init];
    
    [manager fetchPersonWithUsername:[self.userNameField text] completionHandler:^(Person *person) {
        self.personObject = person;
        NSString *encodedPassword = [self.passwordField.text MD5];
        
        if ([encodedPassword isEqualToString:self.personObject.encodedPasswort]) {
            UserDefaults *userDefault = [[UserDefaults alloc]init];
            [userDefault storeCurrentUser:self.personObject.userName];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//toDo reload parentView
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    NSLog(@"%@", self.parentViewController);
    [self.parentViewController viewDidLoad];
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
