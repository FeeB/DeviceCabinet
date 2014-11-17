//
//  ErrorMapper.m
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CloudKitErrorMapper.h"

NSString * const CloudKitErrorDomain = @"com.fee.deviceCabinet";
NSInteger const CloudKitItemNotFoundInDatabaseErrorCode = 11;
NSInteger const CloudKitNoConnectionToCloudKitErrorCode = 4;
NSInteger const CloudKitNoConnectionErrorCode = 4097;
NSInteger const CloudKitUserIsNotLoggedInWithiCloudAccountErrorCode = 9;

@implementation CloudKitErrorMapper

+ (NSError *)itemNotFoundInDatabaseError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil)
                               };
   return [[NSError alloc] initWithDomain:CloudKitErrorDomain code:1 userInfo:userInfo];
}

+ (NSError *)noConnectionError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION_CLOUDKIT", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil)
                               };
    return [[NSError alloc] initWithDomain:CloudKitErrorDomain code:2 userInfo:userInfo];
}

+ (NSError *)userIsNotLoggedInWithiCloudAccountError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_ICLOUD", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_ICLOUD", nil)
                               };
    return [[NSError alloc] initWithDomain:CloudKitErrorDomain code:3 userInfo:userInfo];
}

+ (NSError *)somethingWentWrongError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil)
                               };
    return [[NSError alloc] initWithDomain:CloudKitErrorDomain code:4 userInfo:userInfo];
}

+ (NSError *)localErrorWithRemoteError:(NSError *)error
{
    if (!error) {
        return nil;
    }
    switch (error.code) {
        case CloudKitItemNotFoundInDatabaseErrorCode:
            return [CloudKitErrorMapper itemNotFoundInDatabaseError];
            
        case CloudKitNoConnectionToCloudKitErrorCode:
        case CloudKitNoConnectionErrorCode:
            return [CloudKitErrorMapper noConnectionError];
            
        case CloudKitUserIsNotLoggedInWithiCloudAccountErrorCode:
            return [CloudKitErrorMapper userIsNotLoggedInWithiCloudAccountError];
            
        default:
            return [CloudKitErrorMapper somethingWentWrongError];
            
    }
}

@end