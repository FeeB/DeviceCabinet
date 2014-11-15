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

- (void)testHiddenTextFieldsWhenDeviceIsNotBooked {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    Device *device = [[Device alloc] init];
    device.bookedByPerson = NO;
    
    controller.device = device;
    
    [controller updateView];
    [controller viewDidLoad];

    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_BOOK", nil), @"Book Button should have book now title");
    XCTAssertFalse([controller.usernamePickerButton isHidden], @"The username text field shouldn't be hidden");
}

- (void)testHiddenTextFieldsWhenDeviceIsBookedFromPerson {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    Device *device = [[Device alloc] init];
    device.bookedByPerson = YES;
    Person *person = [self createATestPerson];
    device.bookedByPersonFullName = person.fullName;
    device.bookedByPersonId = person.personRecordId;
    
    controller.device = device;
    [controller updateView];
    [controller viewDidLoad];
    
    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_RETURN", nil), @"Book Button should have return title");
    XCTAssertFalse([controller.bookedFromLabel isHidden], @"The booked from label shouldn't be hidden");
    XCTAssertFalse([controller.bookedFromLabelText isHidden], @"The booked from label text shouldn't be hidden");
}

- (Device *)createATestDevice {
    Device *device = [[Device alloc] init];
    device.deviceName = @"devicename";
    device.type = @"iPhone";
    device.deviceId = @"123";
    device.systemVersion = @"8.0";
    
    return device;
}

- (Person *)createATestPerson {
    Person *person = [[Person alloc] init];
    person.firstName = @"first";
    person.lastName = @"last";
    
    return person;
}

@end
