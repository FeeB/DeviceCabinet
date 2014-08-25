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
#import "ErrorMapper.h"

NSString* const RecordTypeDevice = @"Devices";
NSString* const RecordTypePerson = @"Persons";

NSString * const RecordTypePersonFirstNameField = @"firstName";
NSString * const RecordTypePersonLastNameField = @"lastName";
NSString * const RecordTypePersonPasswordField = @"password";
NSString * const RecordTypePersonUsernameField = @"userName";
NSString * const RecordTypePersonIsAdminSwitch = @"isAdmin";

NSString * const RecordTypeDeviceIsBookedField = @"booked";
NSString * const RecordTypeDeviceNameField = @"devicename";
NSString * const RecordTypeDeviceCategoryField = @"category";
NSString * const RecordTypeDeviceIdField = @"deviceId";
NSString * const RecordTypeDeviceSystemVersionField = @"systemVersion";

NSString * const PredicateFormatForDevices = @"devicename = %@";
NSString * const PredicateFormatForPersons = @"userName = %@";
NSString * const PredicateFormatForBookedDevicesFromPerson = @"booked = %@";
NSString * const PredicateFormatForDeviceId = @"deviceId = %@";

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

- (void)fetchDevicesWithCompletionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler {
    
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];
    //Query with specific record type
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypeDevice predicate:truePredicate];
    //sort the result with devicenames in ascending order
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:RecordTypeDeviceNameField ascending:YES]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    //fetch records and convert them to device objects
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        Device *device = [self getBackDeviceObjectWithRecord:record];
        [results addObject:device];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(results, error);
        });
    };
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    [publicDatabase addOperation:queryOperation];
}

//Get all records with a specific device name (should be just one device)

- (void)fetchDevicesWithDeviceName:(NSString *)deviceName completionHandler:(void (^)(NSArray *deviceObjects, NSError *error))completionHandler {
    
    //query where with the specific name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:PredicateFormatForDevices, deviceName];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypeDevice predicate:predicate];
    
    NSMutableArray *resultObejcts = [[NSMutableArray alloc] init];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }else {
            //convert the record objects into device objects
            for (CKRecord *record in results) {
                Device *device = [self getBackDeviceObjectWithRecord:record];
                [resultObejcts addObject:device];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(resultObejcts, error);
            });
        }
    }];
}

- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler {
    
    //query with specific user name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:PredicateFormatForDeviceId, deviceId];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypeDevice predicate:predicate];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        
        Device *device;
        if (results.count > 0) {
            device = [self getBackDeviceObjectWithRecord:results[0]];
        } else if (!error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            error = [errorMapper itemNotFoundInDatabase];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(device, error);
        });
    }];
}

//Get back one person record from a specific user name
//Because we have to query the record we get back an array with only one record

- (void)fetchPersonWithUsername:(NSString *)userName completionHandler:(void (^)(Person *person, NSError *error))completionHandler {

    //query with specific user name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:PredicateFormatForPersons, userName];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypePerson predicate:predicate];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        Person *person;
        if (results.count > 0) {
            person = [self getBackPersonObjectWithRecord:results[0]];
        } else if (!error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            error = [errorMapper itemNotFoundInDatabase];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(person, error);
        });
    }];
}

//fetch person record with record ID

- (void)fetchPersonRecordWithID:(CKRecordID *)deviceID completionHandler:(void (^)(Person *person, NSError *error))completionHandler {
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self getBackPersonObjectWithRecord:record], error);
        });
    }];
}

- (void)storePerson:(Person *)person completionHandler:(void (^)(NSError *error))completionHandler {
    CKRecord *personRecord = [self recordFromPerson:person];
    [self.publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *savedPerson, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
     }];
}

- (void)storeDevice:(Device *)device completionHandler:(void (^)(NSError *error))completionHandler {
    CKRecord *deviceRecord = [self recordFromDevice:device];
    [self.publicDatabase saveRecord:deviceRecord completionHandler:^(CKRecord *savedPerson, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(error);
        });
    }];
}

//fetch device record with record ID, create a reference on this device record with person record ID and store the device record back

- (void)storePersonObjectAsReferenceWithDeviceID:(CKRecordID *)deviceID personID:(CKRecordID *)personID completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler {
    //fetch device record
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        //create reference with person record ID
        CKReference *bookedReference = [[CKReference alloc] initWithRecordID:personID action:CKReferenceActionDeleteSelf];
        record[RecordTypeDeviceIsBookedField] = bookedReference;
        
        //store device record back
        [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
            if (error) {
                ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
                switch (error.code) {
                    case 11 : {
                        error = [errorMapper itemNotFoundInDatabase];
                        break;
                    }
                        //no connection
                    case 4 : {
                        error = [errorMapper noConnectionToCloudKit];
                        break;
                    }
                    case 4097: {
                        error = [errorMapper noConnectionToCloudKit];
                        break;
                    }
                        //user not logged in to cloudKit
                    case 9 : {
                        error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                        break;
                    }
                    default: {
                        error = [errorMapper somethingWentWrong];
                        break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(record, error);
            });
        }];
    }];
}

