//
//  DeviceViewController.m
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceViewController.h"
#import "TEDLocalization.h"
#import "RailsApiDao.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OverviewViewController.h"
#import "UserNamePickerViewController.h"
#import "UserDefaultsWrapper.h"

NSString * const FromDeviceOverviewToNameListSegue = @"FromDeviceOverviewToNameList";

@interface DeviceViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
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
    self.individualDeviceCategoryLabel.text = self.device.type;
    self.individualDeviceNameLabel.text = self.device.deviceName;
    self.individualSystemVersionLabel.text = self.device.systemVersion;
    self.individualDeviceTypeLabel.text = self.device.deviceType;
    
    [self.imageView setImageWithURL:self.device.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [self showOrHideTextFields];
    
    if (self.automaticReturn) {
        [self deleteReference];
    }
    
    self.separatingView.clipsToBounds = YES;
    
    [self topBorder];
    
    if ([self.device.type isEqualToString:@"iPhone"] || [self.device.type isEqualToString:@"iPad"]) {
        [self.systemVersionPhoto setImage:[UIImage imageNamed:@"apple.png"]];
    } else {
        [self.systemVersionPhoto setImage:[UIImage imageNamed:@"android.png"]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView {
    [self showOrHideTextFields];
    
    self.bookedFromLabelText.text = self.device.bookedByPersonFullName;
    
    if (!self.device.imageUrl) {
        [self.imageView setImageWithURL:self.device.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [[[RailsApiDao alloc] init] fetchDeviceWithDevice:self.device completionHandler:^(Device *device, NSError *error) {
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                self.device.imageUrl = device.imageUrl;
                [self.imageView setImageWithURL:self.device.imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            }
        }];
    };
}

- (void)storeReference {
    [self.spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[[RailsApiDao alloc] init] fetchDeviceWithDevice:self.device completionHandler:^(Device *device, NSError *error) {
        if (!device.isBookedByPerson) {
            [[[RailsApiDao alloc] init] storePersonObjectAsReferenceWithDevice:self.device person:self.person completionHandler:^(NSError *error) {
                [self.spinner stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (error) {
                    [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                               message:error.localizedRecoverySuggestion
                                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                } else {
                    [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_BOOK_SUCCESS", nil) message:NSLocalizedString(@"MESSAGE_BOOK_SUCCESS", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_RETURN", nil) forState:UIControlStateNormal];
                    self.device.bookedByPerson = YES;
                    self.device.bookedByPersonId = self.person.personId;
                    self.device.bookedByPersonFullName = self.person.fullName;
                    if ([self.device.deviceUdId isEqualToString:[UserDefaultsWrapper getLocalDevice].deviceUdId]) {
                        [UserDefaultsWrapper setLocalDevice:self.device];
                    }
                    
                }
            }];
        } else {
            [self.spinner stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_ALREADY_BOOKED", nil) message:NSLocalizedString(@"MESSAGE_ALREADY_BOOKED", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self updateView];
        }
    }];
}

- (void)deleteReference {
    [self.spinner startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[[RailsApiDao alloc] init] deleteReferenceInDeviceWithDevice:self.device completionHandler:^(NSError *error) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self.spinner stopAnimating];
        
        if (error) {
            [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                       message:error.localizedRecoverySuggestion
                                      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"HEADLINE_RETURN_SUCCESS", nil) message:[NSString stringWithFormat: NSLocalizedString(@"MESSAGE_RETURN_SUCCESS", nil), self.device.deviceName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_BOOK", nil) forState:UIControlStateNormal];
            self.device.bookedByPerson = NO;
            if ([self.device.deviceUdId isEqualToString:[UserDefaultsWrapper getLocalDevice].deviceUdId]) {
                [UserDefaultsWrapper setLocalDevice:self.device];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isStorable {
    
    if (!self.device.isBookedByPerson) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showOrHideTextFields {
    self.bookedFromLabelText.hidden = NO;
    self.userPhoto.hidden = NO;
    
    if (self.device.isBookedByPerson) {
        [self.bookDevice setTitle:NSLocalizedString(@"BUTTON_RETURN", nil) forState:UIControlStateNormal];
    }else{
        self.bookedFromLabelText.hidden = YES;
        self.userPhoto.hidden = YES;
    }
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

        [[[RailsApiDao alloc] init] uploadImage:info[UIImagePickerControllerOriginalImage] forDevice:self.device completionHandler:^(NSError *error) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self.spinner stopAnimating];
            if (error) {
                [[[UIAlertView alloc]initWithTitle:error.localizedDescription
                                           message:error.localizedRecoverySuggestion
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            } else {
                self.device.imageUrl = nil;
                [self updateView];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickOnBookButton {
    if ([self isStorable]) {
        [self performSegueWithIdentifier:FromDeviceOverviewToNameListSegue sender:nil];
    } else {
        [self deleteReference];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if([segue.identifier isEqualToString:FromDeviceOverviewToNameListSegue]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        UserNamePickerViewController *controller = (UserNamePickerViewController *)navigationController.topViewController;
        controller.onCompletion = ^(Person *person) {
            self.person = person;
            if (self.person) {
                self.device.bookedByPerson = true;
                [self storeReference];
            }
        };
    }
}

- (void)topBorder {
    //http://stackoverflow.com/questions/6446279/what-is-the-uicolor-of-the-default-uitableview-separator
    //http://stackoverflow.com/questions/7022656/calayer-add-a-border-only-at-one-side
    CALayer *topBorder = [CALayer layer];
    topBorder.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0].CGColor;
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.separatingView.frame), 1);
    
    [self.separatingView.layer addSublayer:topBorder];
}

@end
