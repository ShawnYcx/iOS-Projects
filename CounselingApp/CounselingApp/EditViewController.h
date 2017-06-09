//
//  EditViewController.h
//  CounselingApp
//
//  Created by shawn yap on 10/24/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *contentEdit;
@property (nonatomic, strong) NSString *content;
@property int toEdit;

@end
