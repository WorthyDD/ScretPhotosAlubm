//
//  VideoCell.h
//  SecretPhotos
//
//  Created by 武淅 段 on 16/9/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UICollectionViewCell

+ (instancetype) cellFromXib : (UICollectionView *)collectionView indexPath : (NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;


@end
