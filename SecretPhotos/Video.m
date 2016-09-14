//
//  Video.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/9/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "Video.h"

@implementation Video

#define kFilename @"filename"
#define kFilePath @"filePath"
#define kThumnail @"thumnail"
#define kSize @"size"

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        _filename = [aDecoder decodeObjectForKey:kFilename];
        _size = [aDecoder decodeObjectForKey:kSize];
        _filePath = [aDecoder decodeObjectForKey:kFilePath];
        _thum = [aDecoder decodeObjectForKey:kThumnail];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_filename forKey:kFilename];
    [aCoder encodeObject:_filePath forKey:kFilePath];
    [aCoder encodeObject:_size forKey:kSize];
    [aCoder encodeObject:_thum forKey:kThumnail];
}

@end
