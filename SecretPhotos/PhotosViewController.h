//
//  PhotosViewController.h
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

@interface PhotosViewController : UICollectionViewController

@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSMutableArray<Video *> *videos;
@property (nonatomic, assign) NSInteger entry;  //0 photo 1 video

@end
