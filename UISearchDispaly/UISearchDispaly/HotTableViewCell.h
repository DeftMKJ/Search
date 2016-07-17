//
//  HotTableViewCell.h
//  UISearchDispaly
//
//  Created by 宓珂璟 on 16/7/9.
//  Copyright © 2016年 UITableView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SKTagView.h>


@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataLists;


@property (nonatomic,assign) NSInteger whichSection;
@property (nonatomic,assign) CGFloat firstHeight;
@property (nonatomic,assign) CGFloat secondHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colletionViewHeight;

@property (weak, nonatomic) IBOutlet SKTagView *tagListView;


@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;


@end
