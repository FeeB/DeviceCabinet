//
//  FirstLaunchHandler.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 13.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import "FirstLaunchHandler.h"

@implementation FirstLaunchHandler

- (void)storeDeviceFromKeychainWithCompletionHandler:(void (^)(BOOL))completionHandler {
    UIdGenerator *generator = [[UIdGenerator alloc]init];
    NSString *uid = [generator getIdfromKeychain];
    
    [AppDelegate.dao fetchDeviceWithDeviceId:uid completionHandler:^(Device *device, NSError *error) {
        if (error) {
            if (![RailsApiErrorMapper itemNotFoundInDatabaseError]) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler(NO);
                });
            }
        } else {
            [self storeDeviceWithDevice:device];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(YES);
            });
        }
    }];
}

@end