- (void)deleteReferenceInDeviceWithDeviceID:(CKRecordID *)deviceID completionHandler:(void (^)(CKRecord *record, NSError *error))completionHandler {
    //fetch device record
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        CKReference *bookedReference;
        record[RecordTypeDeviceIsBookedField] = bookedReference;
        
        //store device record back
        [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
            if (error) {
                ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
                switch (error.code) {
                    case 11 : {
                        error = [errorMapper itemNotFoundInDatabase];
                        break;
                    }
                        //no connection
                    case 4 : {
                        error = [errorMapper noConnectionToCloudKit];
                        break;
                    }
                    case 4097: {
                        error = [errorMapper noConnectionToCloudKit];
                        break;
                    }
                        //user not logged in to cloudKit
                    case 9 : {
                        error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                        break;
                    }
                    default: {
                        error = [errorMapper somethingWentWrong];
                        break;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(record, error);
            });
        }];
    }];
}

//Query all Devices which have a reference from one person record ID
- (void)fetchDevicesWithPersonID:(CKRecordID *)personID completionHandler:(void (^)(NSArray *devicesArray, NSError *error))completionHandler {
    //fetch the person record
    [self.publicDatabase fetchRecordWithID:personID completionHandler:^(CKRecord *personRecord, NSError *error){
        if (error) {
            ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
            switch (error.code) {
                case 11 : {
                    error = [errorMapper itemNotFoundInDatabase];
                    break;
                }
                    //no connection
                case 4 : {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                case 4097: {
                    error = [errorMapper noConnectionToCloudKit];
                    break;
                }
                    //user not logged in to cloudKit
                case 9 : {
                    error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                    break;
                }
                default: {
                    error = [errorMapper somethingWentWrong];
                    break;
                }
            }
        }
        //get all devices records which have a reference towards the person record
        //query the devices
        NSPredicate *predicate = [NSPredicate predicateWithFormat:PredicateFormatForBookedDevicesFromPerson, personRecord];
        CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypeDevice predicate:predicate];
        
        NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
        
        [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
            if (error) {
                ErrorMapper *errorMapper = [[ErrorMapper alloc] init];
                switch (error.code) {
                    case 11 : {
                        error = [errorMapper itemNotFoundInDatabase];
                        break;
                    }
                        //no connection
                    case 4 : {
                        error = [errorMapper noConnectionToCloudKit];
                        break;
                    }
                    case 4097: {
                        error = [errorMapper noConnectionToCloudKit];
                        break;
                    }
                        //user not logged in to cloudKit
                    case 9 : {
                        error = [errorMapper userIsNotLoggedInWithiCloudAccount];
                        break;
                    }
                    default: {
                        error = [errorMapper somethingWentWrong];
                        break;
                    }
                }
            }
            //store records as device objects
            for (CKRecord *deviceRecord in results) {
                Device *device = [self getBackDeviceObjectWithRecord:deviceRecord];
                [resultObjects addObject:device];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler(resultObjects, error);
                });
            }
        }];

    }];
}

//helper method to get person objects from person records
- (Person *)getBackPersonObjectWithRecord:(CKRecord *)record {
    Person *person = [[Person alloc]init];
    person.firstName = record[RecordTypePersonFirstNameField];
    person.lastName = record[RecordTypePersonLastNameField];
    person.userName = record[RecordTypePersonUsernameField];
    person.recordId = record.recordID;
    
    return person;
}

//helper method to get device objects from device records
- (Device *)getBackDeviceObjectWithRecord:(CKRecord *)record {
    Device *device = [[Device alloc]init];
    device.deviceName = record[RecordTypeDeviceNameField];
    device.category = record[RecordTypeDeviceCategoryField];
    device.recordId = record.recordID;
    device.deviceId = record[RecordTypeDeviceIdField];
    device.systemVersion = record[RecordTypeDeviceSystemVersionField];
    
    //if device record has a reference to a person record
    if (record[RecordTypeDeviceIsBookedField] != nil) {
        device.isBooked = true;
        CKReference *reference = record[RecordTypeDeviceIsBookedField];
        [self fetchPersonRecordWithID:reference.recordID completionHandler:^(Person *person, NSError *error) {
            device.bookedFromPerson = person;
        }];
    }else{
        device.isBooked = false;
    }
    return device;
}

- (CKRecord *)recordFromPerson:(Person *)person {
    CKRecord *personRecord = [[CKRecord alloc] initWithRecordType:RecordTypePerson];
    personRecord[RecordTypePersonFirstNameField] = person.firstName;
    personRecord[RecordTypePersonLastNameField] = person.lastName;
    personRecord[RecordTypePersonUsernameField] = person.userName;
    
    return personRecord;
}

- (CKRecord *)recordFromDevice:(Device *)device {
    CKRecord *deviceRecord = [[CKRecord alloc] initWithRecordType:RecordTypeDevice];
    [deviceRecord setObject:device.deviceName forKey: RecordTypeDeviceNameField];
    [deviceRecord setObject:device.category forKey: RecordTypeDeviceCategoryField];
    [deviceRecord setObject:device.deviceId forKey:RecordTypeDeviceIdField];
    [deviceRecord setObject:device.systemVersion forKey:RecordTypeDeviceSystemVersionField];
    
    return deviceRecord;
}

@end
