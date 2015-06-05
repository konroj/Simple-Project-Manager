//
//  WorkersPresenter.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "WorkersPresenter.h"
#import "DBManager.h"

@implementation WorkersPresenter

+ (void)addProject:(NSString *)projectName toUser:(NSString *)name {
    NSLog(@"Add Project called");
    
    NSInteger projectId;
    NSInteger workerId;
    NSString *projectIdQuery = [NSString stringWithFormat:@"SELECT projectid FROM project WHERE projectname LIKE '%@'", projectName];
    NSString *workerIdQuery = [NSString stringWithFormat:@"SELECT employeeid FROM employee WHERE name LIKE '%@'", name];
    
    NSArray *queryRes = [[DBManager sharedInstance] executeQuery:projectIdQuery];
    NSArray *nameResId = [[DBManager sharedInstance] executeQuery:workerIdQuery];
    
    projectId = [queryRes[0][0] integerValue];
    workerId = [nameResId[0][0] integerValue];
    
    NSString *checkQuery = [NSString stringWithFormat:@"SELECT employeeid FROM takes WHERE employeeid = %ld AND projectid = %ld;", (long)workerId, (long)projectId];
    NSArray *results = [[DBManager sharedInstance] executeQuery:checkQuery];
    if (results.count) {
        return;
    }
    
    if (queryRes.count > 0 && nameResId.count > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *addCourseQuery = [NSString stringWithFormat:@"INSERT INTO `takes`(`employeeid`,`projectid`,`date`) VALUES (%ld,%ld,'%@');", (long)workerId, (long)projectId, stringDate];
        
        if ([[DBManager sharedInstance] executeUpdate:addCourseQuery]) {
            NSLog(@"SUCCESS: Project Added");
        } else {
            NSLog(@"ERROR: Project not added");
        }
    } else {
        NSLog(@"ERROR: Could not find project (%@)", projectName);
    }
}

+ (void)dropProject:(NSString *)projectName ofUser:(NSString *)name atPath:(NSIndexPath *)indexPath {
    NSLog(@"Drop Project called");
    
    NSInteger projectId;
    NSInteger workerId;
    NSString *projectIdQuery = [NSString stringWithFormat:@"SELECT projectid FROM project WHERE projectname LIKE '%@'", projectName];
    NSString *workerIdQuery = [NSString stringWithFormat:@"SELECT employeeid FROM employee WHERE name LIKE '%@'", name];
    
    NSArray *queryRes = [[DBManager sharedInstance] executeQuery:projectIdQuery];
    NSArray *nameResId = [[DBManager sharedInstance] executeQuery:workerIdQuery];
    
    if (queryRes.count > 0 && nameResId.count > 0) {
        projectId = [queryRes[0][0] integerValue];
        workerId = [nameResId[0][0] integerValue];
        
        NSString *dropCourseQuery = [NSString stringWithFormat:@"DELETE FROM takes WHERE employeeid = %ld AND projectid = %ld;", (long)workerId, (long)projectId];
        
        if ([[DBManager sharedInstance] executeUpdate:dropCourseQuery]) {
            NSLog(@"SUCCESS: Project Dropped");
        } else {
            NSLog(@"ERROR: Project not dropped");
        }
    } else {
        NSLog(@"ERROR: Could not find project (%@)", projectName);
    }
}

+ (NSArray *)selectWorkersForProjectID:(NSInteger)projectID {
    NSString *takesQuery = [NSString stringWithFormat:@"SELECT * FROM takes WHERE projectid = %ld", (long)projectID];
    NSArray *takes = [[DBManager sharedInstance] executeQuery:takesQuery];
    
    NSMutableArray *mutable = [NSMutableArray new];
    for (NSArray *take in takes) {
        NSString *workerIdQuery = [NSString stringWithFormat:@"SELECT * FROM employee WHERE employeeid = '%@'", take[0]];
        NSArray *worker = [[DBManager sharedInstance] executeQuery:workerIdQuery];
        [mutable addObject:worker[0]];
    }
    return [NSArray arrayWithArray:mutable];
}

@end
