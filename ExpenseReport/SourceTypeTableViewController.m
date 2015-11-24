//
//  SourceTypeTableViewController.m
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "SourceTypeTableViewController.h"

@interface SourceTypeTableViewController ()

@end

@implementation SourceTypeTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.expensesOrIncomeArray.count;
}

- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    NSNumber *amount = self.expensesOrIncomeArray[indexPath.row];
    
    NSString *amountText = [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%0.2f", [amount doubleValue]]];
    
    cell.textLabel.text = amountText;
    
    return cell;
}


@end
