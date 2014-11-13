//
//  CreateDeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 10.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreateDeviceViewController.h"
#import "Device.h"
#import "KeyChainWrapper.h"
#import "DeviceViewController.h"
#import "TEDLocalization.h"
#import "AppDelegate.h"
#import "UIDevice-Hardware.h"
#import "UserDefaultsWrapper.h"
#import "UdIdGenerator.h"


@interface CreateDeviceViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation CreateDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TEDLocalization localize:self];
    
    self.pickerData = @[@"iPhone", @"Android Phone", @"iPad", @"Android Tablet"];
    self.deviceNameTextField.text = [[UIDevice currentDevice] name];
    self.deviceTypeTextField.text = [[UIDevice currentDevice] platformString];

    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    self.devicePicker.dataSource = self;
    self.devicePicker.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerData[row];
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)storeDevice {
    if (self.deviceNameTextField.text && self.deviceNameTextField.text.length > 0) {
        [self.spinner startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        if (self.switchCurrentDevice.isOn) {
            self.shouldRegisterCurrentDevice = YES;
        }
        
        self.device = [[Device alloc] init];
        self.device.deviceName = self.deviceNameTextField.text;
        self.device.category = [_pickerData objectAtIndex:[_devicePicker selectedRowInComponent:0]];
        self.device.systemVersion = [[UIDevice currentDevice] systemVersion];
        self.device.deviceType = self.deviceTypeTextField.text;
   
        if (self.shouldRegisterCurrentDevice) {
            self.device.deviceUdId = [UdIdGenerator generateUID];
            [KeyChainWrapper setDeviceUdId:self.device.deviceUdId];
            [UserDefaultsWrapper setDevice:self.device];
        }
        
        [AppDelegate.dao storeDevice:self.device completionHandler:^(Device *storedDevice, NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self.spinner stopAnimating];
            } else {
                self.device = storedDevice;
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_SAVED", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_SAVED_DEVICE", nil), self.device.deviceName, self.device.category] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    } else {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_EMPTY_TEXTFIELD", nil) message:[NSString stringWithFormat:NSLocalizedString(@"MESSAGE_EMPTY_TEXTFIELD", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.onCompletion) {
        self.onCompletion(self.device);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    return YES;
}

- (void) dismissKeyboard {
    [self.deviceNameTextField resignFirstResponder];
}

- (IBAction)backButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
