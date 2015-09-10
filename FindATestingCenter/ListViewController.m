//
//  ClinicListViewController.m
//  FindATestingCenter
//
//  Created by Edan Lichtenstein on 6/10/15.
//  Copyright (c) 2015 CodeForRVA. All rights reserved.
//

#import "ListViewController.h"
#import "ClinicLocationProvider.h"

@interface ListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *clinicArray;


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)provideDataToTableView:(NSArray *)clinics{
    self.clinicArray = clinics;
    [self.tableView reloadData];
}




# pragma mark - UITableViewDelegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.clinicArray count]>0) {
        return [self.clinicArray count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ClinicDataObject *clinic = [self.clinicArray objectAtIndex:indexPath.row];
    cell.textLabel.text =  clinic.name;
    cell.detailTextLabel.text = clinic.servicesOffered;
}

@end
