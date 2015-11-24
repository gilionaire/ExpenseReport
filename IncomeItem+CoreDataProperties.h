//
//  IncomeItem+CoreDataProperties.h
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "IncomeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeItem (CoreDataProperties)

@property (nonatomic) double amount;
@property (nullable, nonatomic, retain) NSString *comments;
@property (nonatomic) NSDate * date;
@property (nullable, nonatomic, retain) NSString *source;

@end

NS_ASSUME_NONNULL_END
