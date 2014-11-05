//
//  DeviceTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.11.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Device.h"

@interface DeviceTestCase : XCTestCase

@end

@implementation DeviceTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithJson {
    Device *storedDevice = [self createATestDevice];
    NSDictionary *json = @{@"device_name" : storedDevice.deviceName, @"device_id" : storedDevice.deviceId, @"category" : storedDevice.category, @"system_version" : storedDevice.systemVersion, @"is_booked" : storedDevice.isBookedByPerson ? @"YES" : @"NO", @"device_type" : storedDevice.deviceType, @"image_url" : @"", @"is_booked" : @"No", @"person_id" : @""};
    
    Device *device = [[Device alloc] initWithJson:json];
    
    XCTAssertEqualObjects(device.deviceName, storedDevice.deviceName, @"deviceName from device initialized with json should be same like storedDevice");
    XCTAssertEqualObjects(device.deviceId, storedDevice.deviceId, @"deviceId from device initialized with json should be same like storedDevice");
    XCTAssertEqualObjects(device.category, storedDevice.category, @"category from device initialized with json should be same like storedDevice");
    XCTAssertEqualObjects(device.systemVersion, storedDevice.systemVersion, @"systemVersion from device initialized with json should be same like storedDevice");
    XCTAssertEqualObjects(device.deviceType, storedDevice.deviceType, @"deviceType from device initialized with json should be same like storedDevice");
    XCTAssertFalse(device.isBookedByPerson, @"Device should not be booked");
}

- (void)testToDictionary {
    Device *device = [self createATestDevice];
    NSDictionary *json = device.toDictionary;
    
    XCTAssertEqualObjects(device.deviceName, [json valueForKey:@"device_name"], @"deviceName should be same in json");
    XCTAssertEqualObjects(device.deviceId, [json valueForKey:@"device_id"], @"deviceId should be same in json");
    XCTAssertEqualObjects(device.category, [json valueForKey:@"category"], @"category should be same in json");
    XCTAssertEqualObjects(device.systemVersion, [json valueForKey:@"system_version"], @"systemVersion should be same in json");
    XCTAssertEqualObjects(device.deviceType, [json valueForKey:@"device_type"], @"deviceType should be same in json");
    XCTAssertEqualObjects([json valueForKey:@"is_booked"], @"NO", @"Device should not be booked");
}

- (Device *)createATestDevice {
    Device *device = [[Device alloc] init];
    device.deviceName = @"devicename";
    device.category = @"iPhone";
    device.deviceId = @"123";
    device.systemVersion = @"8.0";
    device.deviceType = @"iPhone 5c";
    
    return device;
}

@end
