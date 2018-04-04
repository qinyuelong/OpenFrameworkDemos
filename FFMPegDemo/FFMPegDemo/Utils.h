//
//  Utils.h
//  FFMPegDemo
//
//  Created by qinge on 2017/8/7.
//  Copyright © 2017年 qin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Utils : NSObject

+(UIImage *)sampleBufferToImage:(CMSampleBufferRef)sampleBuffer;

@end
