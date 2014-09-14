//
//  ErrorMapper.m
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "RailsApiErrorMapper.h"

NSString * const ErrorDomain = @"com.fee.deviceCabinet";
NSInteger const NoConnectionErrorCode = 4097;

@implementation RailsApiErrorMapper

+ (NSError *)itemNotFoundInDatabaseError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil)
                               };
   return [[NSError alloc] initWithDomain:ErrorDomain code:1 userInfo:userInfo];
}

+ (NSError *)noConnectionError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil)
                               };
    return [[NSError alloc] initWithDomain:ErrorDomain code:2 userInfo:userInfo];
}

+ (NSError *)somethingWentWrongError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil)
                               };
    return [[NSError alloc] initWithDomain:ErrorDomain code:4 userInfo:userInfo];
}

+ (NSError *)localErrorWithRemoteError:(NSError *)error
{
    if (!error) {
        return nil;
    }
    switch (error.code) {
        case NoConnectionErrorCode:
            return [RailsApiErrorMapper noConnectionError];
            
        default:
            return [RailsApiErrorMapper somethingWentWrongError];
            
    }
}

@end
