//
//  ExpensesCollection.h
//  ExpenseReport
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExpenseItem;

@interface ExpensesCollection : NSObject

@property (nonatomic) NSMutableArray *allExpenses;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

+ (instancetype) sharedCollection;
- (ExpenseItem *)createExpense;
- (void) removeExpense:(ExpenseItem *)expense;
- (BOOL) saveChanges;

@end
