//
//  MonthReportCollection.h
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExpenseItem.h"
#import "IncomeItem.h"



@class MonthReport;

@interface MonthReportCollection : NSObject

@property (nonatomic) NSMutableDictionary *allMonths;

+ (instancetype) sharedCollection;

- (MonthReport *) createMonthReportWithYear:(NSNumber *)year
                             AndMonthNumber:(NSNumber *)month;

//-(ExpenseItem *) createExpenseItemWithType:(NSString *)expenseType
//                                      Date:(NSDate *)date
//                                 AndAmount:(double)amount;
//
//-(IncomeItem *) createIncomeItemWithSource:(NSString *)incomeSource
//                                      Date:(NSDate *)date
//                                 AndAmount:(double)amount;

- (void) removeMonth:(MonthReport *)month;
- (BOOL) saveChanges;

@end
