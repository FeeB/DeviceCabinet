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
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *individualDeviceTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceTypeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;
@property (nonatomic, weak) IBOutlet UIImageView *systemVersionPhoto;
@property (nonatomic) IBOutlet UIView *separatingView;

@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) UserNamePickerViewController *userNamePicker;

@property (nonatomic, assign) BOOL automaticReturn;

- (void)storeReference;
- (void)deleteReference;
- (void)updateView;
- (IBAction)clickOnBookButton;

@end
