//
//  PhotoVideoSelectController.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/9/13.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "PhotoVideoSelectController.h"
#import "PhotosViewController.h"

@implementation PhotoVideoSelectController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"photo"]){
        
        PhotosViewController *vc = segue.destinationViewController;
        vc.entry = 0;
        
    }
    else if([segue.identifier isEqualToString:@"video"]){
        PhotosViewController *vc = segue.destinationViewController;
        vc.entry = 1;
    }
}

@end