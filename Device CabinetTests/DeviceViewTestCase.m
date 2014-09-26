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
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

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
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    [self createUserDefaultsPerson];
    
    [controller viewWillAppear:YES];
    [controller showOrHideTextFields];
    
    XCTAssertTrue([controller.usernameTextField isHidden], @"The username text field should be hidden");
    XCTAssertTrue([controller.usernameLabel isHidden], @"The username label should be hidden");
}

- (void)testHiddenTextFieldsWhenUserIsADeviceAndNotBooked {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    Device *device = [[Device alloc] init];
    device.bookedByPerson = NO;
    [self createUserDefaultsDevice];
    
    controller.deviceObject = device;
    
    [controller showOrHideTextFields];
    [controller viewDidLoad];

    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_BOOK", nil), @"Book Button should have book now title");
    XCTAssertFalse([controller.usernameTextField isHidden], @"The username text field shouldn't be hidden");
    XCTAssertFalse([controller.usernameLabel isHidden], @"The username label shouldn't be hidden");
}

- (void)testHiddenTextFieldsWhenDeviceIsBookedFromPerson {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    Device *device = [[Device alloc] init];
    device.bookedByPerson = YES;
    Person *person = [self createATestPerson];
    device.bookedByPersonFullName = person.fullName;
    device.bookedByPersonId = person.personRecordId;
    device.bookedByPersonUsername = person.username;
    
    [self createUserDefaultsPerson];
    
    controller.deviceObject = device;
    [controller viewWillAppear:YES];
    [controller showOrHideTextFields];
    
    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_RETURN", nil), @"Book Button should have return title");
    XCTAssertFalse([controller.bookedFromLabel isHidden], @"The booked from label shouldn't be hidden");
    XCTAssertFalse([controller.bookedFromLabelText isHidden], @"The booked from label text shouldn't be hidden");
}

- (void)testHiddenTextFieldsWhenDeviceIsBookedFromSomeoneElse {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    Device *device = [self createATestDevice];
    device.bookedByPerson = YES;
    
   [self createUserDefaultsPerson];
    
    controller.deviceObject = device;
    [controller viewWillAppear:YES];
    [controller showOrHideTextFields];
    
    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_ALREADY_BOOKED", nil));
    XCTAssertFalse([controller.bookedFromLabel isHidden], @"The booked from label shouldn't be hidden");
    XCTAssertFalse([controller.bookedFromLabelText isHidden], @"The booked from label text shouldn't be hidden");
}

- (Device *)createATestDevice {
    Device *device = [[Device alloc] init];
    device.deviceName = @"devicename";
    device.category = @"iPhone";
    device.deviceId = @"123";
    device.systemVersion = @"8.0";
    
    return device;
}

- (Person *)createATestPerson {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    person.username = @"flast";
    
    return person;
}

- (void)createUserDefaultsPerson {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:@"flast" userType:@"person"];
}

- (void)createUserDefaultsDevice {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults storeUserDefaults:@"123" userType:@"device"];
}

@end
