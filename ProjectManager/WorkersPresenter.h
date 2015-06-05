//
//  WorkersPresenter.h
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkersPresenter : NSObject

+ (void)addProject:(NSString *)projectName toUser:(NSString *)name;
+ (void)dropProject:(NSString *)projectName ofUser:(NSString *)name atPath:(NSIndexPath *)indexPath;
+ (NSArray *)selectWorkersForProjectID:(NSInteger)projectID;

@end
