//
//  SourceOrTypeCell.h
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/23/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceOrTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sourceOrTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
