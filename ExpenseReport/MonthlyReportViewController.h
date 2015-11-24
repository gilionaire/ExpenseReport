//
//  MonthlyReportViewController.h
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthlyReportViewController : UIViewController <UITableViewDelegate>

//TO-DO create property of monthly report object for now created an array and int
@property (nonatomic)int tempMonthNum;
@property (nonatomic, copy)NSArray *tempMonths;

@property (weak, nonatomic) IBOutlet UILabel *totalMonthltyBalanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addNewIncomeButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewExpenseButton;

@property (weak, nonatomic) IBOutlet UITableView *incomeTableView;
@property (weak, nonatomic) IBOutlet UITableView *expenseTableView;

@end
