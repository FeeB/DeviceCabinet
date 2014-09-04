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

- (void)storeDevice:(NSData *)deviceJson completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *parameters = @{@"device": deviceJson};
    NSError *error1;
    NSLog(@"%@", parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
}

- (void)fetchAllDevices:(void (^)(NSArray *, NSError *))completionHandler {
    NSError *error1;
    NSArray *array;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
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

- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSError *error1;
    Device *device;
    NSDictionary *parameters = @{@"deviceId": deviceId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackDeviceObjectFromJson:responseObject], error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
            completionHandler(device, error);
        });
    }];
}

- (void)fetchDevicesWithPersonId:(NSInteger *)personRecordId completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    NSError *error1;
    NSArray *array;
    NSDictionary *parameters = @{@"personId": [NSNumber numberWithInteger:*personRecordId]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [self getBackDeviceObjectFromJson:dictionary];
            [resultObjects addObject:device];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(resultObjects, error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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

- (void)storePerson:(NSData *)personJson completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *parameters = @{@"person": personJson};
    NSError *error1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://0.0.0.0:3000/persons" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
}

- (void)fetchPersonWithUsername:(NSString *)username completionHandler:(void (^)(Person *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"username": username};
    NSError *error1;
    Person *person;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/persons" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackPersonObjectFromJson:responseObject], error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
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
            completionHandler(person, error);
        });

    }];
}

- (void)storeReferenceToBookedDeviceWithDeviceId:(int *)recordDeviceId personId:(int *)personRecordId completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *parameters = @{@"personId": [NSNumber numberWithInteger:*personRecordId]};
    NSError *error1;
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%d", *recordDeviceId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
}

- (void)deleteReferenceFromBookedDeviceWithDeviceId:(int *)recordDeviceId personId:(int *)recordPersonId completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *parameters = @{@"personId": (id)[NSNull null]};
    NSError *error1;
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%d", *recordDeviceId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error1);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];

}

- (Device *)getBackDeviceObjectFromJson:(NSDictionary *)json{
    Device *device = [[Device alloc] init];
    device.deviceName = [json valueForKey:@"deviceName"];
    device.deviceId = [json valueForKey:@"deviceId"];
    device.category = [json valueForKey:@"category"];
    device.recordId = [json valueForKey:@"id"];
    device.systemVersion = [json valueForKey:@"systemVersion"];
    
    NSLog(@"%@", [json valueForKey:@"isBooked"]);
    
    if ([[json valueForKey:@"isBooked"] isEqualToString:@"YES"]) {
        device.isBooked = YES;
    } else {
        device.isBooked = NO;
    }
    
    return device;
}

- (Person *)getBackPersonObjectFromJson:(NSDictionary *)json{
    Person *person = [[Person alloc] init];
    person.firstName = [json valueForKey:@"firstName"];
    person.lastName = [json valueForKey:@"lastName"];
    person.userName = [json valueForKey:@"userName"];
    person.recordId = [json valueForKey:@"id"];
    
    if ([json valueForKey:@"hasBookedDevice"] != (id)[NSNull null]) {
        person.hasBookedDevice = YES;
    } else {
        person.hasBookedDevice = NO;
    }
    
    return person;
}
                        
                        
@end
