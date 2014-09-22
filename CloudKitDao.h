//
//  CloudKitManager.h
//  Device Cabinet
//
//  Created by Braun,Fee on 06.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "DeviceCabinetDAO.h"

@interface CloudKitDao : NSObject <DeviceCabinetDao>

- (void)uploadAssetWithURL:(NSURL *)assetURL device:(Device *)device completionHandler:(void (^)(Device *device, NSError *error))completionHandler;

@end
