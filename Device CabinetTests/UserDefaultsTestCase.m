//
//  UserDefaultsTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 01.12.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserDefaultsWrapper.h"
#import "Device.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface UserDefaultsTestCase : XCTestCase

@property UserDefaultsWrapper *userDefaultsWrapper;
@property NSUserDefaults *userDefaultsMock;

@end

@implementation UserDefaultsTestCase

- (void)setUp {
    [super setUp];
    self.userDefaultsMock = mock([NSUserDefaults class]);
    self.userDefaultsWrapper = [[UserDefaultsWrapper alloc]initWithUserDefaults:self.userDefaultsMock];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetLocalDevice {
    [self.userDefaultsWrapper setLocalDevice:[self createATestDevice]];
    [verify(self.userDefaultsMock) setObject:anything() forKey:anything()];
}

- (void)testGetLocalDevice {
    [self.userDefaultsWrapper getLocalDevice];
    [verify(self.userDefaultsMock) valueForKey:anything()];
}

- (void)testResetLocalDevice {
    [self.userDefaultsWrapper reset];
    [verify(self.userDefaultsMock) removeObjectForKey:anything()];
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
