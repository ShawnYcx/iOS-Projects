//
//  AlertDialog.m
//  CounselingApp
//
//  Created by shawn yap on 11/22/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "AlertDialog.h"


@implementation AlertDialog

+(void)showMessage:(NSString*)message withTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:^{
        }];
    });
}

@end
