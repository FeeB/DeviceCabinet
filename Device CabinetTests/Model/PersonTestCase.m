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

- (void)testCreatedFullName {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    
    XCTAssertEqualObjects(person.fullName, @"first last", @"Fullname should be first last.");
}

- (void)testInitWithJson {
    Person *storedPerson = [self createATestPerson];
    NSDictionary *json = @{@"first_name" :storedPerson.firstName, @"last_name" : storedPerson.lastName, @"full_name" : storedPerson.fullName, @"id" :storedPerson.personId};
    
    Person *person = [[Person alloc] initWithJson:json];
    
    XCTAssertEqualObjects(person.fullName, storedPerson.fullName, @"Fullname from person initialized with json should be same like storedPerson");
    XCTAssertEqualObjects(person.personId, storedPerson.personId, @"RecordId from person initialized with json should be same like storedPerson");
}

- (void)testToDictionary {
    Person *person = [self createATestPerson];
    NSDictionary *json = person.toDictionary;
    
   XCTAssertEqualObjects(person.fullName, [json valueForKey:@"full_name"], @"Fullname should be same in json");
   XCTAssertEqualObjects(person.firstName, [json valueForKey:@"first_name"], @"firstname should be same in json");
   XCTAssertEqualObjects(person.lastName, [json valueForKey:@"last_name"], @"lastname should be same in json");
}

- (Person *)createATestPerson {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    person.personId = @"1";
    
    return person;
}

@end
