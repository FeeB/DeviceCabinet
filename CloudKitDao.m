//
//  CloudKitManager.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CloudKitDao.h"
#import <CloudKit/CloudKit.h>
#import "Person.h"
#import "Device.h"
#import "CloudKitErrorMapper.h"

NSString* const RecordTypeDevice = @"Devices";
NSString* const RecordTypePerson = @"Persons";
NSString * const PhotoAssetRecordType = @"Photos";
NSString * const PhotoAssetField = @"photo";

NSString * const RecordTypePersonFirstNameField = @"firstName";
NSString * const RecordTypePersonLastNameField = @"lastName";
NSString * const RecordTypePersonUsernameField = @"userName";

NSString * const RecordTypeDeviceIsBookedField = @"booked";
NSString * const RecordTypeDeviceNameField = @"devicename";
NSString * const RecordTypeDeviceCategoryField = @"category";
NSString * const RecordTypeDeviceIdField = @"deviceId";
NSString * const RecordTypeDeviceSystemVersionField = @"systemVersion";
NSString * const RecordTypeDeviceImageField = @"photo";

NSString * const PredicateFormatForDevices = @"devicename = %@";
NSString * const PredicateFormatForPersons = @"userName = %@";
NSString * const PredicateFormatForBookedDevicesFromPerson = @"booked = %@";
NSString * const PredicateFormatForDeviceId = @"deviceId = %@";

@interface CloudKitDao ()

@property (readonly) CKContainer *container;
@property (nonatomic, strong) CKDatabase *publicDatabase;

@end


@implementation CloudKitDao

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
        Device *device = [self deviceFromRecord:record];
        [results addObject:device];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        NSError *localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(results, localError);
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
        
        NSError *localError;
        if (error) {
             localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
        } else {
            //convert the record objects into device objects
            for (CKRecord *record in results) {
                Device *device = [self deviceFromRecord:record];
                [resultObejcts addObject:device];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(resultObejcts, localError);
        });
    }];
}

- (void)fetchDeviceWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(Device *device, NSError *error))completionHandler {
    
    //query with specific user name
    NSPredicate *predicate = [NSPredicate predicateWithFormat:PredicateFormatForDeviceId, deviceId];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypeDevice predicate:predicate];
    
    [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        NSError *localError;
        Device *device;

        if (error) {
            localError = [CloudKitErrorMapper  localErrorWithRemoteError:error];
        } else {
            if (results.count > 0) {
                device = [self deviceFromRecord:results[0]];
            } else {
                localError = [CloudKitErrorMapper itemNotFoundInDatabaseError];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(device, localError);
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
        NSError *localError;
        Person *person;

        if (error) {
            localError = [CloudKitErrorMapper localErrorWithRemoteError:localError];
        } else {
            if (results.count > 0) {
                person = [self personFromRecord:results[0]];
            } else {
                localError = [CloudKitErrorMapper itemNotFoundInDatabaseError];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler(person, error);
        });
    }];
}

//fetch person record with record ID

- (void)fetchPersonRecordWithID:(CKRecordID *)personRecordID completionHandler:(void (^)(Person *person, NSError *error))completionHandler {
    [self.publicDatabase fetchRecordWithID:personRecordID completionHandler:^(CKRecord *record, NSError *error) {
        NSError *localError;
        if (error) {
            localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self personFromRecord:record], localError);
        });
    }];
}

- (void)fetchDeviceRecordWithDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler {
    CKRecordID *deviceRecordID = device.recordId;
    [self.publicDatabase fetchRecordWithID:deviceRecordID completionHandler:^(CKRecord *record, NSError *error) {
        NSError *localError;
        if (error) {
            localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self deviceFromRecord:record], localError);
        });
    }];
}

- (void)storePerson:(Person *)person completionHandler:(void (^)(Person *person, NSError *error))completionHandler {
    CKRecord *personRecord = [self recordFromPerson:person];
    [self.publicDatabase saveRecord:personRecord completionHandler:^(CKRecord *savedPerson, NSError *error) {
        NSError *localError;
        if (error) {
            localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
        }

        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self personFromRecord:savedPerson], localError);
        });
     }];
}

- (void)storeDevice:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler {
    CKRecord *deviceRecord = [self recordFromDevice:device];
    [self.publicDatabase saveRecord:deviceRecord completionHandler:^(CKRecord *savedDevice, NSError *error) {
        NSError *localError;
        if (error) {
            localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            completionHandler([self deviceFromRecord:savedDevice], localError);
        });
    }];
}

