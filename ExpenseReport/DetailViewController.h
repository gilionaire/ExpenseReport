//
//  DetailViewController.h
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/20/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseItem.h"
#import "IncomeItem.h"

@interface DetailViewController : UIViewController <UINavigationControllerDelegate>

//Add property for expense and income
@property (nonatomic)BOOL isNew;
@property (nonatomic)BOOL isIncome;

@property (nonatomic, retain)MonthReport *monthReport;

@property (nonatomic, retain)ExpenseItem *expenseItem;
@property (nonatomic, retain)IncomeItem *incomeItem;

//If have time apply the pop view like the student
@property (nonatomic, copy)void (^dismissBlock)(void);

@end
