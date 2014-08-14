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

@interface CreateDeviceViewController (){
    NSArray *_pickerData;
}

@end

@implementation CreateDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickerData = @[@"iPhone", @"Android Phone", @"Ipad", @"Android Tablet"];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)storeDevice{
    Device *device = [[Device alloc]init];
    device.deviceName = _deviceName.text;
    device.category = [_pickerData objectAtIndex:[_picker selectedRowInComponent:0]];
    
    CloudKitManager *cloudManager = [[CloudKitManager alloc]init];
    [cloudManager storeDevice:device completionHandler:^{
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"saved", nil) message:[NSString stringWithFormat: NSLocalizedString(@"saved device", nil), device.deviceName, device.category] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}


@end
