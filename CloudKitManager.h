//
//  CloudKitManager.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface CloudKitManager : NSObject

- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler;
-(void)fetchRecordWithDeviceName:(NSString *)recordName completionHandler:(void (^)(NSArray *records))completionHandler;
-(void)fetchRecordWithPersonName:(NSString *)recordName completionHandler:(void (^)(NSArray *records))completionHandler;

@end
