//
//  ViewController.m
//  SecretPhotos
//
//  Created by 武淅 段 on 16/5/21.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
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


@end
