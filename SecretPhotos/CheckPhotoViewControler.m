//
//  CheckPhotoViewControler.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "CheckPhotoViewControler.h"
#import "ConstantManager.h"

@interface CheckPhotoViewControler ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CheckPhotoViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photos = [ConstantManager shareManager].photoKeys;
}

/*
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}*/

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}

- (IBAction)delete:(id)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"askDelete", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *imKey = _photos[_currentIndex];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:imKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_photos removeObjectAtIndex:_currentIndex];
        [_collectionView reloadData];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancle", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:delete];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    
//    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    
    NSString *imKey = _photos[_currentIndex];
    NSData *imData = [[NSUserDefaults standardUserDefaults]objectForKey:imKey];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imData], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = NSLocalizedString(@"saveFail", nil) ;
    }else{
        msg = NSLocalizedString(@"saveSuccess", nil);
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", nil)
                          
                                                    message:msg
                        
                                                   delegate:self
                
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          
                                          otherButtonTitles:nil];
        [alert show];
    }

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *imKey = _photos[indexPath.row];
    NSData *imData = [[NSUserDefaults standardUserDefaults]objectForKey:imKey];
    UIImage *im = [UIImage imageWithData:imData];
    for(UIView *v in cell.contentView.subviews){
        if([v isKindOfClass:[UIImageView class]]){
            UIImageView *iv = (UIImageView *)v;
            [iv setImage:im];
        }
    }
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGFloat w = (width-5*3)/4.0;
    return CGSizeMake(width,height-64-50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex =  _collectionView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    NSLog(@"\n\ncurrent index : %ld\n\n", _currentIndex);
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


@end
