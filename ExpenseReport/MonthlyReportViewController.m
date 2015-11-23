//
//  MonthlyReportViewController.m
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MonthlyReportViewController.h"
#import "SourceTypeTableViewController.h"

@interface MonthlyReportViewController ()

@end

@implementation MonthlyReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //TO-DO set title from the monthly report object for now created an array
    self.navigationItem.title = self.tempMonths[self.tempMonthNum];
    
    SourceTypeTableViewController *incomeSourceTVC = [[SourceTypeTableViewController alloc]initWithStyle:UITableViewStylePlain];
    SourceTypeTableViewController *expenceTypeTVC = [[SourceTypeTableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    self.incomeTableView = incomeSourceTVC.tableView;
    self.expenseTableView = expenceTypeTVC.tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
