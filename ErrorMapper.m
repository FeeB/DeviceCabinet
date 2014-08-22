//
//  ErrorMapper.m
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "ErrorMapper.h"

NSString * const ErrorDomain = @"com.fee.deviceCabinet";

@implementation ErrorMapper

- (NSError *) itemNotFoundInDatabase {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil)
                               };
   return [[NSError alloc] initWithDomain:ErrorDomain code:1 userInfo:userInfo];
}

- (NSError *) noConnectionToCloudKit {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil)
                               };
    return [[NSError alloc] initWithDomain:ErrorDomain code:2 userInfo:userInfo];
}

- (NSError *) userIsNotLoggedInWithiCloudAccount {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_NO_ICLOUD", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_NO_ICLOUD", nil)
                               };
    return [[NSError alloc] initWithDomain:ErrorDomain code:3 userInfo:userInfo];
}

- (NSError *) somethingWentWrong {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil)
                               };
    return [[NSError alloc] initWithDomain:ErrorDomain code:4 userInfo:userInfo];
}

@end
