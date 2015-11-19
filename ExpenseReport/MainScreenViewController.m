//
//  MainScreenViewController.m
//  BudgetHelperApplication
//
//  Created by Ricardo Cantu on 11/19/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MainScreenViewController.h"
#import "MonthsViewController.h"

@interface MainScreenViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MainScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Check if a year was pass this means it was open previously
    if(!self.yearSelected){
        NSDate *date = [[NSDate alloc]init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *year = [dateFormatter stringFromDate:date];
        
        self.yearSelected = (int)[year integerValue];
    }
    
    [self.navigationController setToolbarHidden:NO];
    
    //Check if a month was passed if not start in january
    if(!self.monthSelected){
        
        self.monthSelected = 1;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    MonthsViewController *mvc = [[MonthsViewController alloc]init];
    
    [mvc.view setFrame:self.scrollView.frame];
    
    mvc.monthSelected = self.monthSelected;
    
    [self.scrollView addSubview:mvc.view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
