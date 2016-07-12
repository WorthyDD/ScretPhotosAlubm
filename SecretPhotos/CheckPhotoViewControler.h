//
//  CheckPhotoViewControler.h
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosViewController.h"

@interface CheckPhotoViewControler : UIViewController
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger currentIndex;
@end
