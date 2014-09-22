//
//  Device.m
//  Device Cabinet
//
//  Created by Braun,Fee on 03.07.14.
//  Copyright (c) 2014 Braun,Fee. All rights reserved.
//

#import "Device.h"
#import "Person.h"

@implementation Device

- (NSString *)imageData {
    if (self.image) {
        NSData *imageData = UIImagePNGRepresentation(self.image);
        return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"placeholder_image.png"]);
        return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
}

- (NSDictionary *)toDictionary {
    NSDictionary *dictionary = @{@"deviceName" : self.deviceName, @"deviceId" : self.deviceId, @"category" : self.category, @"deviceId" : self.deviceId, @"systemVersion" : self.systemVersion, @"isBooked" : self.isBooked ? @"YES" : @"NO", @"image_data_encoded" : self.imageData};
    
    return dictionary;
}

@end
