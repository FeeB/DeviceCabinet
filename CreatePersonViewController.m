//
//  CreatePersonViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "CreatePersonViewController.h"
#import "Person.h"
#import "CloudKitManager.h"
#import "UserDefaults.h"
#import "OverviewViewController.h"

NSString * const OverviewFromPersonSegueIdentifier = @"CreatePersonToOverview";

@interface CreatePersonViewController ()
    @property (readonly) CKContainer *container;
    @property (readonly) CKDatabase *publicDatabase;
@end

@implementation CreatePersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(160, 240);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storePerson
{
    BOOL isStorable = true;
    NSMutableArray *txtFields = [[NSMutableArray alloc]initWithObjects:self.firstNameTextField.text, self.lastNameTextField.text, self.userNameTextField.text, nil];
    
    for (NSString *textField in txtFields) {
        if ([textField isEqualToString:@""]) {
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"empty textfield", nil)
                                       message:[NSString stringWithFormat: NSLocalizedString(@"empty textfield text", nil), textField]
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            isStorable = false;
            break;
        }
    }
    
    if (isStorable) {
        [self.spinner startAnimating];
        
        __block Person *person = [[Person alloc] init];
        person.firstName = self.firstNameTextField.text;
        person.lastName = self.lastNameTextField.text;
        person.userName = self.userNameTextField.text;
        person.isAdmin = self.isAdminSwitch.on;
        
        CloudKitManager *cloudManager = [[CloudKitManager alloc] init];
        [cloudManager storePerson:person completionHandler:^{
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"saved", nil)
                                       message:[NSString stringWithFormat: NSLocalizedString(@"saved person", nil), person.firstName, person.lastName]
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            UserDefaults *userDefaults = [[UserDefaults alloc]init];
            [userDefaults storeUserDefaults:person.userName userType:@"person"];
            
            OverviewViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OverviewControllerId"];
            controller.comesFromRegister = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
            [self performSegueWithIdentifier:OverviewFromPersonSegueIdentifier sender:self];
        }];

    }
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
