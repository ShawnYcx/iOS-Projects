//
//  DepressionViewController.m
//  CounselingApp
//
//  Created by shawn yap on 10/20/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "DepressionViewController.h"
#import "SWRevealViewController.h"
#import "EditViewController.h"
#import "AppDelegate.h"
#import "Bold+Text.h"
#import "Authentication.h"

@interface DepressionViewController (){
    NSMutableDictionary *_dict;
    AppDelegate *_delegate;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@end

@implementation DepressionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Temporary hide edit button
    if (![Authentication checkLogin]){
        [self.editBtn setEnabled:NO];
        [self.editBtn setTintColor:[UIColor clearColor]];
    }
    
    _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = NSLocalizedString(@"Depression", nil);
    
    // initialize tap and slide gestures for SWRevealViewController
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    // Set bar buttons
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    // Initialize contents for depression from plist
    NSString *path = [_delegate openPath];
    _dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    self.pageTitle.text = [_dict objectForKey:@"Title"][1];
    self.thumbImg.image = [UIImage imageNamed:[_dict objectForKey:@"Thumbnail"][1]];
    self.thumbImg.layer.cornerRadius = 8.0;
    self.thumbImg.layer.masksToBounds = YES;
    
    NSAttributedString *x = [Bold_Text boldString:[_dict objectForKey:@"Content"][1]];
    // update scrollview height according to updated content height
    self.contentLabel.attributedText = x;
    CGRect newFrame = self.contentLabel.frame;
    CGRect updateFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + newFrame.size.height - 284.5); // 284.5 is the original height of the label
    
    self.contentView.frame = updateFrame;
    self.ScrollView.frame = updateFrame;
    self.ScrollView.contentSize = CGSizeMake(updateFrame.size.width, updateFrame.size.height);
    [self.view setNeedsLayout];
}

-(void)viewDidAppear:(BOOL)animated{
    // enable and disable button depending on admin login
    if ([Authentication checkLogin]){
        [self.editBtn setEnabled:YES];
        [self.editBtn setTintColor:[UIColor whiteColor]];
    }else{
        [self.editBtn setEnabled:NO];
        [self.editBtn setTintColor:[UIColor clearColor]];
    }
    // Bold headers and other areas after edit
    NSAttributedString *x = [Bold_Text boldString:[_dict objectForKey:@"Content"][1]];
    self.contentLabel.attributedText = x;
    CGRect newFrame = self.contentLabel.frame;
    CGRect updateFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + newFrame.size.height - 284.5); // 284.5 is the original height of the label
    
    self.contentView.frame = updateFrame;
    self.ScrollView.frame = updateFrame;
    self.ScrollView.contentSize = CGSizeMake(updateFrame.size.width, updateFrame.size.height);

    [self.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Sending data to viewcontrollers for data preload
     EditViewController *destViewController = segue.destinationViewController;
     destViewController.content = self.contentLabel.text;
     destViewController.toEdit = 1;
 }

@end