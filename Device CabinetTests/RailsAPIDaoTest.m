//
//  RailsAPIDaoTeest.m
//  Device Cabinet
//
//  Created by Fee Kristin Braun on 30.11.14.
//  Copyright (c) 2014 Fee Kristin Braun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "RailsApiDao.h"
#import "AFNetworking.h"
#import "Device.h"

@interface RailsAPIDaoTest : XCTestCase

@property RailsApiDao *railsApiDao;
@property AFHTTPRequestOperationManager *requestOperationManagerMock;

@end

@implementation RailsAPIDaoTest

- (void)setUp {
    [super setUp];

    self.requestOperationManagerMock = mock([AFHTTPRequestOperationManager class]);
    self.railsApiDao = [[RailsApiDao alloc] initWithRequestOperationManager:self.requestOperationManagerMock];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"network"];
    
    [self.railsApiDao fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects, NSError *error) {
        //toDo Count Devices
        XCTAssertTrue([((Device *)deviceObjects[0]).deviceName isEqualToString:@"Hallo Fee!"]);
        [expectation fulfill];
    }];

    MKTArgumentCaptor *argument = [[MKTArgumentCaptor alloc] init];
    [verify(self.requestOperationManagerMock) GET:anything()
                     parameters:nil
                        success:[argument capture]
                        failure:anything()];
    
    // Retrieve Block which assigned to the Mock-AFHTTPRequestOperationManager before
    void (^success)(AFHTTPRequestOperation *, id) = [argument value];
    // Execute Bock
    success(nil, @[@{@"device_name": @"Hallo Fee!"}]);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
