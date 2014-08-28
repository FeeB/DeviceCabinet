//
//  CloudKitManagerTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 26.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CloudKitManager.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface CloudKitManager (Manager_Test)
- (CKRecord *)recordFromDevice:(Device *)device;
- (CKRecord *)recordFromPerson:(Person *)person;
- (Device *)getBackDeviceObjectWithRecord:(CKRecord *)record;
- (Person *)getBackPersonObjectWithRecord:(CKRecord *)record;
@end

@interface CloudKitManagerTestCase : XCTestCase
@end

@implementation CloudKitManagerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testGetRecordFromPerson {
    Person *person = [self createATestPerson];
    
    CloudKitManager *manager = [[CloudKitManager alloc] init];
    CKRecord *record = [manager recordFromPerson:person];
    
    XCTAssertEqualObjects(record[@"firstName"], person.firstName, @"The first name of the person should be the same in the record");
    XCTAssertEqualObjects(record[@"lastName"], person.lastName, @"The last name of the person should be the same in the record");
    XCTAssertEqualObjects(record[@"userName"], person.userName, @"The username of the person should be the same in the record");
}

- (void)testGetRecordFromDevice {
    Device *device = [self createATestDevice];
    
    CloudKitManager *manager = [[CloudKitManager alloc] init];
    CKRecord *record = [manager recordFromDevice:device];
    
    XCTAssertEqualObjects(record[@"devicename"], device.deviceName, @"The devicename of the device should be the same in the record");
    XCTAssertEqualObjects(record[@"category"], device.category, @"The category of the device should be the same in the record");
    XCTAssertEqualObjects(record[@"deviceId"], device.deviceId, @"The device ID of the device should be the same in the record");
    XCTAssertEqualObjects(record[@"systemVersion"], device.systemVersion, @"The system version of the device should be the same in the record");
}

- (void)testGetBackDeviceObjectWithRecord {
    CKRecord *record = [self createATestDeviceRecord];
    
    CloudKitManager *manager = [[CloudKitManager alloc] init];
    Device *device = [manager getBackDeviceObjectWithRecord:record];
    
    XCTAssertEqualObjects(device.deviceName, record[@"devicename"], @"The devicename in the record should be the same in the device object");
    XCTAssertEqualObjects(device.category, record[@"category"], @"The category in the record should be the same in the device object");
    XCTAssertEqualObjects(device.deviceId, record[@"deviceId"], @"The device ID in the record should be the same in the device object");
    XCTAssertEqualObjects(device.systemVersion, record[@"systemVersion"], @"The system Version in the record should be the same in the device object");
}

- (void)testGetBackPersonObjectWithRecord {
    CKRecord *record = [self createATestPersonRecord];
    
    CloudKitManager *manager = [[CloudKitManager alloc] init];
    Person *person = [manager getBackPersonObjectWithRecord:record];
    
    XCTAssertEqualObjects(person.firstName, record[@"firstName"], @"The first name in the record should be the same in the person object");
    XCTAssertEqualObjects(person.lastName, record[@"lastName"], @"The last name in the record should be the same in the person object");
    XCTAssertEqualObjects(person.userName, record[@"userName"], @"The username in the record should be the same in the person object");
}

- (Device *)createATestDevice {
    Device *device = [[Device alloc] init];
    device.deviceName = @"devicename";
    device.category = @"iPhone";
    device.deviceId = @"123";
    device.systemVersion = @"8.0";
    
    return device;
}

- (Person *)createATestPerson {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    person.userName = @"flast";
    
    return person;
}

- (CKRecord *)createATestDeviceRecord {
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"device"];
    record[@"devicename"] = @"devicename";
    record[@"category"] = @"iPhone";
    record[@"deviceId"] = @"123";
    record[@"systemVersion"] = @"8.0";
    
    return record;
}

- (CKRecord *)createATestPersonRecord {
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"person"];
    record[@"firstName"] = @"first";
    record[@"lastName"] = @"last";
    record[@"userName"] = @"flast";
    
    return record;
}

@end
