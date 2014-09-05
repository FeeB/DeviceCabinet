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

NSString * const FromDeviceOverviewToStartSegue = @"FromDeviceOverviewToStart";

@interface DeviceViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    self.personObject = [[Person alloc] init];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height*1.2);
    
    if (self.deviceObject.image) {
        self.imageView.image = self.deviceObject.image;
    } else {
        self.imageView.image = [UIImage imageNamed:@"placeholder_image.png"];
    }
    
    
    if (self.comesFromStartView) {
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.hidesBackButton = NO;
    }
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showOrHideTextFields];
    
    Person *bookedFrom = self.deviceObject.bookedFromPerson;
    [bookedFrom createFullNameWithFirstName];
    self.bookedFromLabelText.text = bookedFrom.fullName;
    
    if (self.deviceObject.image) {
        self.imageView.image = self.deviceObject.image;
    } else {
        self.imageView.image = [UIImage imageNamed:@"placeholder_image.png"];
    }
    
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
        if (!device.isBooked) {
            [AppDelegate.dao storePersonObjectAsReferenceWithDevice:self.deviceObject person:self.personObject completionHandler:^(CKRecord *record, NSError *error) {
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
                    self.deviceObject.isBooked = YES;
                    [self.personObject createFullNameWithFirstName];
                    self.deviceObject.bookedFromPerson = self.personObject;
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
    
    [AppDelegate.dao deleteReferenceInDeviceWithDevice:self.deviceObject completionHandler:^(CKRecord *record, NSError *error) {
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
            self.deviceObject.isBooked = NO;
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
    
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *username = [userDefaults getUserIdentifier];
    NSString *userType = [userDefaults getUserType];
    
    BOOL isStorable = YES;
    
    if ([userType isEqualToString:@"device"] && !self.deviceObject.isBooked){
        if (self.usernameTextField && self.usernameTextField.text.length > 0) {
            username = self.usernameTextField.text;
        } else {
            isStorable = NO;
           [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_USERNAME_EMPTY", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_USERNAME_EMPTY", nil), self.deviceObject.deviceName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }
    
    if (isStorable) {
        if (!self.deviceObject.isBooked){
            self.deviceObject.isBooked = true;
            
            [AppDelegate.dao fetchPersonWithUsername:username completionHandler:^(Person *person, NSError *error) {
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
}

- (void)showOrHideTextFields {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    NSString *currentUserIdentifier = [userDefaults getUserIdentifier];
    NSString *currentUserType = [userDefaults getUserType];
    
    [self.usernameTextField setHidden:true];
    [self.usernameLabel setHidden:true];
    [self.bookedFromLabel setHidden:false];
    [self.bookedFromLabelText setHidden:false];
    
    if (self.deviceObject.isBooked) {
        if ([currentUserIdentifier isEqualToString:self.deviceObject.bookedFromPerson.userName] || [currentUserType isEqualToString:@"device"]) {
            [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_RETURN", nil) forState:UIControlStateNormal];
        }else{
            [self.bookDevice setEnabled:false];
            [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_ALREADY_BOOKED", nil) forState:UIControlStateNormal];
        }
    }else{
        [self.bookedFromLabel setHidden:true];
        [self.bookedFromLabelText setHidden:true];
        
        if ([[userDefaults getUserType] isEqualToString:@"device"]){
            self.navigationItem.hidesBackButton = YES;
            [self.usernameTextField setHidden:false];
            [self.usernameLabel setHidden:false];
        }
    }
}

- (IBAction)logOut {
    UserDefaults *userDefaults = [[UserDefaults alloc]init];
    [userDefaults resetUserDefaults];
    [self performSegueWithIdentifier:LogoutButtonSegue sender:nil];
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
        
        // retrieve the image and resize it down
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        CGSize newSize = CGSizeMake(512, 512);
        
        if (image.size.width > image.size.height) {
            newSize.height = round(newSize.width * image.size.height / image.size.width);
        } else {
            newSize.width = round(newSize.height * image.size.width / image.size.height);
        }
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        NSData *data = UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.75);
        UIGraphicsEndImageContext();
        
        // write the image out to a cache file
        NSURL *cachesDirectory = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        NSString *temporaryName = [[NSUUID UUID].UUIDString stringByAppendingPathExtension:@"jpeg"];
        NSURL *localURL = [cachesDirectory URLByAppendingPathComponent:temporaryName];
        [data writeToURL:localURL atomically:YES];
        
        // upload the cache file as a CKAsset
        [AppDelegate.dao uploadAssetWithURL:localURL device:self.deviceObject completionHandler:^(Device *device, NSError *error) {
            if (error) {
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                self.deviceObject = device;
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
    [self.scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    return YES;
}

- (void) dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.view removeGestureRecognizer:self.tap];
}


@end
