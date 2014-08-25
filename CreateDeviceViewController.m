//
//  CreateDeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 10.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreateDeviceViewController.h"
#import "Device.h"
#import "CloudKitManager.h"
#import "UIdGenerator.h"
#import "DeviceViewController.h"
#import "TEDLocalization.h"

@interface CreateDeviceViewController ()
    @property (nonatomic, strong) UIActivityIndicatorView *spinner;
    @property (nonatomic, strong) NSArray *pickerData;
    @property (nonatomic, strong) Device *device;
@end

@implementation CreateDeviceViewController

NSString *FromCreateDeviceToOverviewSegue = @"FromCreateDeviceToDeviceView";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TEDLocalization localize:self];
    
    _pickerData = @[@"iPhone", @"Android Phone", @"Ipad", @"Android Tablet"];
    self.deviceNameLabel.text = NSLocalizedString(@"LABEL_DEVICENAME", nil);
    self.deviceCategoryLabel.text = NSLocalizedString(@"LABEL_CATEGORY", nil);
    [self.saveButton setTitle:NSLocalizedString(@"BUTTON_SAVE", nil) forState:UIControlStateNormal];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    // Connect data
    self.devicePicker.dataSource = self;
    self.devicePicker.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
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
        
        UIdGenerator *uIdGenerator = [[UIdGenerator alloc] init];
        
        self.device = [[Device alloc] init];
        self.device.deviceName = self.deviceNameTextField.text;
        self.device.category = [_pickerData objectAtIndex:[_devicePicker selectedRowInComponent:0]];
        self.device.deviceId = [uIdGenerator getDeviceId];
        self.device.systemVersion = [[UIDevice currentDevice] systemVersion];
        
        CloudKitManager *cloudManager = [[CloudKitManager alloc] init];
        [cloudManager storeDevice:self.device completionHandler:^(NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                [self.spinner stopAnimating];
            } else {
                [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_SAVED", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_SAVED_DEVICE", nil), self.device.deviceName, self.device.category] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    } else {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_EMPTY_TEXTFIELD", nil) message:[NSString stringWithFormat:NSLocalizedString(@"MESSAGE_EMPTY_TEXTFIELD", nil)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:FromCreateDeviceToOverviewSegue sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromCreateDeviceToOverviewSegue]) {
        DeviceViewController *controller = (DeviceViewController *)segue.destinationViewController;
        controller.deviceObject = self.device;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
