//
//  ContactUsController.h
//  CounselingApp
//
//  Created by shawn yap on 10/4/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactUsController : UIViewController<MFMailComposeViewControllerDelegate>
    {
        MFMailComposeViewController *mailComposer;
    }
    
- (IBAction)Send:(id)sender;

@end
