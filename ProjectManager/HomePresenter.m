//
//  HomePresenter.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "HomePresenter.h"
#import "DBManager.h"

@implementation HomePresenter

+ (NSArray *)selectAllFromProjectOrderByProjectID {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM project ORDER BY projectid;"];
    return [[DBManager sharedInstance] executeQuery:query];
}

+ (NSArray *)selectProjectsForUser:(NSString *)name {
    NSString *query = [NSString stringWithFormat:@"SELECT employeeid FROM employee WHERE name = '%@';", name];
    NSArray *worker = [[DBManager sharedInstance] executeQuery:query];
    if (worker.count) {
        NSString *workerId = worker[0][0];
        NSString *takesQuery = [NSString stringWithFormat:@"SELECT * FROM takes WHERE employeeid = %d ORDER BY projectid", workerId.intValue];
        NSArray *takes = [[DBManager sharedInstance] executeQuery:takesQuery];
        
        NSMutableArray *mutable = [NSMutableArray new];
        for (NSArray *take in takes) {
            NSString *workerIdQuery = [NSString stringWithFormat:@"SELECT * FROM project WHERE projectid = %@", take[1]];
            NSArray *worker = [[DBManager sharedInstance] executeQuery:workerIdQuery];
            if (worker.count) {
                [mutable addObject:worker[0]];
            }
        }
        return [NSArray arrayWithArray:mutable];
    }
    return nil;
}

+ (BOOL)dropProject:(NSString *)projectName ofUser:(NSString *)userName {
    if (userName && projectName) {
        NSInteger projectId;
        NSInteger workerId;
        NSString *projectIdQuery = [NSString stringWithFormat:@"SELECT projectid FROM project WHERE projectname LIKE '%@'", projectName];
        NSString *workerIdQuery = [NSString stringWithFormat:@"SELECT employeeid FROM employee WHERE name LIKE '%@'", userName];
        
        NSArray *queryRes = [[DBManager sharedInstance] executeQuery:projectIdQuery];
        NSArray *nameResId = [[DBManager sharedInstance] executeQuery:workerIdQuery];
        
        if (queryRes.count > 0 && nameResId.count > 0) {
            projectId = [queryRes[0][0] integerValue];
            workerId = [nameResId[0][0] integerValue];
            
            NSString *dropCourseQuery = [NSString stringWithFormat:@"DELETE FROM takes WHERE employeeid = %ld AND projectid = %ld;", (long)workerId, (long)projectId];
            
            if ([[DBManager sharedInstance] executeUpdate:dropCourseQuery]) {
                NSLog(@"SUCCESS: Project Dropped");
                return YES;
            } else {
                NSLog(@"ERROR: Project not dropped");
            }
        } else {
            NSLog(@"ERROR: Could not find project (%@)", projectName);
        }
    } else {
        NSLog(@"ERROR: Invalid input");
    }
    return NO;
}

@end
