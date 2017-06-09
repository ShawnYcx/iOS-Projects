//
//  AdminCell.m
//  CounselingApp
//
//  Created by shawn yap on 11/20/16.
//  Copyright © 2016 ACU. All rights reserved.
//

#import "AdminCell.h"

@implementation AdminCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Label.text = @"Admin";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
