//
//  Person.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface Person : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property (readonly) NSString *fullName;
@property NSString *personId;

//Only for CloudKit
@property CKRecordID *recordId;

- (instancetype)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toDictionary;

@end
