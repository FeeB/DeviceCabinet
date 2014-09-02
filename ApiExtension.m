//
//  apiExtension.m
//  Device Cabinet
//
//  Created by Braun,Fee on 02.09.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "apiExtension.h"
#import "AFNetworking.h"
#import "ErrorMapper.h"

@implementation ApiExtension

- (void)fetchAllDevices:(void (^)(NSArray *, NSError *))completionHandler {
    NSError *error1;
    NSArray *array;
    NSMutableArray *resultObjects;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [self getBackDeviceObjectFromJson:dictionary];
            [resultObjects addObject:device];
        }
         dispatch_async(dispatch_get_main_queue(), ^(void){
             completionHandler(resultObjects, error1);
         });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%zd", error.code);
        ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
        switch (error.code) {
            case 11 : {
                error = [errorMapper itemNotFoundInDatabase];
                break;
            }
                //no connection
            case 4 : {
                error = [errorMapper noConnectionToCloudKit];
                break;
            }
            case 4097: {
                error = [errorMapper noConnectionToCloudKit];
                break;
            }
                //user not logged in to cloudKit
            case 9 : {
                error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                break;
            }
            default: {
                error = [errorMapper somethingWentWrong];
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(array, error);
        });
    }];
}

- (Device *)getBackDeviceObjectFromJson:(NSDictionary *)json{
    Device *device = [[Device alloc] init];
    device.deviceName = [json valueForKey:@"deviceName"];
    device.deviceId = [json valueForKey:@"deviceId"];
    device.category = [json valueForKey:@"category"];
    device.recordId = [json valueForKey:@"id"];
    device.isBooked = [json valueForKey:@"isBooked"];
    device.systemVersion = [json valueForKey:@"systemVersion"];
    
    return device;
}
                        
                        
@end
