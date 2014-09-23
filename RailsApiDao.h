//
//  apiExtension.h
//  Device Cabinet
//
//  Created by Braun,Fee on 02.09.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceCabinetDAO.h"

@interface RailsApiDao : NSObject <DeviceCabinetDao>

- (void)uploadImageWithDevice:(Device *)device completionHandler:(void (^)(NSError *error))completionHandler;

@end
