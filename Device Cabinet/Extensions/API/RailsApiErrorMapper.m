//  ErrorMapper.m
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "RailsApiErrorMapper.h"

NSString * const RailsApiErrorDomain = @"com.fee.deviceCabinet";
NSInteger const RailsApiNoConnectionErrorCode = 4097;
NSInteger const RailsApiNoConnectionToServerRESTErrorCode = 500;
NSInteger const RailsApiNoConnectionToServerErrorCode = -1004;
NSInteger const RailsApiitemNotFoundInDatabaseRESTErroCode = 404;
NSInteger const RailsApiitemNotFoundInDatabaseCocoaErroCode = 3840;


@implementation RailsApiErrorMapper

+ (NSError *)itemNotFoundInDatabaseError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil)
                               };
   return [[NSError alloc] initWithDomain:RailsApiErrorDomain code:1 userInfo:userInfo];
}

+ (NSError *)noConnectionError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil)
                               };
    return [[NSError alloc] initWithDomain:RailsApiErrorDomain code:2 userInfo:userInfo];
}

+ (NSError *)duplicateDeviceError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_DUPLICATE_DEVICE", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_DUPLICATE_DEVICE", nil)
                               };
    return [[NSError alloc] initWithDomain:RailsApiErrorDomain code:3 userInfo:userInfo];
}

+ (NSError *)somethingWentWrongError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil)
                               };
    return [[NSError alloc] initWithDomain:RailsApiErrorDomain code:4 userInfo:userInfo];
}

+ (NSError *)localErrorWithRemoteError:(NSError *)error
{
    if (!error) {
        return nil;
    }
    switch (error.code) {
        case RailsApiNoConnectionErrorCode:
        case RailsApiNoConnectionToServerRESTErrorCode:
        case RailsApiNoConnectionToServerErrorCode:
            return [RailsApiErrorMapper noConnectionError];
        case RailsApiitemNotFoundInDatabaseRESTErroCode:
        case RailsApiitemNotFoundInDatabaseCocoaErroCode:
            return [RailsApiErrorMapper itemNotFoundInDatabaseError];
        default:
            return [RailsApiErrorMapper somethingWentWrongError];
    }
}

@end
