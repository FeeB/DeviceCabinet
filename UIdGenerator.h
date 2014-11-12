//
//  UIdGenerator.h
//  Device Cabinet
//
//  Created by Braun,Fee on 18.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIdGenerator : NSObject

@property (nonatomic, assign) BOOL isCurrentDevice;

- (NSString *)getDeviceId;
- (void)setDeviceId:(NSString *)deviceId;
- (NSString *)getIdfromKeychain;
- (void)resetKeyChain;
- (BOOL)hasDeviceIdInKeyChain;

@end
