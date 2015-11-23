//
//  MonthReport.m
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MonthReport.h"
#import "ExpenseItem.h"
#import "IncomeItem.h"

@implementation MonthReport

// Insert code here to add functionality to your managed object subclass

- (void)awakeFromInsert{
    [super awakeFromInsert];
    NSTimeInterval t = [[NSDate date] timeIntervalSinceReferenceDate];
}

@end
