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
#import "Device.h"
#import "Person.h"

@interface DeviceViewTestCase : XCTestCase

@end

@implementation DeviceViewTestCase

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
    XCTAssertFalse([controller.bookDevice isHidden], @"The book button shouldn't be hidden");
    XCTAssertTrue([controller.bookedFromLabelText isHidden], @"The book from label should be hidden");
}

- (void)testHiddenTextFieldsWhenDeviceIsBookedFromPerson {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceViewController *controller = (DeviceViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    
    Device *device = [[Device alloc] init];
    device.bookedByPerson = YES;
    Person *person = [self createATestPerson];
    device.bookedByPersonFullName = person.fullName;
    device.bookedByPersonId = person.personId;
    
    controller.device = device;
    [controller updateView];
    [controller viewDidLoad];
    
    XCTAssertEqualObjects(controller.bookDevice.currentTitle, NSLocalizedString(@"BUTTON_RETURN", nil), @"Book Button should have return title");
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
