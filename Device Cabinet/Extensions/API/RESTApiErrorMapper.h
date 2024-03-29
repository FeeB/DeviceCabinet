//
//  ErrorMapper.h
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTApiErrorMapper : NSObject

+ (NSError *)itemNotFoundInDatabaseError;
+ (NSError *)localErrorWithRemoteError:(NSError *)error;
+ (NSError *)duplicateDeviceError;

@end
