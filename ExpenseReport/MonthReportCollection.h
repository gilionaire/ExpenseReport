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
- (BOOL) saveChanges;

@end
