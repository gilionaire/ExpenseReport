//
//  MonthReport.h
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@import CoreData;

@class ExpenseItem, IncomeItem;

NS_ASSUME_NONNULL_BEGIN

@interface MonthReport : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

+ (instancetype) sharedCollection;

- (ExpenseItem *) createExpense;
- (IncomeItem *) createIncome;

- (void) removeExpenseItem:(ExpenseItem *)expense;
- (BOOL) saveChanges;

@end

NS_ASSUME_NONNULL_END

#import "MonthReport+CoreDataProperties.h"
