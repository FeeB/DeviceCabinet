//
//  OverviewViewController.h
//  Device Cabinet
//
//  Created by Braun,Fee on 04.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (void)fetchRecordsWithType:(NSString *)recordType completionHandler:(void (^)(NSArray *records))completionHandler;


@end
