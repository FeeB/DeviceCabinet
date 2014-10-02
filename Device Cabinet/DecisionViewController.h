//
//  DecisionViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface DecisionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *registerDeviceButton;
@property (nonatomic, strong) IBOutlet UIButton *noRegisterButton;
@property (nonatomic, strong) void (^onCompletion)(id result);
@property (nonatomic, weak) Device *deviceObject;

- (IBAction)onRegisterClick;
- (IBAction)onNoRegisterClick;


@end
