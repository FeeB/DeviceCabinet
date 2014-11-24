//
//  UserNamePickerViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 02.10.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "UserNamePickerViewController.h"
#import "CreatePersonViewController.h"
#import "TEDLocalization.h"
#import "RailsApiDao.h"
#import "Person.h"

@interface UserNamePickerViewController ()

@end

@implementation UserNamePickerViewController

NSString *const FromNameListToCreatePersonSegue = @"FromNameListToCreatePerson";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllPeople];
    [TEDLocalization localize:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [self getAllPeople];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//get all people for the device overview
- (void)getAllPeople {
    
    [[RailsApiDao sharedInstance] fetchPeopleWithCompletionHandler:^(NSArray *peopleObjects, NSError *error) {
        if (error) {
            self.userNames = [[NSMutableArray alloc] init];
            NSMutableArray *errorMessage = [[NSMutableArray alloc] init];
            [errorMessage addObject:error.localizedRecoverySuggestion];
            [self.userNames addObject:errorMessage];
            
            [self.tableView reloadData];
            
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            
        } else {
            self.userNames = [[NSMutableArray alloc] init];
            
            for (Person *person in peopleObjects){
                [self.userNames addObject:person];
            }
            [self.tableView reloadData];
        }
    }];
}


//standard methods for tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.userNames[0] isKindOfClass:[Person class]]) {
        
        Person *cellPerson = [self.userNames objectAtIndex:indexPath.row];
        cell.textLabel.text = cellPerson.fullName;

    } else {
        cell.textLabel.text = self.userNames[0];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

//On click on one cell the device view will appear
- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.personObject =[self.userNames objectAtIndex:indexPath.row];
    [self dissmissController];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Person *person = [self.userNames objectAtIndex:indexPath.row];
        [[RailsApiDao sharedInstance] deletePerson:person completionHandler:^(NSError *error) {
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
            [self updateTable];
        }];
        
    }
}

- (IBAction)addPerson {
    [self performSegueWithIdentifier:FromNameListToCreatePersonSegue sender:nil];
}

-(void)dissmissController{
    if (self.onCompletion) {
        self.onCompletion(self.personObject);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromNameListToCreatePersonSegue]) {
        CreatePersonViewController *controller = (CreatePersonViewController *)segue.destinationViewController;
        controller.onCompletion = ^(Person *person){
            self.personObject = person;
            [self dissmissController];
        };
    }
}

- (IBAction)backButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTable {
    [self getAllPeople];
    [self.refreshControl endRefreshing];
}
@end
