//
//  ProfileViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "ProfileViewController.h"
#import "CloudKitManager.h"
#import "Person.h"
#import "Device.h"
#import "DeviceViewController.h"
#import "UserDefaults.h"


NSString * const DeviceControllerIdentifier2 = @"DeviceControllerID";
NSString * const LogInSegueIdentifier2 = @"logIn";

@interface ProfileViewController ()

@property (nonatomic, readonly) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *deviceArray;


@end

@implementation ProfileViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _list = [[NSMutableArray alloc] init];
    _deviceArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [self getAllBookedDevices];
    self.bookedDevicesLabel.text = NSLocalizedString(@"booked-devices", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.list objectAtIndex:indexPath.row];
    return cell;
}

//fetch person record to know the record ID to get all devices with a reference to this person object
-(void)getAllBookedDevices{
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    
    [cloudManager fetchPersonWithUsername:[userDefaults getUserIdentifier] completionHandler:^(Person *person) {
        self.personObject = person;
        [self.personObject createFullNameWithFirstName];
        self.nameLabel.text = self.personObject.fullName;
    
        [cloudManager fetchDevicesWithPersonID:self.personObject.recordId completionHandler:^(NSArray *devicesArray) {
            for (Device *device in devicesArray){
                [self.list addObject:device.deviceName];
                [self.deviceArray addObject:device];
            }
            [self.tableView reloadData];
        }];
    }];
}

//On click on one cell the device view will appear
-(IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:DeviceControllerIdentifier2];
    [self.navigationController pushViewController:controller animated:YES];
    
    controller.deviceObject = [self.deviceArray objectAtIndex:indexPath.row];
}

-(IBAction)logOut{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetUserDefaults];
    [self performSegueWithIdentifier:LogInSegueIdentifier2 sender:self];
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
