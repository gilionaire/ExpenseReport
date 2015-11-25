//
//  SourceTypeTableViewController.h
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthReport.h"

@interface SourceTypeTableViewController : UITableViewController <UINavigationControllerDelegate>

//TO-DO add the property for the array of the expenses or sources

@property (nonatomic, retain) NSMutableArray *expensesOrIncomeArray;
@property (nonatomic, copy) NSString* sourceOrTypeTitle;
@property (nonatomic, retain)MonthReport *monthReport;

@property (nonatomic)BOOL isIncome;

@end
