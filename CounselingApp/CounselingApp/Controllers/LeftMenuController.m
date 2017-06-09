//
//  LeftMenuController.m
//  CounselingApp
//
//  Created by shawn yap on 10/6/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "SWRevealViewController.h"
#import "LeftMenuController.h"

@interface LeftMenuController ()

@end

@implementation LeftMenuController{
    NSArray *_menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // An array of viewcontroller identifier
    _menuItems = @[@"home", @"anxiety", @"depression", @"resources", @"settings"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    if ([[_menuItems objectAtIndex:indexPath.row] isEqualToString:@"settings"]){
            
    }
}
@end
