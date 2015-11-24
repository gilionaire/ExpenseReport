//
//  MonthReport+CoreDataProperties.h
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MonthReport.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonthReport (CoreDataProperties)

@property (nonatomic) double balance;
@property (nonatomic) int16_t month;
@property (nonatomic) int16_t year;
@property (nullable, nonatomic, retain) NSSet<ExpenseItem *> *expenses;
@property (nullable, nonatomic, retain) NSSet<IncomeItem *> *incomes;

@end

@interface MonthReport (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(ExpenseItem *)value;
- (void)removeExpensesObject:(ExpenseItem *)value;
- (void)addExpenses:(NSSet<ExpenseItem *> *)values;
- (void)removeExpenses:(NSSet<ExpenseItem *> *)values;

- (void)addIncomesObject:(IncomeItem *)value;
- (void)removeIncomesObject:(IncomeItem *)value;
- (void)addIncomes:(NSSet<IncomeItem *> *)values;
- (void)removeIncomes:(NSSet<IncomeItem *> *)values;

@end

NS_ASSUME_NONNULL_END
