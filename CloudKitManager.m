//
//  CloudKitManager.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CloudKitManager.h"
#import <CloudKit/CloudKit.h>
#import "Person.h"
#import "Device.h"

@interface CloudKitManager ()

@property (readonly) CKContainer *container;
@property (readonly) CKDatabase *publicDatabase;

@end


@implementation CloudKitManager

- (id)init {
    self = [super init];
    if (self) {
        _container = [CKContainer defaultContainer];
        _publicDatabase = [_container publicCloudDatabase];
    }
    
    return self;
}


- (void)fetchDeviceRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler {
    
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:truePredicate];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"devicename" ascending:YES]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    // Just request the name field for all records
    //queryOperation.desiredKeys = @[@"devicename"];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        Device *device = [[Device alloc]init];
        device = [self getBackDeviceObjektWithRecord:record];
        [results addObject:device];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(results);
            });
        }
    };
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    [publicDatabase addOperation:queryOperation];
}

-(void)fetchDeviceRecordWithDeviceName:(NSString *)recordName completionHandler:(void (^)(NSArray *records))completionHandler {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"devicename = %@", recordName];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Devices" predicate:predicate];
    
    NSMutableArray *resultObejcts = [[NSMutableArray alloc] init];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            for (CKRecord *record in results) {
                Device *device = [[Device alloc]init];
                device = [self getBackDeviceObjektWithRecord:record];
                [resultObejcts addObject:device];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(resultObejcts);
            });
        }
    }];
}

-(void)fetchPersonRecordWithPersonName:(NSString *)recordName completionHandler:(void (^)(NSArray *records))completionHandler {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastName = %@", recordName];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Persons" predicate:predicate];
    
     NSMutableArray *resultObejcts = [[NSMutableArray alloc] init];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            for (CKRecord *record in results) {
                Person *person = [[Person alloc]init];
                person = [self getBackPersonObjektWithRecord:record];
                [resultObejcts addObject:person];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(results);
            });
        }
    }];
}

-(void)fetchPersonRecordWithID:(CKRecordID *)recordID completionHandler:(void (^)(CKRecord *record))completionHandler{
    [self.publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *record, NSError *error){
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(record);
            });
        }
        
    }];
}

-(void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personIf:(CKRecordID *)personID completionHandler:(void (^)(CKRecord *record))completionHandler{
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {

            CKReference *bookedReference = [[CKReference alloc] initWithRecordID:personID action:CKReferenceActionNone];
            record[@"booked"] = bookedReference;
            
            [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@ saved: %@", error, record);
                } else {
                    NSLog(@"Success");
                }
            }];
        }
    }];
}

-(Person *)getBackPersonObjektWithRecord:(CKRecord *)record {
    Person *person = [[Person alloc]init];
    person.firstName = record[@"firstName"];
    person.lastName = record[@"lastName"];
    person.ID = record.recordID;
    
    return person;
}

-(Device *)getBackDeviceObjektWithRecord:(CKRecord *)record {
    Device *device = [[Device alloc]init];
    device.deviceName = record[@"devicename"];
    device.category = record[@"category"];
    device.bookedFromPerson = record[@"booked"];
    device.ID = record.recordID;
    
    if (device.bookedFromPerson != nil) {
        device.isBooked = true;
    }

    
    return device;
}

@end
