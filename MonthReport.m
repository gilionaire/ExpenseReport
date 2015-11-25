//
//  MonthReport.m
//  ExpenseReport
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MonthReport.h"
#import "IncomeItem.h"
#import "ExpenseItem.h"

@implementation MonthReport

-(double)monthTotalIncomesAndExpensesBalance {
    
    double total = 0;
    
    total += [self monthTotalIncomesBalance];
    total += [self monthTotalExpensesBalance];
    
    return total;
}

-(double)monthTotalIncomesBalance {
    double total = 0;
    
    //Get the array of all income sources
    NSArray* incomeSourcesSet = [self.incomes allValues];
    
    //Traverse trough each set of income sources
    for(NSArray* incomesSet in incomeSourcesSet){
        
        //Get the income for the income source array
        for(IncomeItem *income in incomesSet){
            total+= income.amount;
        }
    }
    
    return total;
}

-(double)monthTotalExpensesBalance {
    
    double total = 0;
    
    //Get the array of all expense types
    NSArray* expensesTypeSet = [self.expenses allValues];
    
    //Traverse trough each set of expense type
    for(NSArray* expensesSet in expensesTypeSet) {
        
        //Get each expense for the type
        for(ExpenseItem *expense in expensesSet) {
            total += expense.amount;
        }
    }
    
    return total;
}

@end
