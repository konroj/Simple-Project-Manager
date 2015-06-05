//
//  WorkersViewController.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "WorkersViewController.h"
#import "HomeViewMainTableViewCell.h"
#import "WorkersPresenter.h"

static NSString * const HomeViewMainCell = @"HomeViewMainCell";

@interface WorkersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *workers;

@end

@implementation WorkersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.projectName;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:20]}];
    [self loadWorkers];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadWorkers];
    [self.tableView reloadData];
}

- (void)loadWorkers {
    self.workers = [WorkersPresenter selectWorkersForProjectID:self.projectId.integerValue];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeViewMainCell forIndexPath:indexPath];
    
    cell.counter.text = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];

    NSArray *worker = self.workers[indexPath.row];
    NSString *rand = worker[1];
    if ([rand isEqualToString:@"ios"]) {
        UIImage *image = [UIImage imageNamed:@"apple"];
        cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
    } else if ([rand isEqualToString:@"html"]) {
        UIImage *image = [UIImage imageNamed:@"html"];
        cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
    } else if ([rand isEqualToString:@"cpp"]) {
        UIImage *image = [UIImage imageNamed:@"cpp"];
        cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
    }
    
    NSString *rank = worker[1];
    cell.precentage.text = [NSString stringWithFormat:@"%@", rank];
    cell.projectName.text = worker[0];
    
    [cell.workersButton setTitle:worker[2] forState:UIControlStateNormal];
    [cell.infoButton setTitle:[NSString stringWithFormat:@"%@ PLN", worker[3]] forState:UIControlStateNormal];
    
    if (indexPath.row == self.workers.count-1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:255.0f/255.0 green:127.0f/255.0 blue:89.0f/255.0 alpha:1.0f];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:255.0f/255.0 green:127.0f/255.0 blue:89.0f/255.0 alpha:1.0f];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewMainTableViewCell *cell = (HomeViewMainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.projectName.text isEqualToString:self.name])
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self dropProject:indexPath];
    }
}

- (IBAction)joinAction:(id)sender {
    [self addProject];
}

- (void)addProject {
    NSLog(@"Add Project called");
    [WorkersPresenter addProject:self.projectName toUser:self.name];
    [self loadWorkers];
    [self.tableView reloadData];
}

- (void)dropProject:(NSIndexPath *)indexPath {
    NSLog(@"Drop Project called");
    [WorkersPresenter dropProject:self.projectName ofUser:self.name atPath:indexPath];
    [self loadWorkers];
    if (indexPath.row > 0) {
        NSArray *deleteIndexPaths = [NSArray arrayWithObjects:indexPath, nil];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
