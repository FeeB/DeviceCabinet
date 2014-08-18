//
//  CreateDeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 10.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateDeviceViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *devicePicker;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction) storeDevice;



@end
