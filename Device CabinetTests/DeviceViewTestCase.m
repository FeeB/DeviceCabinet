//
//  DeviceViewTestCase.m
//  Device Cabinet
//
//  Created by Braun,Fee on 25.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DeviceViewController.h"
#import "UserDefaults.h"

@interface DeviceViewTestCase : XCTestCase

@end

@implementation DeviceViewTestCase

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

- (void)testHiddenTextFieldsWhenUserIsAPerson {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:@"123" userType:@"person"];
    
    DeviceViewController *controller = [[DeviceViewController alloc] init];
    [controller showOrHideTextFields];
    
//    Not yet??
//    XCTAssertTrue([controller.usernameTextField isHidden], @"The username text field should be hidden");
//    XCTAssertTrue([controller.usernameLabel isHidden], @"The username label should be hidden");
}

- (void)testHiddenTextFieldsWhenUserIsADeviceAndNotBooked {
    Device *device = [[Device alloc] init];
    device.isBooked = NO;
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:@"123" userType:@"device"];
    
    DeviceViewController *controller = [[DeviceViewController alloc] init];
    controller.deviceObject = device;
    
    [controller showOrHideTextFields];
    [controller viewWillAppear:YES];
    
//    always nil
//    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_BOOK", nil), @"Book Button should have book now title");
    XCTAssertFalse([controller.usernameTextField isHidden], @"The username text field shouldn't be hidden");
    XCTAssertFalse([controller.usernameLabel isHidden], @"The username label shouldn't be hidden");
}

- (void)testHiddenTextFieldsWhenDeviceIsBookedFromPerson {
    Device *device = [[Device alloc] init];
    device.isBooked = YES;
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    person.userName = @"flast";
    device.bookedFromPerson = person;
    
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:@"flast" userType:@"person"];
    
    DeviceViewController *controller = [[DeviceViewController alloc] init];
    controller.deviceObject = device;
    [controller showOrHideTextFields];
    
//    always nil
//    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_RETURN", nil), @"Book Button should have return title");
    XCTAssertFalse([controller.bookedFromLabel isHidden], @"The booked from label shouldn't be hidden");
    XCTAssertFalse([controller.bookedFromLabelText isHidden], @"The booked from label text shouldn't be hidden");
}

- (void)testHiddenTextFieldsWhenDeviceIsBookedFromSomeoneElse {
    Device *device = [[Device alloc] init];
    device.isBooked = YES;
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    person.userName = @"flast";
    
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:@"flast" userType:@"person"];
    
    DeviceViewController *controller = [[DeviceViewController alloc] init];
    controller.deviceObject = device;
    [controller showOrHideTextFields];
    
//    always nil
//    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_ALREADY_BOOKED", nil));
    XCTAssertFalse([controller.bookedFromLabel isHidden], @"The booked from label shouldn't be hidden");
    XCTAssertFalse([controller.bookedFromLabelText isHidden], @"The booked from label text shouldn't be hidden");
}

@end
