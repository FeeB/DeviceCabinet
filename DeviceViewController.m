//
//  DeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceViewController.h"
#import <CloudKit/CloudKit.h>

@interface DeviceViewController ()

@end

@implementation DeviceViewController

@synthesize deviceLabel;
@synthesize deviceName;

@synthesize deviceCategoryLabel;
@synthesize deviceCategory;

@synthesize bookedFromLabel;
@synthesize bookedFrom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    deviceLabel.text = deviceName;
    deviceCategoryLabel.text = deviceCategory;
    bookedFromLabel.text = bookedFrom;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
