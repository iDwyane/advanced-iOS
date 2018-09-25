//
//  ViewController.m
//  GIF添加文字Demo
//
//  Created by Dwyane on 2018/9/25.
//  Copyright © 2018年 idwyane. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>

//const NSString static *kGIFImageUrl;
@interface ViewController ()

@property (nonatomic, strong) NSDictionary *gifDicInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addImage];
}



- (void)addImage {
    self.gifDicInfo = [self getGifInfoFromGifImage];
    
    //GIF 图片数组
    NSArray *images = [self getImagesWithText:[self.gifDicInfo objectForKey:@"images"]];
    
    //GIF 每帧延迟时间
    NSArray *delays = [self.gifDicInfo objectForKey:@"delays"];
    
    //是否循环
    NSUInteger loopCount = [[self.gifDicInfo objectForKey:@"loopCount"] integerValue];
    
    //创建图片路径
    NSString *cashPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:cashPath], (CFStringRef)kUTTypeGIF, images.count, NULL);
    
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:loopCount] forKey:(NSString *)kCGImagePropertyGIFLoopCount]forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    
    for (int i = 0; i < images.count; i++) {
        
        UIImage *image = [images objectAtIndex:i];
        
        NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[delays objectAtIndex:i] forKey:(NSString *)kCGImagePropertyGIFDelayTime] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)frameProperties);
        CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
        
    }
    
    
    CGImageDestinationFinalize(destination);
    
    CFRelease(destination);
    
    NSLog(@"animated GIF file created at %@", cashPath);
    
}


/* 获取GIF图片信息 */
- (NSDictionary *)getGifInfoFromGifImage {
    
    NSMutableArray *images = [NSMutableArray array];   // 图片数组
    NSMutableArray *delays = [NSMutableArray array];   // 每帧对应的延迟时间
    NSUInteger loopCount = 0;                          // 是否重复
    CGFloat totalTime;         // seconds
    CGFloat width;
    CGFloat height;
    
    getFrameInfo(images, delays, &totalTime, &width, &height, loopCount);
    
    NSMutableDictionary *gifDic = [NSMutableDictionary dictionary];
    gifDic[@"images"] = images;
    gifDic[@"delays"] = delays;
    gifDic[@"loopCount"] = @(loopCount);
    gifDic[@"duration"] = @(totalTime);
    gifDic[@"bounds"] = NSStringFromCGRect(CGRectMake(0, 0, width, height));
    
    return gifDic;
}

/* GIF图片解析 */
void getFrameInfo(NSMutableArray *frames, NSMutableArray *delayTimes, CGFloat *totalTime,CGFloat *gifWidth, CGFloat *gifHeight,NSUInteger loopCount)
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"happy.gif" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //获取gif的帧数
    size_t frameCount = CGImageSourceGetCount(gifSource);
    
    //获取GfiImage的基本数据
    NSDictionary *gifProperties = (__bridge NSDictionary *) CGImageSourceCopyProperties(gifSource, NULL);
    //由GfiImage的基本数据获取gif数据
    NSDictionary *gifDictionary =[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
    //获取gif的播放次数 0-无限播放
    loopCount = [[gifDictionary objectForKey:(NSString*)kCGImagePropertyGIFLoopCount] integerValue];
    CFRelease((__bridge CFTypeRef)(gifProperties));
    
    for (size_t i = 0; i < frameCount; ++i) {
        //得到每一帧的CGImage
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [frames addObject:[UIImage imageWithCGImage:frame]];
        CGImageRelease(frame);
        
        //获取每一帧的图片信息
        NSDictionary *frameDict = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL);
        
        //获取Gif图片尺寸
        if (gifWidth != NULL && gifHeight != NULL) {
            *gifWidth = [[frameDict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
            *gifHeight = [[frameDict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        }
        
        //由每一帧的图片信息获取gif信息
        NSDictionary *gifDict = [frameDict valueForKey:(NSString*)kCGImagePropertyGIFDictionary];
        //取出每一帧的delaytime
        [delayTimes addObject:[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime]];

        if (totalTime) {
            *totalTime = *totalTime + [[gifDict valueForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
        }
        CFRelease((__bridge CFTypeRef)(frameDict));
    }
    CFRelease(gifSource);
}

/* 在每张图片上添加文字 */
- (NSArray *)getImagesWithText:(NSArray *)arr{
    
    NSMutableArray *withTextImageArr = [NSMutableArray new];
    
    for (int index = 0; index < arr.count; index++) {
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        tempView.backgroundColor = [UIColor clearColor];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:tempView.bounds];
        tempImageView.image = [arr objectAtIndex:index];
        [tempView addSubview:tempImageView];
        
//        if (index!=1) { // 可以控制那一帧添加文字
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, tempView.bounds.size.height-30, tempView.bounds.size.width, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor purpleColor];
            label.text = @"Dwyane";
            [label setFont:[UIFont boldSystemFontOfSize:30]];
            [tempView addSubview:label];
//        }
       

        UIGraphicsBeginImageContextWithOptions(tempView.frame.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [tempView.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [withTextImageArr addObject:image];
        
        
        
    }
    
    return withTextImageArr;
}

@end
