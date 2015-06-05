//
//  HomeViewController.m
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewMainTableViewCell.h"
#import "DBManager.h"
#import "WorkersViewController.h"
#import "InfoViewController.h"
#import "HomePresenter.h"

static NSString * const HomeViewMainCell = @"HomeViewMainCell";
static NSString * const toWorkerSegue = @"toWorkerSegue";
static NSString * const toInfoSegue = @"toInfoSegue";

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, HomeViewMainTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *projects;
@property (strong, nonatomic) NSArray *myProjects;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"project manager";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:20]}];
    [self loadProjects];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadProjects];
    [self loadMyProjects];
    [self.tableView reloadData];
}

- (void)loadProjects {
    self.projects = [HomePresenter selectAllFromProjectOrderByProjectID];
}

- (void)loadMyProjects {
    self.myProjects = [HomePresenter selectProjectsForUser:self.name];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.myProjects.count == 0 || !self.myProjects)
        return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.myProjects.count)
        return self.myProjects.count;
    else
        return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeViewMainCell forIndexPath:indexPath];
    
    cell.counter.text = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];
    
    if (indexPath.section == 0 && self.myProjects.count) {
        cell.counter.text = [NSString stringWithFormat:@"%dM", (int)indexPath.row + 1];
        NSArray *project = self.myProjects[indexPath.row];
        NSString *rand = project[2];
        if (rand.intValue == 0) {
            UIImage *image = [UIImage imageNamed:@"apple"];
            cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
        } else if (rand.intValue == 1) {
            UIImage *image = [UIImage imageNamed:@"html"];
            cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
        } else {
            UIImage *image = [UIImage imageNamed:@"cpp"];
            cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
        }
        
        NSString *percent = project[3];
        cell.precentage.text = [NSString stringWithFormat:@"%d%%", percent.intValue];
        if (percent.intValue < 100 && percent.intValue != 0) {
            cell.projectName.text = [NSString stringWithFormat:@"%@ (working)", project[0]];
        } else if (percent.intValue == 100) {
            cell.projectName.text = [NSString stringWithFormat:@"%@ (completed)", project[0]];
        } else {
            cell.projectName.text = [NSString stringWithFormat:@"%@ (new)", project[0]];
        }
        
        if (indexPath.row == self.myProjects.count-1) {
            cell.bottomLine.hidden = YES;
        } else {
            cell.bottomLine.hidden = NO;
        }
    }
    
    if (indexPath.section == 1 || self.myProjects.count == 0 || !self.myProjects) {
        NSArray *project = self.projects[indexPath.row];
        NSString *rand = project[2];
        if (rand.intValue == 0) {
            UIImage *image = [UIImage imageNamed:@"apple"];
            cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
        } else if (rand.intValue == 1) {
            UIImage *image = [UIImage imageNamed:@"html"];
            cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
        } else {
            UIImage *image = [UIImage imageNamed:@"cpp"];
            cell.rightImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.rightImage setTintColor:[UIColor colorWithRed:40/255.0 green:67/255.0 blue:89.0f/255.0 alpha:1.0f]];
        }
        
        NSString *percent = project[3];
        cell.precentage.text = [NSString stringWithFormat:@"%d%%", percent.intValue];
        cell.projectName.text = project[0];
        
        if (indexPath.row == self.projects.count-1) {
            cell.bottomLine.hidden = YES;
        } else {
            cell.bottomLine.hidden = NO;
        }
    }
    
    cell.delegate = self;
    cell.cellIdentifier = indexPath;

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
    if (section == 0 && self.myProjects.count) {
        return 0;
    }
    return 5.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && !self.myProjects) || indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self deleteProject:indexPath];
        [self loadProjects];
        [self loadMyProjects];
        
        [self.tableView reloadData];
    }
}

- (void)deleteProject:(NSIndexPath *)indexPath {
    NSString *projectName;
    if (indexPath.section == 0 && !self.myProjects) {
        projectName = self.projects[indexPath.row][0];
    } else if (indexPath.section == 0 && self.myProjects) {
        projectName = self.myProjects[indexPath.row][0];
    } else if (indexPath.section == 1) {
        projectName = self.projects[indexPath.row][0];
    }
    
    if ((indexPath.section == 0 && !self.myProjects) || indexPath.section == 1) {
        // Delete All;
    } else {
        NSLog(@"Drop Project called");
        [HomePresenter dropProject:projectName ofUser:self.name];
        [self loadMyProjects];
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
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:toWorkerSegue] || [[segue identifier] isEqualToString:toInfoSegue]) {
        NSIndexPath *indexPath = sender;
        NSString *projectName;
        NSString *projectId;
        if (indexPath.section == 0 && !self.myProjects.count) {
            projectName = self.projects[indexPath.row][0];
            projectId = self.projects[indexPath.row][1];
        } else if (indexPath.section == 0 && self.myProjects) {
            projectName = self.myProjects[indexPath.row][0];
            projectId = self.myProjects[indexPath.row][1];
        } else if (indexPath.section == 1) {
            projectName = self.projects[indexPath.row][0];
            projectId = self.projects[indexPath.row][1];
        }
        
        if ([[segue identifier] isEqualToString:toWorkerSegue]) {
            // Get reference to the destination view controller
            WorkersViewController *view = [segue destinationViewController];
            view.projectName = projectName;
            view.projectId = projectId;
            view.name = self.name;
            view.password = self.password;
        } else {
            InfoViewController *view = [segue destinationViewController];
            view.projectName = projectName;
            view.projectId = projectId;
            view.name = self.name;
            view.password = self.password;
        }
    }
}

#pragma mark - HomeViewMainTableViewCellDelegate

- (void)didTapInfoButton:(NSIndexPath *)cellIdentifier {
    [self performSegueWithIdentifier:toInfoSegue sender:cellIdentifier];
}

- (void)didTapWorkerButton:(NSIndexPath *)cellIdentifier {
    [self performSegueWithIdentifier:toWorkerSegue sender:cellIdentifier];
}

//        NSLog(@"DELETING: %@", projectName);
//
//        NSInteger projectId;
//        NSString *projectIdQuery = [NSString stringWithFormat:@"SELECT projectid FROM project WHERE projectname LIKE '%@'", projectName];
//
//        NSArray *queryRes = [self.db executeQuery:projectIdQuery];
//
//        if (queryRes.count > 0) {
//            projectId = [queryRes[0][0] integerValue];
//
//            NSString *delete = [NSString stringWithFormat:@"DELETE FROM project WHERE projectid = %ld", (long)projectId];
//
//            if ([self.db executeUpdate:delete]) {
//                NSLog(@"SUCCESS: Project deleted");
//            } else {
//                NSLog(@"ERROR: Could not delete project");
//            }
//        } else {
//            NSLog(@"ERROR: Could not retrieve Project ID");
//        }

@end
