//
//  PhotosViewController.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "PhotosViewController.h"
#import "ConstantManager.h"
#import "MSImagePickerController.h"
#import "PhotoCell.h"
#import "CheckPhotoViewControler.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PhotosViewController ()<MSImagePickerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout>



@property (nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation PhotosViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    _indicator.hidden = YES;
    [_indicator setHidesWhenStopped:YES];
    UINib *nib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    
    _photos = [ConstantManager shareManager].photoKeys;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (IBAction)addPhotos:(id)sender {
    
    MSImagePickerController *picker = [[MSImagePickerController alloc]init];
    [picker setEditing:NO];
    [picker setAllowsEditing:NO];
    picker.msDelegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


- (IBAction)selectPhotos:(id)sender {
    
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imKey = _photos[indexPath.row];
    NSData *imData = [[NSUserDefaults standardUserDefaults]objectForKey:imKey];
    UIImage *im = [UIImage imageWithData:imData];
    [cell.photo setImage:im];
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = (width-5*3)/4.0;
    return CGSizeMake(w, w);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSData *data = _photos[indexPath.row];
    [self performSegueWithIdentifier:@"check" sender:@(indexPath.row)];
    
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




#pragma mark - MS delegate

- (void)imagePickerController:(MSImagePickerController *)picker didFinishPickingImage:(NSArray *)images
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [_indicator startAnimating];
        _indicator.hidden = NO;
        for(UIImage *im in images){
            NSData *data = UIImageJPEGRepresentation(im, 1.0);
            NSTimeInterval time = [[NSDate date]timeIntervalSince1970]*1000;
            NSString *imKey = [NSString stringWithFormat:@"%.f", time];
            NSLog(@"\n\nkey---%@\n\n", imKey);
            [[ConstantManager shareManager].photoKeys addObject:imKey];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:imKey];
        }
//        [ConstantManager shareManager].photos = _photos;
        [self.collectionView reloadData];
        [[ConstantManager shareManager]savePhotos];
        [_indicator stopAnimating];
    }];
}

- (void)imagePickerControllerDidCancel:(MSImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"check"]){
        CheckPhotoViewControler *vc = segue.destinationViewController;
        vc.currentIndex = ((NSNumber *)sender).integerValue;
        vc.photos = _photos;
    }
}
@end
