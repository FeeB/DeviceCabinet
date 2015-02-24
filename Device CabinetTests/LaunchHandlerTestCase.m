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
#import "RESTApiClient.h"
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
@property RESTApiClient *restApiDaoMock;

@end

@implementation LaunchHandlerTestCase

- (void)setUp {
    [super setUp];
    self.keyChainWrapperMock = mock([KeyChainWrapper class]);
    self.userDefaultsMock = mock([UserDefaultsWrapper class]);
    self.restApiDaoMock = mock([RESTApiClient class]);
    self.launchHandler = [[LaunchHandler alloc] initWithUserDefaults:self.userDefaultsMock keyChainWrapper:self.keyChainWrapperMock restApiDao:self.restApiDaoMock];
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

    [self.launchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        XCTAssertFalse(shouldShowDecision);
        [expectation fulfill];
    }];

    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.restApiDaoMock) fetchDeviceWithDeviceUdId:anything() completionHandler:[argument capture]];
    void(^completionHandler)(Device*, NSError*) = [argument value];
    completionHandler([self createATestDevice], nil);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testHandleFirstLaunchWhenFirstLaunchTrueAndDeviceUdidIsThereAndDeviceNotFound {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [given([self.userDefaultsMock isFirstLaunch]) willReturn:[NSNumber numberWithBool:YES]];
    [given([self.keyChainWrapperMock hasDeviceUdId]) willReturn:[NSNumber numberWithBool:YES]];
    
    [self.launchHandler handleFirstLaunchWithCompletionHandler:^(BOOL shouldShowDecision) {
        XCTAssertTrue(shouldShowDecision);
        [expectation fulfill];
    }];

    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.restApiDaoMock) fetchDeviceWithDeviceUdId:anything() completionHandler:[argument capture]];
    void(^completionHandler)(Device*, NSError*) = [argument value];
    completionHandler(nil, [[NSError alloc] init]);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (Device *)createATestDevice {
    Device *device = [[Device alloc] init];
    device.deviceName = @"devicename";
    device.type = @"iPhone";
    device.deviceUdId = @"123";
    device.systemVersion = @"8.0";
    device.deviceModel = @"iPhone 5c";
         
    return device;
}
     
@end
