//
//  ConstantManager.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "ConstantManager.h"

@implementation ConstantManager

+ (instancetype)shareManager
{
    static ConstantManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ConstantManager alloc]init];
        
    });
    return manager;
}

- (void)loadPhotos
{

    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:photosID];
    self.photoKeys = [NSMutableArray arrayWithArray:arr];

}

- (void) savePhotos
{
    [[NSUserDefaults standardUserDefaults] setObject:self.photoKeys forKey:photosID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadVideos
{
    id arr = [[NSUserDefaults standardUserDefaults] objectForKey:videosID];
    self.videos = [NSMutableArray new];
    for(NSData *data in arr){
        Video *video = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_videos addObject:video];
    }
    NSLog(@"加载视频成功!");
}

- (void)saveVideos
{
    NSMutableArray *saveArray = [NSMutableArray new];
    for(Video *video in _videos){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:video];
        [saveArray addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:videosID];
    /*if([NSKeyedArchiver archiveRootObject:saveArray toFile:[NSHomeDirectory() stringByAppendingString:videosID]]){
        NSLog(@"归档成功!");
    }
    else{
        NSLog(@"归档失败!");
    }*/
}

@end
