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
@property (weak, nonatomic) IBOutlet UILabel *deviceCategoryLabel;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

extern NSString const *FromCreateDeviceToOverviewSegue;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction) storeDevice;

@end
