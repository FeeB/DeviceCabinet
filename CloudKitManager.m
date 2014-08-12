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


// Query all records with the record type devices to get a list of all devices

- (void)fetchDeviceRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *deviceObjects))completionHandler {
    
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];
    //Query with specific record type
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:truePredicate];
    //sort the result with devicenames in ascending order
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"devicename" ascending:YES]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    //fetch records and convert them to device objects
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        Device *device = [self getBackDeviceObjektWithRecord:record];
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

//Get all records with a specific device name (should be just one device)

-(void)fetchDeviceRecordWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *deviceObjects))completionHandler {
    
    //query where with the specific name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"devicename = %@", deviceName];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Devices" predicate:predicate];
    
    NSMutableArray *resultObejcts = [[NSMutableArray alloc] init];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            //convert the record objects into device objects
            for (CKRecord *record in results) {
                Device *device = [self getBackDeviceObjektWithRecord:record];
                [resultObejcts addObject:device];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(resultObejcts);
            });
        }
    }];
}

//Get back one person record from a specific user name
//Because we have to query the record we get back an array with only one record

-(void)fetchPersonRecordWithUserName:(NSString *)userName completionHandler:(void (^)(NSArray *personObjects))completionHandler {
    
    //query with specific user name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Persons" predicate:predicate];
    
     NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            for (CKRecord *record in results) {
                Person *person = [self getBackPersonObjektWithRecord:record];
                [resultObjects addObject:person];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(resultObjects);
            });
        }
    }];
}

//fetch person record with record ID

-(void)fetchPersonRecordWithID:(CKRecordID *)deviceID completionHandler:(void (^)(Person *person))completionHandler{
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error){
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler([self getBackPersonObjektWithRecord:record]);
            });
        }
        
    }];
}

//fetch device record with record ID, create a reference on this device record with person record ID and store the device record back

-(void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personID:(CKRecordID *)personID completionHandler:(void (^)(CKRecord *record))completionHandler{
    //fetch device record
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            //create reference with person record ID
            CKReference *bookedReference = [[CKReference alloc] initWithRecordID:personID action:CKReferenceActionNone];
            record[@"booked"] = bookedReference;
            
            //store device record back
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

//Query all Devices which have a reference from one person record ID
-(void)getBackAllBookedDevicesWithPersonID:(CKRecordID *)personID completionHandler:(void (^)(NSArray *devicesArray))completionHandler{
    //fetch the person record
    [self.publicDatabase fetchRecordWithID:personID completionHandler:^(CKRecord *personRecord, NSError *error){
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            //get all devices records which have a reference towards the person record
            //query the devices
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"booked = %@", personRecord];
            CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Devices" predicate:predicate];
                
            NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
                
            [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
                if (error) {
                    // In your app, this error needs love and care.
                    NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
                    abort();
                } else {
                    //store records as device objects
                    for (CKRecord *deviceRecord in results) {
                        Device *device = [self getBackDeviceObjektWithRecord:deviceRecord];
                        [resultObjects addObject:device];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        completionHandler(resultObjects);
                    });
                }
            }];

        }
        
    }];
    
}

//helper method to get person objects from person records
-(Person *)getBackPersonObjektWithRecord:(CKRecord *)record {
    Person *person = [[Person alloc]init];
    person.firstName = record[@"firstName"];
    person.lastName = record[@"lastName"];
    person.ID = record.recordID;
        
    return person;
}

//helper method to get device objects from device records
-(Device *)getBackDeviceObjektWithRecord:(CKRecord *)record {
    Device *device = [[Device alloc]init];
    device.deviceName = record[@"devicename"];
    device.category = record[@"category"];
    
    device.ID = record.recordID;
    
    //if device record has a reference to a person record
    if (record[@"booked"] != nil) {
        device.isBooked = true;
        CKReference *reference = record[@"booked"];
        [self fetchPersonRecordWithID:reference.recordID completionHandler:^(Person *person) {
            device.bookedFromPerson = person;
        }];
    }

    
    return device;
}

@end
