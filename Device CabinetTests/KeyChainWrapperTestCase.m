//
//  KeyChainWrapperTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 01.12.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeyChainWrapper.h"
#import "KeychainItemWrapper.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface KeyChainWrapperTestCase : XCTestCase

@property KeychainItemWrapper *keyChainItemWrapperMock;
@property KeyChainWrapper *keyChainWrapper;

@end

@implementation KeyChainWrapperTestCase

- (void)setUp {
    [super setUp];
    self.keyChainItemWrapperMock = mock([KeychainItemWrapper class]);
    self.keyChainWrapper = [[KeyChainWrapper alloc]initWithKeyChainWrapperItem:self.keyChainItemWrapperMock];
}

- (void)testSetDeviceUdId {
    [self.keyChainWrapper setDeviceUdId:anything()];
    [verifyCount(self.keyChainItemWrapperMock, times(2)) setObject:anything() forKey:anything()];
}

- (void)testGetDeviceUdId {
    [self.keyChainWrapper getDeviceUdId];
    [verify(self.keyChainItemWrapperMock) objectForKey:anything()];
}

- (void)testResetKeyChain {
    [self.keyChainWrapper reset];
    [verify(self.keyChainItemWrapperMock) resetKeychainItem];
}


@end
