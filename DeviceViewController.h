//
//  DeviceViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Person.h"
#import "UserNamePickerViewController.h"

@interface DeviceViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *individualDeviceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *individualDeviceCategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceCategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabelText;
@property (nonatomic, weak) IBOutlet UIButton *bookDevice;
@property (nonatomic, weak) IBOutlet UILabel *individualSystemVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *systemVersionLabel;
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *individualDeviceTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceTypeLabel;

@property (nonatomic, weak) IBOutlet UIButton *testButton;

@property (nonatomic, assign) BOOL userIsLoggedIn;

@property (nonatomic, strong) Device *deviceObject;
@property (nonatomic, strong) Person *personObject;

@property (nonatomic, assign) BOOL comesFromStartView;

@property (nonatomic, strong) void (^onCompletion)(BOOL isLoggedIn);

@property (nonatomic, strong) UserNamePickerViewController *userNamePicker;
@property (nonatomic, strong) UIPopoverController *userNamePickerPopover;

- (IBAction)fetchPersonRecordOnClick;
- (IBAction)enterUserName:(id)sender;
- (void)storeReference;
- (void)deleteReference;


@end
