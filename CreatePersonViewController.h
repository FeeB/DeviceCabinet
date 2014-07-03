//
//  CreatePersonViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePersonViewController : UIViewController{
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
}

- (IBAction)storePerson;

@end
