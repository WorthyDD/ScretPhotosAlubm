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
#import "UIColor+TAToolkit.h"
#import "CheckPhotoViewControler.h"
#import "VideoCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Toast.h"
#import "MBProgressHUD.h"


@import MobileCoreServices;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PhotosViewController ()<MSImagePickerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout>

typedef void(^Result)(Video *video, NSString *filename);
+ (void)getVideoFromAHAsset : (PHAsset *)asset Complete : (Result)result;

@property (nonatomic, assign) BOOL statusSelect;    //选择模式
@property (nonatomic) UIActivityIndicatorView *indicator;
@property (nonatomic) UIButton *selectButton;
@property (nonatomic) UIButton *deleteButton;
@property (nonatomic) UIButton *saveButton;

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
    UINib *nib1 = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:@"VideoCell"];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.allowsSelection = YES;
    
    
    if(_entry == 1){
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        [bottomView setBackgroundColor:[UIColor colorWithRGB:0x78bb5e]];
        UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 50)];
        [selectButton setTitle:@"选择" forState:UIControlStateNormal];
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 50)];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 0, SCREEN_WIDTH/3, 50)];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(didTapSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton addTarget:self action:@selector(didTapDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton addTarget:self action:@selector(didTapSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:selectButton];
        [bottomView addSubview:deleteButton];
        [bottomView addSubview:saveButton];
        [self.view addSubview:bottomView];
        [self.view bringSubviewToFront:bottomView];
        _selectButton = selectButton;
        _deleteButton = deleteButton;
        _saveButton = saveButton;
    }
//    _selectedArray = [NSMutableArray new];
    _photos = [ConstantManager shareManager].photoKeys;
    _videos = [ConstantManager shareManager].videos;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}


#pragma mark - button actions
- (void) didTapSelectButton : (id)sender
{
    UIButton *b = sender;
    b.selected = !b.selected;
    _statusSelect = b.selected;
    if(b.selected){
        [b setTitle:@"取消" forState:UIControlStateNormal];
    }
    else{
        //清空选择
        [b setTitle:@"选择" forState:UIControlStateNormal];
        if(_entry == 0){
            for(NSString *imgKey in _photos){
                
            }
        }
        else{
            for(Video *video in _videos){
                video.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
}

- (void) didTapDeleteButton : (id)sender
{
    if(_entry == 0){
        
    }
    else{
        
        NSMutableArray *copy = _videos.mutableCopy;
        for(Video *video in _videos){
            if(video.selected){
                [copy removeObject:video];
            }
        }
        _videos = copy;
        _statusSelect = NO;
        _selectButton.selected = NO;
        [_selectButton setTitle:@"选择" forState:UIControlStateNormal];
        [ConstantManager shareManager].videos = _videos;
        [[ConstantManager shareManager] saveVideos];
        [self.collectionView reloadData];
    }
}

- (void) didTapSaveButton : (id)sender
{
    if(_entry == 0){
        
    }
    else{
        _statusSelect = NO;
        _selectButton.selected = NO;
        [_selectButton setTitle:@"选择" forState:UIControlStateNormal];
        for(Video *video in _videos){
            if(video.selected){
                video.selected = NO;
                //保存视频到相册
                NSURL *url = [NSURL fileURLWithPath:video.filePath];
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                __weak typeof(self) weakSelf = self;
                /*[[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                   
                    PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                    [request addResourceWithType:PHAssetResourceTypePairedVideo fileURL:url options:nil];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        if(success){
                            [weakSelf.view makeToast:@"保存成功!"];
                            
                        }else{
                            [weakSelf.view makeToast:[NSString stringWithFormat:@"保存失败, %@", error]];
                        }
                    });
                    
                }];*/
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
                [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:video.filePath] completionBlock:^(NSURL *assetURL, NSError *error) {
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                        if(error){
                            [weakSelf.view makeToast:[NSString stringWithFormat:@"保存失败, %@", error]];
                            
                            
                        }else{
                            [weakSelf.view makeToast:@"保存成功!"];
                        }
                    });
                }];
            }
        }
        
        [self.collectionView reloadData];
    }
}


#pragma mark - add photos or videos
- (IBAction)addPhotos:(id)sender {

    if(_entry == 0){
        MSImagePickerController *picker = [[MSImagePickerController alloc]init];
        [picker setEditing:NO];
        [picker setAllowsEditing:NO];
        picker.msDelegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString*)kUTTypeImage];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setEditing:NO];
        [picker setAllowsEditing:NO];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeVideo];
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    
}


