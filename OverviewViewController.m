//
//  OverviewViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "OverviewViewController.h"
#import <CloudKit/CloudKit.h>
#import "CloudKitManager.h"
#import "DeviceViewController.h"

NSString* const ReferenceItemRecordName = @"Devices";


@interface OverviewViewController ()

@property (nonatomic, readonly) NSMutableArray *list;
@property (nonatomic, readonly) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableDictionary *dataArray;

@end

@implementation OverviewViewController

@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = [[NSMutableArray alloc] init];
    _categories = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableDictionary alloc] init];
    
    CloudKitManager* cloudManager = [[CloudKitManager alloc] init];
    
    [cloudManager fetchRecordsWithType:ReferenceItemRecordName completionHandler:^(NSArray *records) {
        
        for (CKRecord *recordName in records){
            [self.list addObject:recordName[@"devicename"]];
            [self.categories addObject:recordName[@"category"]];
        }
        
        self.dataArray = [NSMutableDictionary dictionaryWithObjects:self.categories forKeys:self.list];
        [self.table reloadData];
        


    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;

    DeviceViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceControllerID"];
    [self.navigationController pushViewController:controller animated:YES];
    controller.deviceName = cellText;
    controller.deviceCategory = [self.dataArray valueForKey:cellText];
    NSLog(@"category: %@", [self.dataArray valueForKey:cellText]);
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
