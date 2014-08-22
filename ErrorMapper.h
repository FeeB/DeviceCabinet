//
//  ErrorMapper.h
//  Device Cabinet
//
//  Created by Braun,Fee on 22.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorMapper : NSObject

- (NSError *) itemNotFoundInDatabase;
- (NSError *) noConnectionToCloudKit;
- (NSError *) userIsNotLoggedInWithiCloudAccount;
- (NSError *) somethingWentWrong;

@end
