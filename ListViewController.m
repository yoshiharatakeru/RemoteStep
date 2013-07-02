//
//  ListViewController.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/02.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//



#import "ListViewController.h"

@interface ListViewController (){
    
    __weak IBOutlet UITableView *_tableView;
    
}

@end

@implementation ListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tableview
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    }
    
    if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}


#pragma mark -
#pragma mark button action

- (IBAction)cancelBtPressed:(id)sender {
    
    [_delegate ListViewControllerDidCancelEditing:self];
}


- (IBAction)addBtPressed:(id)sender {
}


@end
