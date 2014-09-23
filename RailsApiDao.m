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

#define ROOT_URL @"http://cryptic-journey-8537.herokuapp.com/"

NSString* const DevicePath = ROOT_URL @"devices";
NSString* const DevicePathWithId = ROOT_URL @"devices/%@";
NSString* const PersonPath = ROOT_URL @"persons";
NSString* const PersonPathWithId = ROOT_URL @"persons/%@";

@implementation RailsApiDao

- (void)storeDevice:(Device *)device completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSDictionary *parameters = @{@"device": device.toDictionary};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:DevicePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Device *device = [[Device alloc] initWithJson:responseObject];
            completionHandler(device, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, error);
        });
    }];

}

- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:DevicePath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [[Device alloc] initWithJson:dictionary];
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
    [manager GET:DevicePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Device *device = [[Device alloc] initWithJson:responseObject];
            completionHandler(device, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];
}

- (void)fetchDeviceRecordWithDevice:(Device *)device completionHandler:(void (^)(Device *, NSError *))completionHandler {
    NSString *url = [[NSString alloc] initWithFormat:DevicePathWithId, device.deviceRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Device *device = [[Device alloc] initWithJson:responseObject];
            completionHandler(device, nil);
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
    [manager GET:DevicePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            Device *device = [[Device alloc] initWithJson:responseObject];
           [resultObjects addObject:device];
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictionary in responseObject) {
                Device *device = [[Device alloc] initWithJson:dictionary];
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
    [manager GET:DevicePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in responseObject) {
            Device *device = [[Device alloc] initWithJson:dictionary];
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
    [manager POST:PersonPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Person *person = [[Person alloc] initWithJson:responseObject];
            completionHandler(person, nil);
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
    [manager GET:PersonPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Person *person = [[Person alloc] initWithJson:responseObject];
            completionHandler(person, nil);
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
    NSString *url = [NSString stringWithFormat:DevicePathWithId, device.deviceRecordId];
    
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
    NSString *url = [NSString stringWithFormat:DevicePathWithId, device.deviceRecordId];
    
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
    NSString *url = [[NSString alloc] initWithFormat:PersonPathWithId, personRecordId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            Person *person = [[Person alloc] initWithJson:responseObject];
            completionHandler(person, nil);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *localError = [RailsApiErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(nil, localError);
        });
    }];

}

- (NSData *)resizedJpegDataForImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(512, 512);
    
    if (image.size.width > image.size.height) {
        newSize.height = round(newSize.width * image.size.height / image.size.width);
    } else {
        newSize.width = round(newSize.height * image.size.width / image.size.height);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    NSData *data = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.75);
    UIGraphicsEndImageContext();
    
    return data;
}

- (void)uploadImage:(UIImage*)image forDevice:(Device *)device completionHandler:(void (^)(NSError *))completionHandler {
    NSData *imageAsResizedJpegData = [self resizedJpegDataForImage:image];
    NSString *imageBase64Encoded = [imageAsResizedJpegData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *storeParameters = @{@"image_data_encoded": imageBase64Encoded};
    NSDictionary *parameters = @{@"device": storeParameters};
    NSString *url = [[NSString alloc] initWithFormat:DevicePathWithId, device.deviceRecordId];
    
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
                        
@end
