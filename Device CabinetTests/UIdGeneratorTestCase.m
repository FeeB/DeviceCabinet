//
//  UIdGeneratorTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 25.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIdGenerator.h"

@interface UIdGeneratorTestCase : XCTestCase

@end

@implementation UIdGeneratorTestCase

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

//- (void)testDeviceIdIsEmpty {
//    UIdGenerator *generator = [[UIdGenerator alloc] init];
//    [generator resetKeyChain];
//    NSString *udidString = [generator getIdfromKeychain];
//    
//    XCTAssertEqualObjects(udidString, @"", @"UdId should be empty");
//}
//
//- (void)testDeviceIdIsNotEmptyWithGetDeviceId {
//    UIdGenerator *generator = [[UIdGenerator alloc] init];
//    [generator resetKeyChain];
//    NSString *udidString = [generator getDeviceId];
//    
//    XCTAssertNotEqual(udidString, @"", @"UdId shouldn't be empty");
//}
//
//- (void)testSetDeviceId {
//    UIdGenerator *generator = [[UIdGenerator alloc] init];
//    NSString *udidString = @"123";
//    
//    [generator setDeviceId:udidString];
//    
//    XCTAssertEqualObjects([generator getDeviceId], udidString, @"UdId should be same Id");
//}

@end
