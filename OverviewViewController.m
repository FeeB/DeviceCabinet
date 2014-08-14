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

NSString * const DeviceControllerIdentifier = @"DeviceControllerID";
NSString * const LogInSegueIdentifier = @"logIn";

@interface OverviewViewController ()

@property (nonatomic, readonly) NSMutableArray *list;
@property (nonatomic, readonly) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *deviceArray;

@end

@implementation OverviewViewController

@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _list = [[NSMutableArray alloc] init];
    _categories = [[NSMutableArray alloc] init];
    _deviceArray = [[NSMutableArray alloc] init];
    
    [self checkCurrentUserIsLoggedIn];
    [self getAllDevices];
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

//On click on one cell the device view will appear
-(IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:DeviceControllerIdentifier];
    [self.navigationController pushViewController:controller animated:YES];
    controller.deviceObject = [self.deviceArray objectAtIndex:indexPath.row];
}

//get all devices for the device overview
-(void)getAllDevices{
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    [cloudManager fetchDevicesWithCompletionHandler:^(NSArray *deviceObjects) {
        
        for (Device *device in deviceObjects){
            [self.list addObject:device.deviceName];
            [self.deviceArray addObject:device];
        }
        [self.table reloadData];
    }];

}

-(IBAction)logOut{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetCurrentUser];
    [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
}

- (void)checkCurrentUserIsLoggedIn{
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *currentUserName = [userDefaults getCurrentUsername];
    if (currentUserName) {
        CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
        [cloudManager fetchPersonWithUsername:currentUserName completionHandler:^(Person *person) {
            if (!person) {
                [self performSegueWithIdentifier:LogInSegueIdentifier sender:self];
            }
        }];
    }else{
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
