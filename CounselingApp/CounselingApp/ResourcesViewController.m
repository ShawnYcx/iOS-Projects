//
//  ResourcesViewController.m
//  CounselingApp
//
//  Created by shawn yap on 10/20/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "ResourcesViewController.h"
#import "SWRevealViewController.h"
#import "EditViewController.h"
#import "AppDelegate.h"

NSInteger number;

@interface ResourcesViewController (){
    AppDelegate *_delegate;
    NSMutableDictionary *_dict;
}
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@end

@implementation ResourcesViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = NSLocalizedString(@"Resource", nil);
    
    // Left Slideout Menu Init
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Open path from AppDelegate
    NSString *path = [_delegate openPath];
    _dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    self.pageTitle.text = [_dict objectForKey:@"Title"][2];
    self.thumbImg.image = [UIImage imageNamed:[_dict objectForKey:@"Thumbnail"][2]];
    self.thumbImg.layer.cornerRadius = 8.0;
    self.thumbImg.layer.masksToBounds = YES;
    
    // load contents
    self.contentBox.text = [_dict objectForKey:@"Content"][2];
    self.contentBox.editable = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
    // Load the file content and read the data into arrays
    self.contentBox.text = [_dict objectForKey:@"Content"][2];
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
    [self.contentBox setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Sending data to viewcontrollers for data preload
    EditViewController *destViewController = segue.destinationViewController;
    destViewController.content = self.contentLabel.text;
    destViewController.toEdit = 2;
}


@end
