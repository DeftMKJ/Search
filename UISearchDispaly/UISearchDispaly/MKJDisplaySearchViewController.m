//
//  MKJDisplaySearchViewController.m
//  UISearchDispaly
//
//  Created by 宓珂璟 on 16/7/9.
//  Copyright © 2016年 UITableView. All rights reserved.
//

#import "MKJDisplaySearchViewController.h"

#import "HotTableViewCell.h"
#import <SKTagView.h>
#import <UIImageView+WebCache.h>
#import <UITableView+FDTemplateLayoutCell.h>


@interface MKJDisplaySearchViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 搜索界面上面展示热门搜索，下面展示历史搜索
@property (nonatomic,strong) NSMutableArray *hotDataSource;
@property (nonatomic,strong) NSMutableArray *historyDateSource;
// 搜索结果界面上面相关标签，下面展示相关文章
@property (nonatomic,strong) NSMutableArray *resultTagDataSource;
@property (nonatomic,strong) NSMutableArray *resultArticleDataSource;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UISearchDisplayController *displayController;



@end
static NSString *identify1 = @"HotTableViewCell";
static NSString *identify2 = @"TagsTableViewCell";
static NSString *identify3 = @"ArticleTableViewCell";
static NSString *identify4 = @"HeaderTableViewCell";

@implementation MKJDisplaySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:identify1 bundle:nil] forCellReuseIdentifier:identify1];
    [self.tableView registerNib:[UINib nibWithNibName:identify4 bundle:nil] forCellReuseIdentifier:identify4];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 375, 44)];
    [self.searchBar setPlaceholder:@"搜索"];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    self.searchBar.backgroundImage = [UIImage new];
    UITextField *searchBarTextField = [self.searchBar valueForKey:@"_searchField"];
    if (searchBarTextField)
    {
        [searchBarTextField setBackgroundColor:[UIColor whiteColor]];
        [searchBarTextField setBorderStyle:UITextBorderStyleRoundedRect];
        searchBarTextField.layer.cornerRadius = 5.0f;
        searchBarTextField.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        searchBarTextField.layer.borderWidth = 0.5f;
    }
    
    self.tableView.tableHeaderView = self.searchBar;


    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
//    [searchDisplayController setActive:YES animated:YES];
    self.displayController = searchDisplayController;
//    [self.displayController.searchResultsTableView registerNib:[UINib nibWithNibName:identify2 bundle:nil] forCellReuseIdentifier:identify2];
//    [self.displayController.searchResultsTableView registerNib:[UINib nibWithNibName:identify3 bundle:nil] forCellReuseIdentifier:identify3];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        return 2;
    }
    else if (tableView == self.displayController.searchResultsTableView)
    {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return 1;
    }
    else if (tableView == self.displayController.searchResultsTableView)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return self.resultArticleDataSource.count;
        }
            
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1 forIndexPath:indexPath];
        [self configCell:cell indexpath:indexPath tableView:tableView];
        return cell;
        
    }
    else
    {
        NSString *identyfy = nil;
        if (indexPath.section == 0) {
            identyfy = identify2;
        }
        else
        {
            identyfy = identify3;
        }
        HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identyfy forIndexPath:indexPath];
        [self configCell:cell indexpath:indexPath tableView:tableView];
        
        return cell;
    }

}

- (void)configCell:(HotTableViewCell *)cell indexpath:(NSIndexPath *)indexpath tableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        if (indexpath.section == 0) {
            cell.dataLists = self.hotDataSource;
            cell.whichSection = 0;
        }else
        {
            cell.dataLists = self.historyDateSource;
            cell.whichSection = 1;
        }
        [cell.collectionView reloadData];
