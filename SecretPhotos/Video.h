//
//  Video.h
//  SecretPhotos
//
//  Created by 武淅 段 on 16/9/14.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Video : NSObject<NSCoding>

@property (nonatomic) NSString *filename;
@property (nonatomic) NSString *size;
@property (nonatomic) UIImage *thum;
@property (nonatomic) NSString *filePath;
@property (nonatomic, assign) BOOL selected;
@end
