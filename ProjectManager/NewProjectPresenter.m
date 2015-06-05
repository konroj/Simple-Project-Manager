//
//  NewProjectPresenter.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "NewProjectPresenter.h"
#import "DBManager.h"

@implementation NewProjectPresenter

+ (BOOL)insertNewProject:(NSString *)name ofType:(NSString *)ptype {
    NSString *maxIdQuery = [NSString stringWithFormat:@"SELECT MAX(projectid) FROM project;"];
    
    NSArray *queryRes = [[DBManager sharedInstance] executeQuery:maxIdQuery];
    NSInteger maxId;
    if (queryRes.count) {
        maxId = [queryRes[0][0] integerValue];
    } else {
        maxId = 0;
    }
    int type;
    if ([ptype isEqualToString:@"ios"]) {
        type = 0;
    } else if ([ptype isEqualToString:@"html"]) {
        type = 1;
    } else {
        type = 2;
    }
    NSString *updateQuery = [NSString stringWithFormat:@"INSERT INTO `project`(`projectname`,`projectid`,`projecttype`,`precentage`) VALUES ('%@',%ld,%d,%u);", name, maxId + 1, type, 0];
    
    
    if ([[DBManager sharedInstance] executeUpdate:updateQuery]) {
        return YES;
    } else {
        return NO;
    }
}

@end