//fetch device record with record ID, create a reference on this device record with person record ID and store the device record back

- (void)storePersonObjectAsReferenceWithDevice:(Device *)device person:(Person *)person completionHandler:(void (^)(NSError *error))completionHandler {
    CKRecordID *personID = person.recordId;
    CKRecordID *deviceID = device.recordId;
    //fetch device record
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSError *localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(localError);
            });
        } else {
            //create reference with person record ID
            record[RecordTypeDeviceIsBookedField] = [[CKReference alloc] initWithRecordID:personID action:CKReferenceActionDeleteSelf];
            
            //store device record back
            [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                NSError *localError;
                if (error) {
                    localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler(localError);
                });
            }];
        }

    }];
}

- (void)deleteReferenceInDeviceWithDevice:(Device *)device completionHandler:(void (^)(NSError *error))completionHandler {
    CKRecordID *deviceID = device.recordId;
    //fetch device record
    [self.publicDatabase fetchRecordWithID:deviceID completionHandler:^(CKRecord *record, NSError *error) {
        __block NSError *localError;
        if (error) {
            localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(localError);
            });
        } else {
            record[RecordTypeDeviceIsBookedField] = nil;
            
            //store device record back
            [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                if (error) {
                    localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler(localError);
                });
            }];
            
        }
    }];
}

//Query all Devices which have a reference from one person record ID
- (void)fetchDevicesWithPerson:(Person *)person completionHandler:(void (^)(NSArray *devicesArray, NSError *error))completionHandler {
    CKRecordID *personID = person.recordId;
    //fetch the person record
    [self.publicDatabase fetchRecordWithID:personID completionHandler:^(CKRecord *personRecord, NSError *error){
        if (error) {
            NSError *localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(nil, localError);
            });
        } else {
            //get all devices records which have a reference towards the person record
            //query the devices
            NSPredicate *predicate = [NSPredicate predicateWithFormat:PredicateFormatForBookedDevicesFromPerson, personRecord];
            CKQuery *query = [[CKQuery alloc] initWithRecordType:RecordTypeDevice predicate:predicate];
            
            NSMutableArray *resultObjects = [[NSMutableArray alloc] init];
            
            [self.publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
                NSError *localError;
                if (error) {
                    localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
                }
                    
                //store records as device objects
                for (CKRecord *deviceRecord in results) {
                    Device *device = [self deviceFromRecord:deviceRecord];
                    [resultObjects addObject:device];
                }

                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler(resultObjects, localError);
                });
            }];
        }
    }];
}

- (void)uploadAssetWithURL:(NSURL *)assetURL device:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler {
    CKRecordID *deviceId = device.recordId;
    
    [self.publicDatabase fetchRecordWithID:deviceId completionHandler:^(CKRecord *record, NSError *error) {
        if (error) {
            NSError *localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(nil, localError);
            });
        } else {
            CKAsset *photo = [[CKAsset alloc] initWithFileURL:assetURL];
            record[PhotoAssetField] = photo;
            
            [self.publicDatabase saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
                NSError *localError;
                if (error) {
                    localError = [CloudKitErrorMapper localErrorWithRemoteError:error];
                }
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    completionHandler([self deviceFromRecord:record], error);
                });
            }];
        }
    }];
}

#pragma mark - Mapping Helper

//helper method to get person objects from person records
- (Person *)personFromRecord:(CKRecord *)record {
    Person *person = [[Person alloc]init];
    person.firstName = record[RecordTypePersonFirstNameField];
    person.lastName = record[RecordTypePersonLastNameField];
    person.username = record[RecordTypePersonUsernameField];
    person.recordId = record.recordID;
    
    return person;
}

//helper method to get device objects from device records
- (Device *)deviceFromRecord:(CKRecord *)record {
    Device *device = [[Device alloc]init];
    device.deviceName = record[RecordTypeDeviceNameField];
    device.category = record[RecordTypeDeviceCategoryField];
    device.recordId = record.recordID;
    device.deviceId = record[RecordTypeDeviceIdField];
    device.systemVersion = record[RecordTypeDeviceSystemVersionField];
    
    CKAsset *photoAsset = record[RecordTypeDeviceImageField];
    UIImage *image = [UIImage imageWithContentsOfFile:photoAsset.fileURL.path];
    device.image = image;
    
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
    personRecord[RecordTypePersonUsernameField] = person.username;
    
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
