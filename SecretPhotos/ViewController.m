//
//  ViewController.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "CusTomActionSheetView.h"
#import <QuartzCore/CAAnimation.h>

#define bg_image_key @"backgroungImageKey"
#define button_name_key @"buttonNameKey"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     //Do any additional setup after loading the view, typically from a nib.
    _bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBGImage:)];
    [_bgImage addGestureRecognizer:tap];
    NSData *imData = [[NSUserDefaults standardUserDefaults]objectForKey:bg_image_key];
    if(imData){
        UIImage *im = [UIImage imageWithData:imData];
        [_bgImage setImage:im];
    }
    
    NSString *btnTitle = [[NSUserDefaults standardUserDefaults] objectForKey:button_name_key];
    if(btnTitle){
        [_openButton setTitle:btnTitle forState:UIControlStateNormal];
    }
//    CATransition *myTransition=[CATransition animation];//创建CATransition
//    myTransition.duration=0.3;//持续时长0.3秒
//    myTransition.timingFunction=UIViewAnimationCurveEaseInOut;//计时函数，从头到尾的流畅度
//    myTransition.type=@"reveal";//动画类型
//    myTransition.subtype=kCATransitionFromLeft;//子类型
//    [self.navigationController.view.layer addAnimation:myTransition forKey:nil];
}

- (void) didTapBGImage : (UITapGestureRecognizer *)tap
{
    CusTomActionSheetView *sheet = [[CusTomActionSheetView alloc]initWithTitle:NSLocalizedString(@"changeBG", nil) andItemTitles:@[NSLocalizedString(@"chooseAlbum", nil), NSLocalizedString(@"defaultBG", nil)] cancleTitle:NSLocalizedString(@"cancle", nil)];
    sheet.handler = ^(NSInteger index){
        if(index == 0){
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = NO;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else if(index == 1){
            [_bgImage setImage:[UIImage imageNamed:@"start"]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:bg_image_key];
        }
    };
    [sheet show];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *im = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [_bgImage setImage:im];
        NSData *data = UIImageJPEGRepresentation(im, 1.0);
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:bg_image_key];
    }];
}

- (IBAction)open:(id)sender {
    
    [self evaluatePolicy];
    
}

- (void)evaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    __block  NSString *msg;
    __weak typeof(self) WeakSelf = self;
    // show the authentication UI with our reason string
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"请将您的手指移至home键", nil) reply:
     ^(BOOL success, NSError *authenticationError) {
         if (success) {
             msg =[NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_SUCCESS", nil)];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [WeakSelf performSegueWithIdentifier:@"photos" sender:nil];
             });
//
             
         } else {
             msg = [NSString stringWithFormat:NSLocalizedString(@"EVALUATE_POLICY_WITH_ERROR", nil), authenticationError.localizedDescription];
         }
         NSLog(@"\n\nresult : %@\n\n", msg);

     }];
    
}

- (IBAction)disTapSetting:(id)sender {
    CusTomActionSheetView *sheet = [[CusTomActionSheetView alloc]initWithTitle:NSLocalizedString(@"setting", nil) andItemTitles:@[NSLocalizedString(@"settingButtonName", nil)] cancleTitle:NSLocalizedString(@"cancle", nil)];
    sheet.handler = ^(NSInteger index){
        if(index == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip", nil) message:NSLocalizedString(@"inputTip", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
               
                textField.placeholder = NSLocalizedString(@"inputTip", nil);
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                UITextField *filed = alert.textFields.firstObject;
                NSString *titleStr = filed.text;
                [_openButton setTitle:titleStr forState:UIControlStateNormal];
                [[NSUserDefaults standardUserDefaults] setObject:titleStr forKey:button_name_key];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    };
    [sheet show];
}

@end
