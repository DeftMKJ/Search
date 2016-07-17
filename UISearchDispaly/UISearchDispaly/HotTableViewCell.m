//
//  HotTableViewCell.m
//  UISearchDispaly
//
//  Created by 宓珂璟 on 16/7/9.
//  Copyright © 2016年 UITableView. All rights reserved.
//

#import "HotTableViewCell.h"
#import "HotCollectionViewCell.h"

@interface HotTableViewCell () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end
static NSString *identify1 = @"HotCollectionViewCell";
static NSString *identify2 = @"HistoryCollectionViewCell";

@implementation HotTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:identify1 bundle:nil] forCellWithReuseIdentifier:identify1];
    [self.collectionView registerNib:[UINib nibWithNibName:identify2 bundle:nil] forCellWithReuseIdentifier:identify2];


}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataLists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identyfy = nil;
    if (self.whichSection == 0) {
        identyfy = identify1;
    }
    else
    {
        identyfy = identify2;
    }
    HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identyfy forIndexPath:indexPath];
    [self configCollectionCell:cell indxpath:indexPath];
    return cell;
    
}

- (void)configCollectionCell:(HotCollectionViewCell *)cell indxpath:(NSIndexPath *)indexpath
{
    if (self.whichSection == 0)
    {
        cell.hotLabel.text = self.dataLists[indexpath.item];
    }
    else
    {
        cell.historyLabel.text = self.dataLists[indexpath.item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.whichSection == 0)
    {
        
        return CGSizeMake(width / 5, 50);
    }
    else
    {
        return CGSizeMake(width - 100, 50);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.whichSection == 0)
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else
    {
        return UIEdgeInsetsMake(10, 50, 20, 50);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
