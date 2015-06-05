//
//  DBManager.h
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (strong, nonatomic) NSMutableArray *arrayColumnNames;
@property (assign, nonatomic) int64_t lastInsertID;

- (id)initDatabaseName:(NSString *)name;
- (BOOL)executeUpdate:(NSString *)query;
- (NSArray *)executeQuery:(NSString *)query;

+ (instancetype)sharedInstance;

@end
