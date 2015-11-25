//
//  IncomeCollection.m
//  IncomeReport
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "IncomeCollection.h"
#import "IncomeItem.h"
#import "AppDelegate.h"

@implementation IncomeCollection

- (NSString *) itemArchivePath{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"incomes.data"];
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
    static IncomeCollection *sharedCollection = nil;
    
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
        
        [self loadAllIncomes];
    }
    return self;
}

- (IncomeItem *) createIncome{
    NSLog(@"Adding after %lu items", (unsigned long)[self.allIncomes count]);
    IncomeItem *income = [NSEntityDescription insertNewObjectForEntityForName:@"IncomeItem"
                                                       inManagedObjectContext:self.context];
    [self.allIncomes addObject:income];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    income.source = [defaults objectForKey:DefaultIncomeSourcePrefsKey];
    income.amount = [defaults doubleForKey:DefaultIncomeAmountPrefsKey];
    
    return income;
}

-(void) removeIncome:(IncomeItem *)income{
    [self.context deleteObject:income];
    [self.allIncomes removeObjectIdenticalTo:income];
}

- (void)loadAllIncomes{
    if (!self.allIncomes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"IncomeItem"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.allIncomes = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(double)currentIncomesBalance {
    
    double balance = 0;
    
    NSDate *todaysDate = [[NSDate alloc]init];
    
    for(IncomeItem *income in self.allIncomes){
        
        if ([income.date compare:todaysDate] != NSOrderedDescending) {
            
            balance+= income.amount;
        }
    }
    
    return balance;
}

@end
