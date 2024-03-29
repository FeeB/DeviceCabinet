//
//  CreateDeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 10.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Device;

@interface CreateDeviceViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchLocalDevice;
@property (weak, nonatomic) IBOutlet UILabel *labelSwitchLocalDevice;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) void (^onCompletion)();
@property (nonatomic, assign) BOOL shouldRegisterLocalDevice;

- (IBAction)storeDevice;
- (IBAction)backButton;

@end
