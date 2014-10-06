//
//  apiExtension.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.09.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceCabinetDAO.h"

@interface RailsApiDao : NSObject <DeviceCabinetDao>

- (void)uploadImage:(UIImage*)image forDevice:(Device *)device completionHandler:(void (^)(NSError *))completionHandler;
- (void)fetchPeopleWithCompletionHandler:(void (^)(NSArray *personObjects, NSError *error))completionHandler;
- (void)fetchPersonWithFullName:(NSString *)fullName completionHandler:(void (^)(Person *person, NSError *error))completionHandler;

@end
