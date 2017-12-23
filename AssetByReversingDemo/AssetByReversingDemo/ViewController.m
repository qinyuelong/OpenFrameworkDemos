//
//  ViewController.m
//  AssetByReversingDemo
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 apple. All rights reserved.
//  https://github.com/whydna/Reverse-AVAsset-Efficient/blob/master/AVUtilities.m

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)action:(id)sender {
    NSURL *srcURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mov"];
    AVAsset *asset = [AVAsset assetWithURL:srcURL];
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"copytest.mov"];
    NSURL *destURL = [NSURL fileURLWithPath:filePath];

    [self assetByReversingAsset:asset outputURL:destURL];
    
}


- (void)assetByReversingAsset:(AVAsset *)asset outputURL:(NSURL *)outputURL{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] lastObject];
        NSDictionary *readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange], kCVPixelBufferPixelFormatTypeKey, nil];
        AVAssetReaderTrackOutput *readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:readerOutputSettings];
        [reader addOutput:readerOutput];
        [reader startReading];
        
        // read in the samples
        NSMutableArray *samples = [[NSMutableArray alloc] init];
        
        CMSampleBufferRef sample;
        while ((sample = [readerOutput copyNextSampleBuffer])) {
            [samples addObject:(__bridge id)sample];
            CFRelease(sample);
        }
        
        // Initialize the writer
        AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:outputURL
                                                          fileType:AVFileTypeMPEG4
                                                             error:&error];
        
        NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @(videoTrack.estimatedDataRate), AVVideoAverageBitRateKey,
                                               nil];
        
        NSDictionary *writerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                              AVVideoCodecH264, AVVideoCodecKey,
                                              [NSNumber numberWithInt:videoTrack.naturalSize.width], AVVideoWidthKey,
                                              [NSNumber numberWithInt:videoTrack.naturalSize.height], AVVideoHeightKey,
                                              videoCompressionProps, AVVideoCompressionPropertiesKey,
                                              nil];
        
        AVAssetWriterInput *writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:writerOutputSettings];
        
        [writerInput setExpectsMediaDataInRealTime:NO];
        
        AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:writerInput sourcePixelBufferAttributes:nil];
        [writer addInput:writerInput];
        [writer startWriting];
        [writer startSessionAtSourceTime:kCMTimeZero];
        
        for (NSInteger i = 0; i < samples.count; i++) {
            CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp((__bridge CMSampleBufferRef)samples[i]);
            CVPixelBufferRef imageBufferRef = CMSampleBufferGetImageBuffer((__bridge CMSampleBufferRef)samples[i]);
            while (![writerInput isReadyForMoreMediaData]) {
                [NSThread sleepForTimeInterval:0.1];
            }
            [pixelBufferAdaptor appendPixelBuffer:imageBufferRef withPresentationTime:presentationTime];
        }
        [writer finishWritingWithCompletionHandler:^{
            NSLog(@"复制完成");
        }];
    });
}


@end
