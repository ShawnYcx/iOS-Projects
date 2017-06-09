//
//  Bold+Text.m
//  CounselingApp
//
//  Created by shawn yap on 11/21/16.
//  Copyright © 2016 ACU. All rights reserved.
//
//  Class method to prevent code duplication

#import "Bold+Text.h"

@implementation Bold_Text

+(NSAttributedString *)boldString:(NSString *)string {
    UIFont *boldFont = [UIFont boldSystemFontOfSize:24];
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString:string];
    
    // Regular expression searches for "<b>" and "</b>" and bolds the text accordingly
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".*?<b>(.*?)<\\/b>.*?" options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSArray *myArray = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)] ;
    for (NSTextCheckingResult *match in myArray) {
        NSRange matchRange = [match rangeAtIndex:1];
        [attributedDescription addAttribute:NSFontAttributeName value:boldFont range:matchRange];
    }
    while ([attributedDescription.string containsString:@"<b>"] || [attributedDescription.string containsString:@"</b>"]) {
        NSRange rangeOfTag = [attributedDescription.string rangeOfString:@"<b>"];
        [attributedDescription replaceCharactersInRange:rangeOfTag withString:@""];
        rangeOfTag = [attributedDescription.string rangeOfString:@"</b>"];
        [attributedDescription replaceCharactersInRange:rangeOfTag withString:@""];
    }
    return attributedDescription;
}


@end
