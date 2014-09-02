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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://0.0.0.0:3000/devices/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         dispatch_async(dispatch_get_main_queue(), ^(void){
             [self getBackDeviceObjectFromJson:responseObject];
             completionHandler(responseObject, error1);
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

- (void)getBackDeviceObjectFromJson:(NSData *)json{
    NSError * error=nil;
    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];
    
    NSLog(@"%@", parsedData);
    
}
                        
                        
@end
