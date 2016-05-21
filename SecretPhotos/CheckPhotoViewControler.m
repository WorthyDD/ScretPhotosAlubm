//
//  CheckPhotoViewControler.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "CheckPhotoViewControler.h"

@interface CheckPhotoViewControler ()

@end

@implementation CheckPhotoViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_iv setImage:[UIImage imageWithData:_imData]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)delete:(id)sender {
    
    [_photoVC.photos removeObject:_imData];
    [self.photoVC.collectionView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:_imData], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                          
                                                    message:msg
                        
                                                   delegate:self
                
                                          cancelButtonTitle:@"确定"
                          
                                          otherButtonTitles:nil];
        [alert show];
    }

}

@end
