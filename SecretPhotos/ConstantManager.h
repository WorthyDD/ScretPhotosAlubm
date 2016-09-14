//
//  ConstantManager.h
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Video.h"


static NSString *const photosID = @"my_secret_photos_are_here";
static NSString *const videosID = @"videos.plist";

@interface ConstantManager : NSObject

+ (instancetype) shareManager;

@property (nonatomic) NSMutableArray<NSString *> *photoKeys;
@property (nonatomic) NSMutableArray<Video *> *videos;


- (void) loadPhotos;
- (void) savePhotos;

- (void) loadVideos;
- (void) saveVideos;

@end
