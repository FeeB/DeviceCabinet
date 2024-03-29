//
//  DecisionViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;

@interface DecisionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *registerDeviceButton;
@property (nonatomic, strong) IBOutlet UIButton *noRegisterButton;

- (IBAction)onRegisterClick;
- (IBAction)onNoRegisterClick;

@end
