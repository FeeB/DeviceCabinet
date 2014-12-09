//
//  ErrorMapperRailsTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 27.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RailsApiErrorMapper.h"

@interface ErrorMapperRailsTestCase : XCTestCase

@end

@implementation ErrorMapperRailsTestCase

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

- (void)testItemNotFoundInDatabase {
    NSError *testError = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:404 userInfo:nil];
    NSError *error = [RailsApiErrorMapper localErrorWithRemoteError:testError];
    
    XCTAssertEqual(error.code, 1, @"Should be error code 1");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil), @"Should be localized Description");
    
}

- (void)testNoConnection {
    NSError *testError = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:500 userInfo:nil];
    NSError *error = [RailsApiErrorMapper localErrorWithRemoteError:testError];
    
    XCTAssertEqual(error.code, 2, @"Should be error code 2");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil), @"Should be localized Description");
}

- (void)testDuplicateDevice {
    NSError *error = [RailsApiErrorMapper duplicateDeviceError];
    
    XCTAssertEqual(error.code, 3, @"Should be error code 3");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_DUPLICATE_DEVICE", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_DUPLICATE_DEVICE", nil), @"Should be localized Description");
}

- (void)testsomethingWentWrong {
    NSError *testError = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:12345 userInfo:nil];
    NSError *error = [RailsApiErrorMapper localErrorWithRemoteError:testError];
    
    XCTAssertEqual(error.code, 4, @"Should be error code 4");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil), @"Should be localized Description");
}


@end
