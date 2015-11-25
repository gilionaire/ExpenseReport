//
//  IncomeCollection.h
//  ExpenseReport
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IncomeItem;

@interface IncomeCollection : NSObject

@property (nonatomic) NSMutableArray *allIncomes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

+ (instancetype) sharedCollection;
- (IncomeItem *)createIncome;
- (void) removeIncome:(IncomeItem *)income;
- (BOOL) saveChanges;

-(double)currentIncomesBalance;

@end