//        CGRect rec =  cell.collectionView.frame;
//        rec.size.width = [UIScreen mainScreen].bounds.size.width;
//        cell.collectionView.frame = rec;
        CGSize size = cell.collectionView.collectionViewLayout.collectionViewContentSize;
        cell.colletionViewHeight.constant = size.height;
    }
    else
    {
        // 第0段的时候是加载SKTagview
        if (indexpath.section == 0)
        {
            __weak typeof(self)weakSelf = self;
            [cell.tagListView removeAllTags];
            cell.tagListView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
            cell.tagListView.padding = UIEdgeInsetsMake(15, 10, 2, 10);
            cell.tagListView.interitemSpacing = 20;
            cell.tagListView.lineSpacing = 10;
            [self.resultTagDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
             {
                 SKTag *tag = [SKTag tagWithText:[NSString stringWithFormat:@"#%@",weakSelf.resultTagDataSource[idx]]];
                 //         tag.padding = UIEdgeInsetsMake(3, 5, 3, 5);
                 tag.font = [UIFont systemFontOfSize:13.0];
                 //         tag.borderWidth = 0.5f;
                 tag.bgColor = [UIColor whiteColor];
                 tag.cornerRadius = 3;
                 //         tag.borderColor = RGBA(191, 191, 191, 1);
                 tag.textColor = [UIColor redColor];
                 tag.padding = UIEdgeInsetsMake(10, 5, 10, 5);
                 tag.enable = YES;
                 [cell.tagListView addTag:tag];
             }];
            
            cell.tagListView.didTapTagAtIndex = ^(NSUInteger index)
            {
                
            };
        }
        else // 第1段就加载美女图片
        {
            [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:self.resultArticleDataSource[indexpath.row]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image && cacheType == SDImageCacheTypeNone) {
                    cell.articleImage.alpha = 0;
                    [UIView animateWithDuration:1.0 animations:^{
                        cell.articleImage.alpha = 1.0f;
                    }];
                }
                else
                {
                    cell.articleImage.alpha = 1.0f;
                }
                
            }];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
    if (tableView == self.tableView)
    {
        if (section == 1) {
            cell.headerLabel.text = @"历史搜索";
            cell.headerLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    else
    {
        if (section == 0) {
            cell.headerLabel.text = @"相关标签";
        }
        else
        {
            cell.headerLabel.text = @"热门美女";
        }
        cell.headerLabel.textAlignment = NSTextAlignmentLeft;
    }
    return cell.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        if (section == 1) {
            return 40;
        }
        else
        
        {
            return 0;
        }
    }
    else
    {
        if (section == 0) {
            return 40;
        }
        else
        {
            return 40;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return [tableView fd_heightForCellWithIdentifier:identify1 cacheByIndexPath:indexPath configuration:^(id cell) {
           
            [self configCell:cell indexpath:indexPath tableView:tableView];
            
        }];


    }
    else
    {
        if (indexPath.section == 0) {
            return [tableView fd_heightForCellWithIdentifier:identify2 cacheByIndexPath:indexPath configuration:^(id cell) {
                
                [self configCell:cell indexpath:indexPath tableView:tableView];
                
            }];
        }
        else
        {
            return 200;
        }
    }
}


- (NSMutableArray *)hotDataSource
{
    if (_hotDataSource == nil) {
        _hotDataSource = [[NSMutableArray alloc] initWithArray:@[@"旅游", @"摄影", @"家居", @"情趣", @"玩具", @"豪车", @"美女", @"夏天", @"游戏", @"外卖", @"服务",@"丽人"]];
    }
    return _hotDataSource;
    
}

- (NSMutableArray *)historyDateSource
{
    if (_historyDateSource == nil) {
        _historyDateSource = [[NSMutableArray alloc] initWithArray:@[@"BigBang",@"林林俊杰",@"TANK",@"化成雨",@"周杰伦",@"Bigbang",@"老母鸡",@"徐佳莹",@"巫启贤",@"黄渤",@"孙红雷"]];
    }
    return _historyDateSource;
}

- (NSMutableArray *)resultTagDataSource
{
    if (_resultTagDataSource == nil) {
        _resultTagDataSource = [[NSMutableArray alloc] init];
    }
    return _resultTagDataSource;
}

- (NSMutableArray *)resultArticleDataSource
{
    if (_resultArticleDataSource == nil) {
        _resultArticleDataSource = [[NSMutableArray alloc] init];
    }
    return _resultArticleDataSource;
}

//===============================================
#pragma mark -
#pragma mark UISearchDisplayDelegate
//===============================================

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | will begin search");
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | did begin search");
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | will end search");
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | did end search");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did load table");
    [tableView registerNib:[UINib nibWithNibName:identify2 bundle:nil] forCellReuseIdentifier:identify2];
    [tableView registerNib:[UINib nibWithNibName:identify3 bundle:nil] forCellReuseIdentifier:identify3];
    [tableView registerNib:[UINib nibWithNibName:identify4 bundle:nil] forCellReuseIdentifier:identify4];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will unload table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will show table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did show table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will hide table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did hide table");
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"🔦 | should reload table for search string?");
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchString];
//    self.searchResultDataSource = [[NSMutableArray alloc] initWithArray:[self.dataSource filteredArrayUsingPredicate:predicate]];;
//    self.resultVC.resultDataSource = self.searchResultDataSource;
//    [self.resultVC.tableView reloadData];
    self.resultTagDataSource = [[NSMutableArray alloc] initWithArray:@[@"忠犬八公的故事",@"肖申克的救赎",@"致命魔术",@"致命ID",@"搏击俱乐部",@"绝命毒师",@"恐怖游轮",@"一只鸡",@"三只鸡",@"X男人",@"异次元骇客的呵呵呵呵呵呵呵呵"]];
    self.resultArticleDataSource = [[NSMutableArray alloc] initWithArray:@[@"http://g1.ykimg.com/0130391F4555E1ADCCAB0C2BC11A026B822DCD-20CB-492B-E573-2C134BEAACD6",
                                                                          @"http://photo.880sy.com/4/2615/97666_small.jpg",
                                                                          @"http://android.tgbus.com/xiaomi/UploadFiles_8974/201204/20120419104740904.jpg",
                                                                          @"http://file.ynet.com/2/1507/26/10257216.jpg",
                                                                          @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJrreS_lZ4ha_qf4wuCBjvqqcNe_9mfGDvSpL6yW-s7Hw2acuwdA",
                                                                          @"http://images.china.cn/attachement/jpg/site1000/20160114/c03fd55670b218013ce02e.jpg",
                                                                          @"http://g2.ykimg.com/0130391F455393CD019187003FF99B6B5AD97A-861D-4127-04FC-F206FA63EF4D",
                                                                          @"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTWyinrltRMmvUI_o0cu3oaQO0mbGoRLR9qXqttq4kOO-Aox44MAg",
                                                                          @"http://i0.sinaimg.cn/edu/2015/0417/U1151P42DT20150417152321.jpg",
                                                                          @"http://news.xinhuanet.com/world/2010-02/26/124271_11n.jpg",
                                                                           @"https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSCXeL1x-x7y5Pk7qj4DlB_MGMHbY8DUuIgWR8mCLQIwRvCOyaO"]];
    
    
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSLog(@"🔦 | should reload table for search scope?");
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
