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

- (void)storeDevice:(Device *)device completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *parameters = @{@"device": device.toDictionary};
    NSLog(@"%@", parameters);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];

}

- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [self getBackDeviceObjectFromJson:dictionary];
            [resultObjects addObject:device];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(resultObjects, nil);
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
            completionHandler(nil, error);
        });
    }];
}

- (void) fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"deviceId": deviceId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackDeviceObjectFromJson:responseObject], nil);
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
            completionHandler(nil, error);
        });
    }];
}

- (void)fetchDeviceRecordWithDevice:(Device *)device completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"deviceId":[NSNumber numberWithInteger:*device.deviceRecordId]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackDeviceObjectFromJson:responseObject], nil);
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
            completionHandler(nil, error);
        });
    }];

}

- (void)fetchDevicesWithPerson:(Person *)person completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"personId": [NSNumber numberWithInteger:*person.personRecordId]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [self getBackDeviceObjectFromJson:dictionary];
            [resultObjects addObject:device];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(resultObjects, nil);
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
            completionHandler(nil, error);
        });
    }];
}

- (void)fetchDevicesWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"deviceId": deviceName};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [self getBackDeviceObjectFromJson:dictionary];
            [resultObjects addObject:device];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(resultObjects, nil);
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
            completionHandler(nil, error);
        });
    }];

}

- (void)storePerson:(Person *)person completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *parameters = @{@"person": person.toDictionary};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://0.0.0.0:3000/persons" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
}

- (void)fetchPersonWithUsername:(NSString *)userName completionHandler:(void (^)(Person *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"username": userName};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/persons" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackPersonObjectFromJson:responseObject], nil);
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
            completionHandler(nil, error);
        });
    }];
}

- (void)storePersonObjectAsReferenceWithDevice:(Device *)device person:(Person *)person completionHandler:(void (^)(CKRecord *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"personId": [NSNumber numberWithInteger:*person.personRecordId]};
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%d", *device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(responseObject, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, error);
        });
    }];
   
}

- (void)deleteReferenceInDeviceWithDevice:(Device *)device completionHandler:(void (^)(CKRecord *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"personId": (id)[NSNull null]};
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%d", *device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(responseObject, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, error);
        });
    }];
   
}

- (void)uploadAssetWithURL:(NSURL *)assetURL device:(Device *)device completionHandler:(void (^)(Device *, NSError *))completionHandler{
    //toDo
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
