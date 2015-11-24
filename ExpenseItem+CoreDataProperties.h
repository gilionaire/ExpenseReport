//
//  ExpenseItem+CoreDataProperties.h
//  ExpenseReport
//
//  Created by Group10 on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ExpenseItem.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpenseItem (CoreDataProperties)

@property (nonatomic) double amount;
@property (nullable, nonatomic, retain) NSString *comments;
@property (nonatomic) NSDate * date;
@property (nullable, nonatomic, retain) NSString *type;

@end

NS_ASSUME_NONNULL_END
