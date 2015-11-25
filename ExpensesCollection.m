//
//  ExpensesCollection.m
//  ExpenseReport
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "ExpensesCollection.h"
#import "ExpenseItem.h"

@implementation ExpensesCollection

- (NSString *) itemArchivePath{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"expenses.data"];
}

- (BOOL) saveChanges{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful){
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

+ (instancetype) sharedCollection{
    static ExpensesCollection *sharedCollection = nil;
    
    // Do I need to create a sharedStore?
    if (! sharedCollection)
    {
        sharedCollection = [[ self alloc] init];
    }
    return sharedCollection;

}

-(id) init{
    self = [super init];
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
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
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllExpenses];
    }
    return self;
}

- (ExpenseItem *) createExpense{
    NSLog(@"Adding after %lu items", (unsigned long)[self.allExpenses count]);
    ExpenseItem *expense = [NSEntityDescription insertNewObjectForEntityForName:@"ExpenseItem"
                                                         inManagedObjectContext:self.context];
    [self.allExpenses addObject:expense];
    return expense;
}

-(void) removeExpense:(ExpenseItem *)expense{
    [self.context deleteObject:expense];
    [self.allExpenses removeObjectIdenticalTo:expense];
}

- (void)loadAllExpenses{
    if (!self.allExpenses) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ExpenseItem"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.allExpenses = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(double)currentExpensesBalance {
    
    double balance = 0;
    
    NSDate *todaysDate = [[NSDate alloc]init];
    
    for(ExpenseItem *expense in self.allExpenses){
        
        if ([expense.date compare:todaysDate] != NSOrderedDescending) {
            
            balance+= expense.amount;
        }
    }
    
    return balance;
}

@end
