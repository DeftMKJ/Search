//
//  ViewController.m
//  UISearchDispaly
//
//  Created by 宓珂璟 on 16/7/9.
//  Copyright © 2016年 UITableView. All rights reserved.
//

#import "ViewController.h"
#import "MKJDisplaySearchViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(id)sender
{
    MKJDisplaySearchViewController *mkjDisplay = [[MKJDisplaySearchViewController alloc] init];
    [self.navigationController pushViewController:mkjDisplay animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
