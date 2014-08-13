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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [cloudManager fetchPersonWithUsername:[userDefaults objectForKey:@"userName"] completionHandler:^(Person *person) {
        self.person = person;
        
        [cloudManager resetPasswordFromPersonObjectWithPersonID:self.person.ID password:[self.password.text MD5] completionHandler:^(CKRecord *record) {
            if (record) {
                NSLog(@"toDo: Was hier");
            }
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
