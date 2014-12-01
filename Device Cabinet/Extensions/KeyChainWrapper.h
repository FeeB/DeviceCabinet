//
//  UIdGenerator.h
//  Device Cabinet
//
//  Created by Braun,Fee on 18.08.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface KeyChainWrapper : NSObject

- (instancetype)initWithKeyChainWrapperItem:(KeychainItemWrapper *)keyChainItemWrapper;

- (void)setDeviceUdId:(NSString *)deviceId;
- (NSString *)getDeviceUdId;
- (BOOL)hasDeviceUdId;

- (void)reset;

@end
