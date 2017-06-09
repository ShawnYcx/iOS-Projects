//
//  EditViewController.m
//  CounselingApp
//
//  Created by shawn yap on 10/24/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize contentEdit;
@synthesize content;
@synthesize toEdit;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentEdit.text = content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// This function updates the edited content to th plist
- (IBAction)saveChanges:(id)sender {
    // open patha and saves edited content onto local pList (temporary application design flow)
    NSMutableArray *tempSave;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Test.plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    tempSave = [dict objectForKey:@"Content"];
    tempSave[toEdit] = self.contentEdit.text;
    [dict setObject:tempSave forKey:@"Content"];
    
    [dict writeToFile:path atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
