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

@import CoreData;

@interface MonthReport()

//// Insert code here to declare functionality of your managed object subclass
//@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation MonthReport

// Insert code here to add functionality to your managed object subclass

- (NSString *) itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    return [documentDirectory stringByAppendingPathComponent:@"month.data"];

}

- (BOOL) saveChanges{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (id) init{
    self = [super init];
    if(self){
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // Create the managed object context
        self.context = [[NSManagedObjectContext alloc] init];
        self.context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (ExpenseItem *) createExpense{
    NSLog(@"Adding after %lu expenses", [self.expenses count]);
    ExpenseItem *expense = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItem" inManagedObjectContext:self.context];
    [self addExpensesObject:expense];
    return expense;
}

- (void) removeExpense:(ExpenseItem *)expense{
    [self.context deleteObject:expense];
    [self removeExpensesObject:expense];
}

- (IncomeItem *) createIncome{
    NSLog(@"Adding after %lu income items", [self.incomes count]);
    IncomeItem *income = [NSEntityDescription insertNewObjectForEntityForName:@"IncomeItem" inManagedObjectContext:self.context];
    [self addIncomesObject:income];
    return income;
}

- (void) removeIncome:(IncomeItem *)income{
    [self.context deleteObject:income];
    [self removeIncomesObject:income];
}

- (void)loadAllItems{
    if(!self.expenses){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ExpenseItem" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.expenses = [[NSSet alloc] initWithArray:result];
    }
    
    if(!self.incomes){
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"IncomeItem" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.expenses = [[NSSet alloc] initWithArray:result];
    }

}

@end
