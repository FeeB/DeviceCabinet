//
//  CreateDeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 10.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateDeviceViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *devicePicker;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceTypeTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) void (^onCompletion)(id result);

- (IBAction)storeDevice;
- (IBAction)backButton;

@end
