//
//  ResourcesViewController.h
//  CounselingApp
//
//  Created by shawn yap on 10/20/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourcesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UITextView *contentBox;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
