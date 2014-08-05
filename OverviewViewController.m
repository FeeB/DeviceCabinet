//
//  OverviewViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "OverviewViewController.h"
#import <CloudKit/CloudKit.h>

NSString* const ReferenceItemRecordName = @"Devices";


@interface OverviewViewController ()

@property (nonatomic, readonly) NSMutableArray *list;

@end

@implementation OverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = [[NSMutableArray alloc] init];
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    
    NSString *deviceName = @"iPad 2";
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", deviceName];
//    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Devices" predicate:predicate];
//    [publicDatabase performQuery:query
//                     inZoneWithID:nil
//                completionHandler:^(NSArray *results, NSError *error){
//                    if (!error){
//                        for (CKRecord *record in results) {
//                            NSLog(@"Found: %@", record);
//                        }
//                    }
//                }];
    
//    CKRecordID *recordId = [[CKRecordID alloc] initWithRecordName:@"Devices"];
//
//    [publicDatabase fetchRecordWithID:recordId completionHandler:^(CKRecord *fetchedRecord, NSError *error) {
//        if(error){
//            [self.list addObject: @"test"];
//            [self.table reloadData];
//            NSLog(@"Error: %@, fetched: %@", error, fetchedRecord);
//        }else{
//            [self.list addObject: fetchedRecord];
//            [self.table reloadData];
//        }
//    }];
    
    [self fetchRecordsWithType:ReferenceItemRecordName completionHandler:^(NSArray *records) {
        
        self.list.array = records;

    }];

   
    //tableData = [NSArray arrayWithObjects:@"test", @"test2", nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler {
    
    NSPredicate *truePredicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:truePredicate];
    query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    CKQueryOperation *queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    // Just request the name field for all records
    //queryOperation.desiredKeys = @[@"name"];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        [results addObject:record];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        if (error) {
            // In your app, this error needs love and care.
            NSLog(@"An error occured in %@: %@", NSStringFromSelector(_cmd), error);
            abort();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                completionHandler(results);
            });
        }
    };
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [container publicCloudDatabase];
    [publicDatabase addOperation:queryOperation];
}

@end
