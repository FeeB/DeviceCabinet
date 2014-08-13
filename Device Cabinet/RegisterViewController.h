//
//  RegisterViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 13.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface RegisterViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *userName;

-(IBAction)sendRegisterMail:(id)sender;

@end
