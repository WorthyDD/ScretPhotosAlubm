//
//  PhotoCell.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype) cellFromXib : (UICollectionView *)collectionView indexPath : (NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    CATransform3D transform = CATransform3DIdentity;
    //    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);//渐变
//    CGFloat distance = -300;
    transform = CATransform3DMakeScale(0.5, 0.5, 1);
    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
//    transform = CATransform3DTranslate(transform, 0, distance, 0);//左边水平移动
    //        transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    cell.layer.transform = transform;
//    cell.layer.anchorPoint = point;
    cell.layer.opacity = 0;
    [UIView animateWithDuration:1.0 animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
    return cell;
}

@end
