//
//  UserDefaultsTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 25.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UserDefaults.h"

NSString * const KeyForUserDefaults = @"identifier";
NSString * const KeyForUserType = @"type";

@interface UserDefaultsTestCase : XCTestCase

@end

@implementation UserDefaultsTestCase

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

//- (void)testStoreUserAndGetUserIdentifier {
//    UserDefaults *userDefaults = [[UserDefaults alloc] init];
//    [userDefaults storeUserDefaults:@"identifier" userType:@"type"];
//    
//    NSString *returnedIdentifier = [userDefaults getUserIdentifier];
//    
//    XCTAssertEqualObjects(returnedIdentifier, @"identifier", @"returned Identifier should be the same like the stored identifier");
//}
//
//- (void)testStoreUserAndGetUserType {
//    UserDefaults *userDefaults = [[UserDefaults alloc] init];
//    [userDefaults storeUserDefaults:@"identifier" userType:@"type"];
//    
//    NSString *returnedType = [userDefaults getUserType];
//    
//    XCTAssertEqualObjects(returnedType, @"type", @"returned user type should be th same like the stored one");
//}
//
//- (void)testResetUserDefaults {
//    UserDefaults *userDefaults = [[UserDefaults alloc] init];
//    [userDefaults resetUserDefaults];
//    
//    XCTAssertNil([userDefaults getUserIdentifier], @"User identifier should be nil");
//    XCTAssertNil([userDefaults getUserType], @"User type should be nil");
//}
//
@end
