//
//  PersonTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 25.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonTestCase : XCTestCase

@end

@implementation PersonTestCase

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

- (void)testCreatedFullName {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    [person createFullNameWithFirstName];
    
    XCTAssertEqualObjects(person.fullName, @"first last", @"Fullname should be first last.");
}

@end
