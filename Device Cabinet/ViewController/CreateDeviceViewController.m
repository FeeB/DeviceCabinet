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
@property (nonatomic, strong) Device *device;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *deviceTypeButtons;

@end

@implementation CreateDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TEDLocalization localize:self];
    
    self.deviceType = @"iPhone";
    
    self.deviceNameTextField.text = [[UIDevice currentDevice] name];
    self.deviceTypeTextField.text = [[UIDevice currentDevice] platformString];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tap];
    
    if (self.shouldRegisterLocalDevice) {
        self.navigationItem.leftBarButtonItem = nil;
        self.switchLocalDevice.hidden = YES;
        self.labelSwitchLocalDevice.hidden = YES;
    }
}

- (IBAction)deviceTypeSelected:(UIButton *)sender
{
    for (UIButton *b in self.deviceTypeButtons) {
        if (b == sender) {
            b.tintColor = [UIColor colorWithRed:68.0f/255.0f green:181.0f/255.0f blue:200.0f/255.0f alpha:1];
        } else {
            b.tintColor = [UIColor lightGrayColor];
        }
    }
    self.deviceType = sender.titleLabel.text;
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)storeDevice {
    if (self.deviceNameTextField.text && self.deviceNameTextField.text.length > 0) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.spinner startAnimating];
        
        if (self.switchLocalDevice.isOn) {
            self.shouldRegisterLocalDevice = YES;
        }
        
        self.device = [[Device alloc] init];
        self.device.deviceName = self.deviceNameTextField.text;
        self.device.type = self.deviceType;
        self.device.systemVersion = [[UIDevice currentDevice] systemVersion];
        self.device.deviceType = self.deviceTypeTextField.text;

        if (self.shouldRegisterLocalDevice) {
            self.device.deviceUdId = [UdIdGenerator generateUID];
        }
        
        [AppDelegate.dao storeDevice:self.device completionHandler:^(Device *storedDevice, NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.spinner stopAnimating];
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                self.device = storedDevice;
                if (self.shouldRegisterLocalDevice) {
                    [KeyChainWrapper setDeviceUdId:self.device.deviceUdId];
                    [UserDefaultsWrapper setLocalDevice:self.device];
                }
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_SAVED", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_SAVED_DEVICE", nil), self.device.deviceName, self.device.type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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