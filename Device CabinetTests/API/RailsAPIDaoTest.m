//
//  RailsAPIDaoTeest.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 30.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "RailsApiDao.h"
#import "AFNetworking.h"
#import "Device.h"
#import "Person.h"

@interface RailsAPIDaoTest : XCTestCase

@property RailsApiDao *railsApiDao;
@property AFHTTPRequestOperationManager *requestOperationManagerMock;

@end

@implementation RailsAPIDaoTest

- (void)setUp {
    [super setUp];

    self.requestOperationManagerMock = mock([AFHTTPRequestOperationManager class]);
    self.railsApiDao = [[RailsApiDao alloc] initWithRequestOperationManager:self.requestOperationManagerMock];
}

- (void)testfetchDevicesGetMethodAndCountOfArrayAndSuccessBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [self.railsApiDao fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects, NSError *error) {
        //toDo Count Devices
        XCTAssertTrue([deviceObjects count] == 1);
        [expectation fulfill];
    }];

    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) GET:anything()
                     parameters:nil
                        success:[argument capture]
                        failure:anything()];
    
    // Retrieve Block which assigned to the Mock-AFHTTPRequestOperationManager before
    void (^success)(AFHTTPRequestOperation *, id) = [argument value];
    // Execute Bock
    success(nil, @[@{@"device_name": @"iPhone"}]);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchDeviceWithDeviceUdIdErrorBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [self.railsApiDao fetchDeviceWithDeviceUdId:anything() completionHandler:^(Device *device, NSError *error) {
        XCTAssertTrue(error.code == 2);
        [expectation fulfill];
    }];
    
    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) GET:anything()
                                       parameters:anything()
                                          success:anything()
                                          failure:[argument capture]];
    
    void(^failure)(AFHTTPRequestOperation *, id) = [argument value];
    NSError *error = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:500 userInfo:nil];
    failure(nil, error);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFetchDeviceWithDeviceUdIdRecieveOneDevice {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [self.railsApiDao fetchDeviceWithDeviceUdId:anything() completionHandler:^(Device *device, NSError *error) {
        XCTAssertTrue([device isKindOfClass:[Device class]]);
        [expectation fulfill];
    }];
    
    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) GET:anything()
                                       parameters:anything()
                                          success:[argument capture]
                                          failure:anything()];
    
    void(^success)(AFHTTPRequestOperation *, id) = [argument value];
    NSDictionary *testDevice = [self DeviceDictionary];
    success(nil, testDevice);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testDeleteDeviceDeleteMethod {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    Device *device = [self createATestDevice];
    
    [self.railsApiDao deleteDevice:device completionHandler:^(NSError *error) {
        [expectation fulfill];
    }];
    
    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) DELETE:anything()
                                       parameters:nil
                                          success:[argument capture]
                                          failure:anything()];
    
    void(^success)(AFHTTPRequestOperation *, id) = [argument value];
    success(nil, device);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testStorePersonPostMethod {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    Person *person = [self createATestPerson];
    
    [self.railsApiDao storePerson:person completionHandler:^(Person *person, NSError *error) {
        [expectation fulfill];
    }];
    
    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) POST:anything()
                                          parameters:anything()
                                             success:[argument capture]
                                             failure:anything()];
    
    void(^success)(AFHTTPRequestOperation *, id) = [argument value];
    success(nil, [self DeviceDictionary]);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testStorePersonObjectAsReferencePatchMethod {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    Person *person = [self createATestPerson];
    Device *device = [self createATestDevice];
    
    [self.railsApiDao storePersonObjectAsReferenceWithDevice:device person:person completionHandler:^(NSError *error) {
        [expectation fulfill];
    }];
    
    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) PATCH:anything()
                                        parameters:anything()
                                           success:[argument capture]
                                           failure:anything()];
    
    void(^success)(AFHTTPRequestOperation *, id) = [argument value];
    success(nil, person);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (NSDictionary *)DeviceDictionary {
    return @{@"device_name" : @"B4F-iPhone-001", @"device_id" : @"123455", @"category" : @"iPhone", @"system_version" : @"7.0.1", @"is_booked" : @"NO", @"device_type" : @"iPhone4", @"image_url" : @"", @"is_booked" : @"No", @"person_id" : @""};
}

- (Device *)createATestDevice {
    Device *device = [[Device alloc] init];
    device.deviceName = @"devicename";
    device.type = @"iPhone";
    device.deviceUdId = @"123";
    device.systemVersion = @"8.0";
    device.deviceType = @"iPhone 5c";
    
    return device;
}

- (Person *)createATestPerson {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    person.personId = @"1";
    
    return person;
}

@end
