//
//  DeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceViewController.h"
#import "UserDefaults.h"
#import "TEDLocalization.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "RailsApiDao.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OverviewViewController.h"
#import "LogInViewController.h"
#import "UserNamePickerViewController.h"

NSString * const FromDeviceOverviewToStartSegue = @"FromDeviceOverviewToStart";
NSString * const FromDeviceOverviewToOverview = @"FromDeviceViewToOverview";
NSString * const FromDeviceOverviewToNameListSegue = @"FromDeviceOverviewToNameList";

@interface DeviceViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [TEDLocalization localize:self];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.transform = CGAffineTransformMakeScale(2, 2);
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    //set label text
    self.individualDeviceCategoryLabel.text = self.deviceObject.category;
    self.deviceCategoryLabel.text = NSLocalizedString(@"LABEL_CATEGORY", nil);
    self.individualDeviceNameLabel.text = self.deviceObject.deviceName;
    self.deviceNameLabel.text = NSLocalizedString(@"LABEL_DEVICENAME", nil);
    self.individualSystemVersionLabel.text = self.deviceObject.systemVersion;
    self.systemVersionLabel.text = NSLocalizedString(@"LABEL_SYSTEM_VERSION", nil);
    [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_BOOK", nil) forState:UIControlStateNormal];
    self.usernameLabel.text = NSLocalizedString(@"LABEL_ENTER_USERNAME", nil);
    self.bookedFromLabel.text = NSLocalizedString(@"LABEL_BOOKED_FROM", nil);
    self.individualDeviceTypeLabel.text = self.deviceObject.deviceType;
    self.deviceTypeLabel.text = NSLocalizedString(@"LABEL_DEVICE_TYPE", nil);
    
    [self.imageView setImageWithURL:self.deviceObject.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tap];
    [self showOrHideTextFields];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showOrHideTextFields];

    self.bookedFromLabelText.text = self.deviceObject.bookedByPersonFullName;
    
    if (self.deviceObject.imageUrl) {
        [self.imageView setImageWithURL:self.deviceObject.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    } else {
        [AppDelegate.dao fetchDeviceRecordWithDevice:self.deviceObject completionHandler:^(Device *device, NSError *error) {
            if (error) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [self.spinner stopAnimating];
                
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                self.deviceObject.imageUrl = device.imageUrl;
                [self.imageView setImageWithURL:self.deviceObject.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
            }
        }];
    };
    
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tap];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(viewWillAppear:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)storeReference {
    [self.spinner startAnimating];
    
    [AppDelegate.dao fetchDeviceRecordWithDevice:self.deviceObject completionHandler:^(Device *device, NSError *error) {
        if (!device.isBookedByPerson) {
            [AppDelegate.dao storePersonObjectAsReferenceWithDevice:self.deviceObject person:self.personObject completionHandler:^(NSError *error) {
                if (error) {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    [self.spinner stopAnimating];
                    
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                } else {
                    [self.spinner stopAnimating];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_BOOK_SUCCESS", nil) message:NSLocalizedString(@"MESSAGE_BOOK_SUCCESS", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_RETURN", nil) forState:UIControlStateNormal];
                    self.deviceObject.bookedByPerson = YES;
                    self.deviceObject.bookedByPersonId = self.personObject.personRecordId;
                    self.usernameTextField.text = @"";
                }
            }];
        } else {
            [self.spinner stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_ALREADY_BOOKED", nil) message:NSLocalizedString(@"MESSAGE_ALREADY_BOOKED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self viewWillAppear:YES];
        }
    }];
}

- (void)deleteReference {
    [self.spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [AppDelegate.dao deleteReferenceInDeviceWithDevice:self.deviceObject completionHandler:^(NSError *error) {
        if (error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.spinner stopAnimating];
            
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.spinner stopAnimating];
            
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_RETURN_SUCCESS", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_RETURN_SUCCESS", nil), self.deviceObject.deviceName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_BOOK", nil) forState:UIControlStateNormal];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (!self.comesFromStartView) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self viewWillAppear:YES];
    }
}

//Action when user clicks on button
- (IBAction)fetchPersonRecordOnClick {
    [self.spinner startAnimating];
    
    BOOL isStorable = YES;
    NSString *fullName = [[NSString alloc]init];
    
    if (!self.deviceObject.isBookedByPerson) {
        if (self.usernameTextField && self.usernameTextField.text.length > 0) {
            fullName = self.usernameTextField.text;
        } else {
            isStorable = NO;
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_EMPTY", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_USERNAME_EMPTY", nil), self.deviceObject.deviceName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    } else {
        isStorable = NO;
    }
    
    if (isStorable) {
        self.deviceObject.bookedByPerson = true;
        
        [AppDelegate.dao fetchPersonWithFullName:fullName completionHandler:^(Person *person, NSError *error) {
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [self.spinner stopAnimating];
            } else {
                self.personObject = person;
                [self storeReference];
            }
        }];
    } else {
        [self deleteReference];
    }
}



- (void)showOrHideTextFields {
   
    self.bookedFromLabel.hidden = NO;
    self.bookedFromLabelText.hidden = NO;
    self.usernameTextField.hidden = YES;
    self.usernameLabel.hidden = YES;

    
    if (self.deviceObject.isBookedByPerson) {
        [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_RETURN", nil) forState:UIControlStateNormal];
    }else{
        self.bookedFromLabel.hidden = YES;
        self.bookedFromLabelText.hidden = YES;
        self.usernameTextField.hidden = NO;
        self.usernameLabel.hidden = NO;

    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)takePhoto {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        [self.spinner startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

        RailsApiDao *apiDao = [[RailsApiDao alloc] init];
        [apiDao uploadImage:info[UIImagePickerControllerOriginalImage] forDevice:self.deviceObject completionHandler:^(NSError *error) {
            if (error) {
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                self.deviceObject.imageUrl = nil;
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [self viewWillAppear:YES];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self performSegueWithIdentifier:FromDeviceOverviewToNameListSegue sender:nil];
    return YES;
}

- (void)selectedUser:(NSString *)fullUserName {
    self.usernameTextField.text = fullUserName;
    
    if (self.userNamePickerPopover) {
        [self.userNamePickerPopover dismissPopoverAnimated:YES];
        self.userNamePickerPopover = nil;
    }
}

- (void) dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.view removeGestureRecognizer:self.tap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FromDeviceOverviewToOverview]){
        OverviewViewController *controller = (OverviewViewController *)segue.destinationViewController;
        controller.userIsLoggedIn = self.userIsLoggedIn;
    } else if([segue.identifier isEqualToString:FromDeviceOverviewToNameListSegue]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        UserNamePickerViewController *controller = (UserNamePickerViewController *)navigationController.topViewController;
        controller.onCompletion = ^(Person *person) {
            self.usernameTextField.text = person.fullName;
        };
    }
}

@end
