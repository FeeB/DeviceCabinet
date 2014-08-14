//
//  UserDefaults.m
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserDefaults.h"

NSString * const KeyForUserDefaults = @"username";

@interface UserDefaults ()

@end

@implementation UserDefaults

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getCurrentUsername{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return [self.userDefaults objectForKey:KeyForUserDefaults];
}

- (void)storeCurrentUser:(NSString *)username{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self.userDefaults setObject:username forKey:KeyForUserDefaults];
    [self.userDefaults synchronize];
}

- (void)resetCurrentUser{
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
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
