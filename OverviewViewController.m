//
//  OverviewViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "OverviewViewController.h"
#import "CloudKitManager.h"
#import "DeviceViewController.h"
#import "LogInViewController.h"
#import "UserDefaults.h"
#import "UIdGenerator.h"

NSString * const DeviceControllerIdentifier = @"DeviceControllerID";
NSString * const LogInSegueIdentifier = @"logIn";

@interface OverviewViewController ()

@property (nonatomic, readonly) NSMutableArray *list;
@property (nonatomic, readonly) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *bookedDevices;
@property (nonatomic, strong) NSMutableArray *freeDevices;

@end

@implementation OverviewViewController

@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _list = [[NSMutableArray alloc] init];
    _categories = [[NSMutableArray alloc] init];
    _bookedDevices = [[NSMutableArray alloc] init];
    _freeDevices = [[NSMutableArray alloc] init];
    
    if (!self.comesFromRegister) {
        [self checkCurrentUserIsLoggedIn];
    }
    
    [self getAllDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.list count];
}

//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [self.list objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *dictionary = [self.list objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    Device *cellDevice = [array objectAtIndex:indexPath.row];
    NSString *cellValue = cellDevice.deviceName;
    cell.textLabel.text = cellValue;
    
    return cell;
}

//On click on one cell the device view will appear
-(IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:DeviceControllerIdentifier];
    [self.navigationController pushViewController:controller animated:YES];

    NSDictionary *dictionary = [self.list objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    controller.deviceObject = [array objectAtIndex:indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] > 0) {
            return NSLocalizedString(@"booked-devices", nil);
        } else{
            return nil;
        }
    } else {
        if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] > 0) {
            return NSLocalizedString(@"free-devices", nil);
        } else{
            return nil;
        }

    }
}

//get all devices for the device overview
-(void)getAllDevices{
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects) {
        
        for (Device *device in deviceObjects){
            if (device.isBooked) {
                [self.bookedDevices addObject:device];
            } else {
                [self.freeDevices addObject:device];
            }
        }
        NSDictionary *bookedDictionary = [NSDictionary dictionaryWithObject:self.bookedDevices forKey:@"data"];
        NSDictionary *freeDictionary = [NSDictionary dictionaryWithObject:self.freeDevices forKey:@"data"];
        [self.list addObject:bookedDictionary];
        [self.list addObject:freeDictionary];
        [self.table reloadData];
    }];

}

-(IBAction)logOut{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetUserDefaults];
    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
}

- (void)checkCurrentUserIsLoggedIn{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *userType = [userDefaults getUserType];
    NSString *currentUserIdentifier = [userDefaults getUserIdentifier];
    
    if (currentUserIdentifier) {
        if ([userType isEqualToString:@"person"]) {
            
            CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
            [cloudManager fetchPersonWithUsername:currentUserIdentifier completionHandler:^(Person *person) {
                if (!person) {
                    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
                }
            }];
        } else {
            CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
            [cloudManager fetchDeviceWithDeviceId:currentUserIdentifier completionHandler:^(Device *device) {
                if (device) {
                    DeviceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
                    controller.deviceObject = device;
                    [self.navigationController pushViewController:controller animated:YES];
                    [self.navigationController setNavigationBarHidden:YES];
                }else{
                    UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
                    [uIdGenerator resetKeyChain];
                    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
                    
                }
            }];
        }
    } else{
        UIdGenerator *uIdGenerator = [[UIdGenerator alloc]init];
        [uIdGenerator resetKeyChain];
        [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
    }
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
