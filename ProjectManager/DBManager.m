//
//  DBManager.h
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "DBManager.h"
#import "sqlite3.h"

@interface DBManager()

@property (strong, atomic) NSString *documentsDirectory;
@property (strong, atomic) NSString *databaseFilename;
@property (strong, atomic) NSString *bundlePath;
@property (strong, atomic) NSMutableArray *arrayResults;

@end

@implementation DBManager

+ (instancetype)sharedInstance {
    static DBManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBManager alloc] init];
    });
    return sharedInstance;
}

- (id)initDatabaseName:(NSString *)dbName {
    if (self = [super init]) {
        self.bundlePath = [[NSBundle mainBundle] pathForResource:dbName ofType:@"db"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = [dbName stringByAppendingString:@".db"];
        [self copyDatabase];
    }
    
    return self;
}

- (void)copyDatabase {
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        NSString * sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError * error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    } else {
        NSLog(@"Database already exists.");
    }
}

// Perform a SELECT SQL statement
- (NSArray *)executeQuery:(NSString *)query {
    sqlite3 * sqlite3DB;
    self.arrayResults = [[NSMutableArray alloc] init];
    self.arrayColumnNames = [[NSMutableArray alloc] init];
    
    // Set the database file path.
    NSString * dbPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    int openResult = sqlite3_open([dbPath UTF8String], &sqlite3DB);
    
    if (openResult == SQLITE_OK) {
        sqlite3_stmt *compiledStmt;
        int preparedStmt = sqlite3_prepare_v2(sqlite3DB, [query UTF8String], -1, &compiledStmt, NULL);
        
        if (preparedStmt == SQLITE_OK) {
            NSMutableArray * dataRow;

            while (sqlite3_step(compiledStmt) == SQLITE_ROW) {
                dataRow = [[NSMutableArray alloc] init];
                int totalColumns = sqlite3_column_count(compiledStmt);
                
                for (int i = 0; i < totalColumns; i++) {
                    char *dataAsChars = (char *)sqlite3_column_text(compiledStmt, i);
                    
                    if (dataAsChars != NULL) {
                        [dataRow addObject:[NSString  stringWithUTF8String:dataAsChars]];
                    }
                    
                    if (self.arrayColumnNames.count != totalColumns) {
                        dataAsChars = (char *)sqlite3_column_name(compiledStmt, i);
                        [self.arrayColumnNames addObject:[NSString stringWithUTF8String:dataAsChars]];
                    }
                }
                
                if (dataRow.count > 0) {
                    [self.arrayResults addObject: dataRow];
                }
            }
        } else {
            NSLog(@"Error in SQL query: %s", sqlite3_errmsg(sqlite3DB));
            NSLog(@"Database error %d: %s", sqlite3_errcode(sqlite3DB), sqlite3_errmsg(sqlite3DB));
        }
        
        sqlite3_finalize(compiledStmt);
    }
    
    sqlite3_close(sqlite3DB);
    
    return self.arrayResults;
}

- (BOOL)executeUpdate:(NSString *)query {
    BOOL ret = NO;
    sqlite3 * sqlite3DB;

    NSString * dbPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    int openResult = sqlite3_open([dbPath UTF8String], &sqlite3DB);
    
    if (openResult == SQLITE_OK) {
        sqlite3_stmt *compiledStmt;
        int preparedStmt = sqlite3_prepare_v2(sqlite3DB, [query UTF8String], -1, &compiledStmt, NULL);
        
        if (preparedStmt == SQLITE_OK) {
            if (sqlite3_step(compiledStmt) == SQLITE_DONE) {
                ret = YES;
            } else {
                NSLog(@"Error in SQL query: %s", sqlite3_errmsg(sqlite3DB));
                NSLog(@"Database error %d: %s", sqlite3_errcode(sqlite3DB), sqlite3_errmsg(sqlite3DB));
            }
        }
        
        sqlite3_finalize(compiledStmt);
    }
    
    sqlite3_close(sqlite3DB);
    
    return ret;
}

@end
