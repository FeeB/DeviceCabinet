//
//  apiExtension.m
//  Device Cabinet
//
//  Created by Braun,Fee on 02.09.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "RailsApiDao.h"
#import "AFNetworking.h"
#import "RailsApiErrorMapper.h"

@implementation RailsApiDao

- (void)storeDevice:(Device *)device completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"device": device.toDictionary};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackDeviceObjectFromJson:responseObject], nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, error);
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
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
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
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];
}

- (void)fetchDeviceRecordWithDevice:(Device *)device completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%@", device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackDeviceObjectFromJson:responseObject], nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];

}

- (void)fetchDevicesWithPerson:(Person *)person completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"person_id": person.personRecordId};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
           [resultObjects addObject:[self getBackDeviceObjectFromJson:responseObject]];
        }else if ([responseObject isKindOfClass:[NSArray class]]){
            for (NSDictionary *dictionary in responseObject) {
                Device *device = [self getBackDeviceObjectFromJson:dictionary];
                [resultObjects addObject:device];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(resultObjects, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];
}

- (void)fetchDevicesWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"deviceName": deviceName};
    
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
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];

}

- (void)storePerson:(Person *)person completionHandler:(void (^)(Person *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"person": person.toDictionary};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://0.0.0.0:3000/persons" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackPersonObjectFromJson:responseObject], nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, error);
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
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];
}

- (void)storePersonObjectAsReferenceWithDevice:(Device *)device person:(Person *)person completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *storeParameters = @{@"person_id": person.personRecordId, @"isBooked": @"YES"};
    NSDictionary *parameters = @{@"device": storeParameters};
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%@", device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
}

- (void)deleteReferenceInDeviceWithDevice:(Device *)device completionHandler:(void (^)(NSError *))completionHandler {
    NSDictionary *storeParameters = @{@"person_id": (id)[NSNull null], @"isBooked": @"NO"};
    NSDictionary *parameters = @{@"device": storeParameters};
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%@", device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
   
}

- (void)fetchPersonRecordWithID:(NSString *)personRecordId completionHandler:(void (^)(Person *, NSError *))completionHandler{
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/persons/%@", personRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackPersonObjectFromJson:responseObject], nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];

}

- (void)uploadImageWithDevice:(Device *)device completionHandler:(void (^)(NSError *))completionHandler{
    NSDictionary *storeParameters = @{@"image_data_encoded": device.imageData};
    NSDictionary *parameters = @{@"device": storeParameters};
    NSString *url = [[NSString alloc] initWithFormat:@"http://0.0.0.0:3000/devices/%@", device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil);
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
    device.deviceRecordId = [json valueForKey:@"id"];
    device.systemVersion = [json valueForKey:@"systemVersion"];
    
    
    if ([[json valueForKey:@"isBooked"] isEqualToString:@"YES"]) {
        device.isBooked = YES;
        [self fetchPersonRecordWithID:[json valueForKey:@"person_id"] completionHandler:^(Person *person, NSError *error) {
            device.bookedFromPerson = person;
        }];
    } else {
        device.isBooked = NO;
    }
    
    NSURL *imageURL = [NSURL URLWithString:[json valueForKey:@"image_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    device.image = [UIImage imageWithData:imageData];
    
    return device;
}

- (Person *)getBackPersonObjectFromJson:(NSDictionary *)json{
    Person *person = [[Person alloc] init];
    person.firstName = [json valueForKey:@"firstName"];
    person.lastName = [json valueForKey:@"lastName"];
    person.username = [json valueForKey:@"username"];
    person.personRecordId = [json valueForKey:@"id"];
    
    if ([json valueForKey:@"hasBookedDevice"] != (id)[NSNull null]) {
        person.hasBookedDevice = YES;
    } else {
        person.hasBookedDevice = NO;
    }
    
    return person;
}
                        
                        
@end
