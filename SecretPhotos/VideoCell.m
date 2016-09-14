//
//  VideoCell.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/9/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype) cellFromXib : (UICollectionView *)collectionView indexPath : (NSIndexPath *)indexPath
{
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    
//    CATransform3D transform = CATransform3DIdentity;
////    transform = CATransform3DMakeScale(0.8, 0.8, 1);
//    transform = CATransform3DRotate(transform, M_PI/2, 1, 0, 0);
//    cell.layer.transform = transform;
//    cell.layer.opacity = 0;
//    [UIView animateWithDuration:1.0 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.layer.opacity = 1;
//    }];
    return cell;
}

@end
