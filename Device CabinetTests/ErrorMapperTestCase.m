//
//  ErrorMapperTextCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 25.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CloudKitErrorMapper.h"

@interface ErrorMapperTextCase : XCTestCase

@end

@implementation ErrorMapperTextCase

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

- (void)testItemNotFoundInDatabase {
    NSError *error = [CloudKitErrorMapper itemNotFoundInDatabaseError];
    
    XCTAssertEqual(error.code, 1, @"Should be error code 1");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_ITEM_NOT_FOUND", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_ITEM_NOT_FOUND", nil), @"Should be localized Description");
    
}

- (void)testNoConnectionToCloudKit {
    NSError *testError = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:4 userInfo:nil];
    NSError *error = [CloudKitErrorMapper localErrorWithRemoteError:testError];
    
    XCTAssertEqual(error.code, 2, @"Should be error code 2");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_NO_CONNECTION", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", nil), @"Should be localized Description");
}

- (void)testuserIsNotLoggedInWithiCloudAccount {
    NSError *testError = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:9 userInfo:nil];
    NSError *error = [CloudKitErrorMapper localErrorWithRemoteError:testError];
    
    XCTAssertEqual(error.code, 3, @"Should be error code 3");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_NO_ICLOUD", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_NO_ICLOUD", nil), @"Should be localized Description");
}

- (void)testsomethingWentWrong {
    NSError *testError = [[NSError alloc]initWithDomain:@"com.fee.deviceCabinet" code:404 userInfo:nil];
    NSError *error = [CloudKitErrorMapper localErrorWithRemoteError:testError];
    
    XCTAssertEqual(error.code, 4, @"Should be error code 4");
    XCTAssertEqualObjects(error.localizedDescription, NSLocalizedString(@"ERROR_HEADLINE_SOMETHING_WENT_WRONG", nil), @"Should be localized Description");
    XCTAssertEqual(error.localizedRecoverySuggestion, NSLocalizedString(@"ERROR_MESSAGE_SOMETHING_WENT_WRONG", nil), @"Should be localized Description");
}

@end
