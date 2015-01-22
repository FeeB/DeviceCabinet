//  ErrorMapper.m
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "RESTApiErrorMapper.h"

NSString * const RESTApiErrorDomain = @"com.fee.deviceCabinet";
NSInteger const RESTApiNoConnectionErrorCode = 4097;
NSInteger const RESTApiNoConnectionToServerRESTErrorCode = 500;
NSInteger const RESTApiNoConnectionToServerErrorCode = -1009;
NSInteger const RESTApiitemNotFoundInDatabaseRESTErroCode = 404;
NSInteger const RESTApiitemNotFoundInDatabaseCocoaErroCode = 3840;


@implementation RESTApiErrorMapper

+ (NSError *)itemNotFoundInDatabaseError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil)
                               };
   return [[NSError alloc] initWithDomain:RESTApiErrorDomain code:1 userInfo:userInfo];
}

+ (NSError *)noConnectionError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil)
                               };
    return [[NSError alloc] initWithDomain:RESTApiErrorDomain code:2 userInfo:userInfo];
}

+ (NSError *)duplicateDeviceError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_DUPLICATE_DEVICE", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_DUPLICATE_DEVICE", nil)
                               };
    return [[NSError alloc] initWithDomain:RESTApiErrorDomain code:3 userInfo:userInfo];
}

+ (NSError *)somethingWentWrongError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil)
                               };
    return [[NSError alloc] initWithDomain:RESTApiErrorDomain code:4 userInfo:userInfo];
}

+ (NSError *)localErrorWithRemoteError:(NSError *)error
{
    if (!error) {
        return nil;
    }
    switch (error.code) {
        case RESTApiNoConnectionErrorCode:
        case RESTApiNoConnectionToServerRESTErrorCode:
        case RESTApiNoConnectionToServerErrorCode:
            return [RESTApiErrorMapper noConnectionError];
        case RESTApiitemNotFoundInDatabaseRESTErroCode:
        case RESTApiitemNotFoundInDatabaseCocoaErroCode:
            return [RESTApiErrorMapper itemNotFoundInDatabaseError];
        default:
            return [RESTApiErrorMapper somethingWentWrongError];
    }
}

@end
