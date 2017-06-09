//
//  Authentication.m
//  CounselingApp
//
//  Created by shawn yap on 11/15/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "Authentication.h"

@implementation Authentication
/*
    This function checks if the user has logged in before
    if YES then admin functionalities are enabled at application start
    if No then prompts for credentials
*/

+(void)signUp {
    // This method is currently used to initialize admin id and pass
    // This can be modified with encryption for user pass in the future
    [[NSUserDefaults standardUserDefaults] setValue:@"admin" forKey:@"Username"];
    [[NSUserDefaults standardUserDefaults] setValue:@"password" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
    This function authenticates user for admin log in
*/
+(BOOL)checkPasswordwithID:(NSString*)user pass:(NSString*)Password{
    NSString * u_id = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    NSString * u_pass = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    if ((u_id == user) && (u_pass == Password)){
        // Set value to 1 because user logged in
        return YES;
    }
    else
        return NO;
    
}

#pragma mark - Login Tokens

// This function updates the value of the admin token so that the application knows whether the admin is logged in or not
+(void)updateToken:(NSString*)value {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"token"];
}

// This function checks the state of the user
// If the user signs is not logged in then 0 else 1
+(BOOL)checkLogin{
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    if ([token isEqualToString:@"0"])
        return NO;
    return YES;
}

@end
