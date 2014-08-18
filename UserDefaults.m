//
//  UserDefaults.m
//  Device Cabinet
//
//  Created by Braun,Fee on 14.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserDefaults.h"

NSString * const KeyForUserDefaults = @"identifier";
NSString * const KeyForUserType = @"type";

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

- (NSString *)getUserIdentifier {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return [self.userDefaults objectForKey:KeyForUserDefaults];
}

- (NSString *)getUserType {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    return [self.userDefaults objectForKey:KeyForUserType];
}

- (void)storeUserDefaults:(NSString *)uniqueIdentifier userType:(NSString *)userType{
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self.userDefaults setObject:uniqueIdentifier forKey:KeyForUserDefaults];
    [self.userDefaults setObject:userType forKey:KeyForUserType];
    [self.userDefaults synchronize];
}

- (void)resetUserDefaults{
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
