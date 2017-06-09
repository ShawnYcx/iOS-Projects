//
//  AlertDialog.h
//  CounselingApp
//
//  Created by shawn yap on 11/22/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertDialog : NSObject

+(void)showMessage:(NSString*)message withTitle:(NSString *)title;

@end
