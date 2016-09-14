//
//  PhotoCell.h
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

+ (instancetype) cellFromXib : (UICollectionView *)collectionView indexPath : (NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;


@end
