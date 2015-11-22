//
//  MainScreenViewController.m
//  BudgetHelperApplication
//
//  Created by Ricardo Cantu on 11/19/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MainScreenViewController.h"
#import "AppDelegate.h"
#import "TotalYearBalanceCell.h"

@interface MainScreenViewController ()

@property (nonatomic)NSArray *months;

@end

@implementation MainScreenViewController

-(instancetype)init {
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    //Check the default year
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *year = [defaults objectForKey:DefaultYearPrefsKey];
    self.yearSelected = (int)[year integerValue];

    [self.navigationController setToolbarHidden:NO];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    UIBarButtonItem *prevYear = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToPreviousYear:)];
    UIBarButtonItem *nextYear = [[UIBarButtonItem alloc]initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(goToNextYear:)];
    
    self.navigationItem.leftBarButtonItem = prevYear;
    self.navigationItem.rightBarButtonItem = nextYear;
    
    self.months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    return self;
}


-(void)goToPreviousYear: (id)sender {
    self.yearSelected--;
    
    if(self.yearSelected < 1900){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Really, are you more than 100 years old!" message:@"The least you can go is to 1900" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        self.yearSelected = 1900;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    [self.tableView reloadData];
}


- (void)goToNextYear: (id)sender {
    self.yearSelected++;
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UINib *nib = [UINib nibWithNibName:@"TotalYearBalanceCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TotalYearBalanceCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    
    
    if(indexPath.row < 12) {
        //Get a new or recycled cell
        //This is to reuse the cells for performance
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        cell.textLabel.text = self.months[indexPath.row];
        
        return cell;
    }
    else {
        
        //TO-DO have to create the monthly report class to load in here for now is 0.00 which will be the default
        TotalYearBalanceCell *totalCell = [tableView dequeueReusableCellWithIdentifier:@"TotalYearBalanceCell" forIndexPath:indexPath];
        
        //This is for testing purpose only
        if(self.yearSelected == 2015)
            totalCell.totalBalanceLabel.text = @"$ 0.00";
        else
            totalCell.totalBalanceLabel.text = @"$ 2000.00";
        
        UIColor *color = [UIColor greenColor];
        
        totalCell.totalBalanceLabel.textColor = [self darkerColorForColor:color];
        
        return  totalCell;
    }
}

//Took this from online
- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.5, 0.0)
                               green:MAX(g - 0.5, 0.0)
                                blue:MAX(b - 0.5, 0.0)
                               alpha:a];
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
 
    [self.navigationController setToolbarHidden:NO];
    
    //TO-DO the settings button
    //Do the settings bundle first
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //Do not allow to select the last row which is the balance
    if(indexPath.row == 12) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    //TO-DO the the push controller for the next view which is the monthly report view
    //pass along the proper montly report object
    
    
    
    //TO-DO pass the monthly report object
    
    
    
}




@end
