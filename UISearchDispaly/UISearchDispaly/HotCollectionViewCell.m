//
//  HotCollectionViewCell.m
//  UISearchDispaly
//
//  Created by 宓珂璟 on 16/7/10.
//  Copyright © 2016年 UITableView. All rights reserved.
//

#import "HotCollectionViewCell.h"

@implementation HotCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.hotLabel.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    self.hotLabel.layer.borderWidth = 0.5f;
}

@end
