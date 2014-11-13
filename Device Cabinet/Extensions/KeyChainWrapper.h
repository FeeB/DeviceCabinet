//
//  UIdGenerator.h
//  Device Cabinet
//
//  Created by Braun,Fee on 18.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainWrapper : NSObject

+ (void)setDeviceUdId:(NSString *)deviceId;
+ (NSString *)getDeviceUdId;
+ (BOOL)hasDeviceUdId;

+ (void)reset;

@end
