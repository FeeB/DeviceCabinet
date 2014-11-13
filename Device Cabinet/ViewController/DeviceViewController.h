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
@property (nonatomic, weak) IBOutlet UILabel *individualDeviceCategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceCategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookedFromLabelText;
@property (nonatomic, weak) IBOutlet UIButton *bookDevice;
@property (nonatomic, weak) IBOutlet UILabel *individualSystemVersionLabel;
@property (nonatomic, weak) IBOutlet UILabel *systemVersionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *individualDeviceTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceTypeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;

@property (nonatomic, strong) Device *deviceObject;
@property (nonatomic, strong) Person *personObject;
@property (nonatomic, strong) UserNamePickerViewController *userNamePicker;

- (void)storeReference;
- (void)deleteReference;
- (void)updateView;
- (IBAction)clickOnBookButton;

@end