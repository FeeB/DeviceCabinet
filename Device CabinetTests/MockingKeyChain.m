//
//  MockingKeyChain.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.11.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIdGenerator.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface MockingKeyChain : UIdGenerator

@end

@implementation MockingKeyChain

//- (NSString *)getIdfromKeychain {
//    KeychainItemWrapper *mockedKeychain = mock([KeychainItemWrapper class]);
//    [given ([mockedKeychain objectForKey:(__bridge id)(kSecAttrAccount)]) willReturn:@"1234"];
//    
//    
//}

@end
