//
//  LaunchHandlerTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 01.12.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserDefaultsWrapper.h"
#import "KeyChainWrapper.h"
#import "RailsApiDao.h"
#import "LaunchHandler.h"
#import "Device.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface LaunchHandlerTestCase : XCTestCase

@property LaunchHandler *launchHandler;
@property UserDefaultsWrapper *userDefaultsMock;
@property KeyChainWrapper *keyChainWrapperMock;
@property RailsApiDao *railsApiDaoMock;

@end

@implementation LaunchHandlerTestCase

- (void)setUp {
    [super setUp];
    self.keyChainWrapperMock = mock([KeyChainWrapper class]);
    self.userDefaultsMock = mock([UserDefaultsWrapper class]);
    self.railsApiDaoMock = mock([RailsApiDao class]);
    self.launchHandler = [[LaunchHandler alloc]initWithUserDefaults:self.userDefaultsMock keyChainWrapper:self.keyChainWrapperMock railsApiDao:self.railsApiDaoMock];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHandleFirstLaunchWhenFirstLaunchFalse {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [given([self.userDefaultsMock isFirstLaunch]) willReturn:[NSNumber numberWithBool:NO]];
    
    [self.launchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        XCTAssertFalse(shouldShowDecision);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testHandleFirstLaunchWhenFirstLaunchTrueAndDeviceUdidNotThere {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [given([self.userDefaultsMock isFirstLaunch]) willReturn:[NSNumber numberWithBool:YES]];
    [given([self.keyChainWrapperMock hasDeviceUdId]) willReturn:[NSNumber numberWithBool:NO]];
    
    [self.launchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        XCTAssertTrue(shouldShowDecision);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testHandleFirstLaunchWhenFirstLaunchTrueAndDeviceUdidIsThereAndDeviceFound {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [given([self.userDefaultsMock isFirstLaunch]) willReturn:[NSNumber numberWithBool:YES]];
    [given([self.keyChainWrapperMock hasDeviceUdId]) willReturn:[NSNumber numberWithBool:YES]];
//    [given([self.railsApiDaoMock fetchDeviceWithDeviceUdId:anything() completionHandler:anything()]) willReturn:[self createATestDevice]];
    
    [self.launchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        XCTAssertFalse(shouldShowDecision);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testHandleFirstLaunchWhenFirstLaunchTrueAndDeviceUdidIsThereAndDeviceNotFound {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [given([self.userDefaultsMock isFirstLaunch]) willReturn:[NSNumber numberWithBool:YES]];
    [given([self.keyChainWrapperMock hasDeviceUdId]) willReturn:[NSNumber numberWithBool:YES]];
//    [given([self.railsApiDaoMock fetchDeviceWithDeviceUdId:anything() completionHandler:anything()]) willReturn:[self createATestDevice]];
    
    [self.launchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        XCTAssertTrue(shouldShowDecision);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
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
     
@end