//
//  MonthReportCollection.m
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MonthReportCollection.h"
#import "ExpenseItem.h"
#import "IncomeItem.h"

@import CoreData;

@interface MonthReportCollection()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation MonthReportCollection

- (NSString *) itemArchivePath{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return  [documentDirectory stringByAppendingPathComponent:@"reportCollection.data"];
}

- (BOOL) saveChanges{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful)
        NSLog(@"Error saving: %@", [error localizedDescription]);
    return successful;
}

+ (instancetype) sharedCollection {
    static MonthReportCollection *sharedCollection = nil;
    
    if (!sharedCollection) {
        sharedCollection = [[self alloc] init];
    }
    return sharedCollection;
}

- (id)init {
    self = [super init];
    if(self){
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
        
        [self loadAllMonths];
    }
    return self;
}

- (MonthReport *) createMonthReportWithYear:(NSNumber *)year
                    AndMonthNumber:(NSNumber *)month
{
    MonthReport *monthReport = [NSEntityDescription insertNewObjectForEntityForName:@"MonthReport" inManagedObjectContext:self.context];
    NSMutableDictionary *monthDict = [self.allMonths objectForKey:year];
    [monthDict setObject:monthReport forKey:month];
    return monthReport;
}

- (void)loadAllMonths{
    if(!self.allMonths) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"MonthReport"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        NSMutableArray *monthReports = [[NSMutableArray alloc]initWithArray:result];
        
        NSMutableDictionary *yearDictionary = [[NSMutableDictionary alloc]init];
        
        for(MonthReport *monthReport in monthReports){
            if ([yearDictionary objectForKey:[NSNumber numberWithInt:monthReport.year]]) {
                NSMutableDictionary *monthDict = [yearDictionary objectForKey:[NSNumber numberWithInt:monthReport.year]];
                [monthDict setObject:monthReport forKey:[NSNumber numberWithInt:monthReport.month]];
            }
            else {
            NSMutableDictionary *monthDictionary = [[NSMutableDictionary alloc]init];
            [monthDictionary setObject:monthReport forKey:[NSNumber numberWithInt:monthReport.month]];
            [yearDictionary setObject:monthDictionary forKey:[NSNumber numberWithInt:monthReport.year]];
            }
        }
        self.allMonths = [[NSMutableDictionary alloc] initWithDictionary:yearDictionary];
    }
}

@end