- (IBAction)selectPhotos:(id)sender {
    
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(_entry == 0){
        return _photos.count;
    }
    else{
        return _videos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(_entry == 0){
        PhotoCell *cell = [PhotoCell cellFromXib:collectionView indexPath:indexPath];
        NSString *imKey = _photos[indexPath.row];
        NSData *imData = [[NSUserDefaults standardUserDefaults]objectForKey:imKey];
        UIImage *im = [UIImage imageWithData:imData];
        [cell.photo setImage:im];
        cell.checkImageView.hidden = !_statusSelect;
        
        
        return cell;
    }
    else{
        
        VideoCell *cell = [VideoCell cellFromXib:collectionView indexPath:indexPath];
        Video *video = _videos[indexPath.row];
        cell.imageView.image = video.thum;
        cell.sizeLabel.text = video.size;
        
        cell.checkImageView.hidden = !_statusSelect;
        if(video.selected){
            [cell.checkImageView setImage:[UIImage imageNamed:@"check"]];
        }
        else{
            [cell.checkImageView setImage:[UIImage imageNamed:@"check-un"]];
        }

        return cell;
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = (width-5*3)/4.0;
    return CGSizeMake(w, w);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 10);
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
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
    
    if(_entry == 0){
        
//        NSString *imgKey = _photos[indexPath.row];
        [self performSegueWithIdentifier:@"check" sender:@(indexPath.row)];
        
    }
    else{
        
        //播放视频
        Video *video = _videos[indexPath.row];
        
        if(_statusSelect){
           
            video.selected = !video.selected;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
        else{
            NSURL *url = [NSURL fileURLWithPath:video.filePath];
            MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
            [self presentMoviePlayerViewControllerAnimated:vc];
    
        }
    }
    
}



#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}






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
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.collectionView reloadData];
        [[ConstantManager shareManager]savePhotos];
        [_indicator stopAnimating];
    }];
}


#pragma mark - imagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    /*  AHAsset 类型
    //选择的是图片
    info{
        UIImagePickerControllerMediaType = "public.image";
        UIImagePickerControllerOriginalImage = "<UIImage: 0x126cacc60> size {2048, 1365} orientation 0 scale 1.000000";
        UIImagePickerControllerReferenceURL = "assets-library://asset/asset.PNG?i/../B&ext=PNG";
    }
    
    //选择的是视频
    info{
        UIImagePickerControllerMediaType = "public.movie";
        UIImagePickerControllerMediaURL = "file:///private/../BD-E6D273D5B376.MOV";
        UIImagePickerControllerReferenceURL = "assets-library://asset/asset.MOV?id=546/../B&ext=MOV";
    }
    
    //选择的是 LivePhoto
    info{
        UIImagePickerControllerLivePhoto = "<PHLivePhoto: 0x126e3a170>";
        UIImagePickerControllerMediaType = "com.apple.live-photo";
        UIImagePickerControllerOriginalImage = "<UIImage: 0x126c56b10> size {960, 1280} orientation 0 scale 1.000000";
        UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id/../B3&ext=JPG";
    }*/
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSLog(@"视频...");
        NSURL *url = info[UIImagePickerControllerReferenceURL]; //真正的资源
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        PHAsset *asset = fetchResult.firstObject;
        //获取视频数据
        if(!_videos){
            _videos = [NSMutableArray new];
        }
        [self getVideoFromAHAsset:asset Complete:^(Video *video, NSString *filename) {
            [[ConstantManager shareManager].videos addObject:video];
//            [[ConstantManager shareManager] saveVideos];
            _videos = [ConstantManager shareManager].videos;
            [[ConstantManager shareManager] saveVideos];
        }];
        [self.collectionView reloadData];
        
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//从PHAsset获取视频
- (void)getVideoFromAHAsset:(PHAsset *)asset Complete:(Result)result
{
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    for(PHAssetResource *assetResource in assetResources){
        if(assetResource.type == PHAssetResourceTypeVideo ||
           assetResource.type == PHAssetResourceTypePairedVideo){
            resource = assetResource;
        }
    }
    
    NSString *filename = @"temvideo.mov";
    if(resource.originalFilename){
        filename = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 Video *video = [[Video alloc]init];
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 video.size = [NSString stringWithFormat:@"%.1fM", data.length/1024.0/1024.0];
                                                                 video.filePath = PATH_MOVIE_FILE;
                                                                 video.filename = filename;
                                                                 video.thum = [self getThumnailImage:PATH_MOVIE_FILE];
                                                                 result(video, filename);
                                                             }
                                                             //[[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}


#pragma mark - 获取视频缩略图
- (UIImage *)getThumnailImage : (NSString *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumImage = [[UIImage alloc]initWithCGImage:image];
    CGImageRelease(image);
    return thumImage;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//视频保存完的回调
- (void) video : (NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo : (void *)contextInfo
{
    
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
