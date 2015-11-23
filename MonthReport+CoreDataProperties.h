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

@property (nonatomic) int16_t year;
@property (nonatomic) int16_t month;
@property (nonatomic) double balance;
@property (nullable, nonatomic, retain) NSOrderedSet<ExpenseItem *> *expenses;
@property (nullable, nonatomic, retain) NSOrderedSet<IncomeItem *> *incomes;

@end

@interface MonthReport (CoreDataGeneratedAccessors)

- (void)insertObject:(ExpenseItem *)value inExpensesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromExpensesAtIndex:(NSUInteger)idx;
- (void)insertExpenses:(NSArray<ExpenseItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeExpensesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInExpensesAtIndex:(NSUInteger)idx withObject:(ExpenseItem *)value;
- (void)replaceExpensesAtIndexes:(NSIndexSet *)indexes withExpenses:(NSArray<ExpenseItem *> *)values;
- (void)addExpensesObject:(ExpenseItem *)value;
- (void)removeExpensesObject:(ExpenseItem *)value;
- (void)addExpenses:(NSOrderedSet<ExpenseItem *> *)values;
- (void)removeExpenses:(NSOrderedSet<ExpenseItem *> *)values;

- (void)insertObject:(IncomeItem *)value inIncomesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromIncomesAtIndex:(NSUInteger)idx;
- (void)insertIncomes:(NSArray<IncomeItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeIncomesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInIncomesAtIndex:(NSUInteger)idx withObject:(IncomeItem *)value;
- (void)replaceIncomesAtIndexes:(NSIndexSet *)indexes withIncomes:(NSArray<IncomeItem *> *)values;
- (void)addIncomesObject:(IncomeItem *)value;
- (void)removeIncomesObject:(IncomeItem *)value;
- (void)addIncomes:(NSOrderedSet<IncomeItem *> *)values;
- (void)removeIncomes:(NSOrderedSet<IncomeItem *> *)values;

@end

NS_ASSUME_NONNULL_END
