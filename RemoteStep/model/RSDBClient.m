//
//  RSDBClient.m
//  RemoteStep
//
//  Created by Takeru Yoshihara on 2013/07/02.
//  Copyright (c) 2013年 Takeru Yoshihara. All rights reserved.
//

#import "RSDBClient.h"
#import "FMDatabase.h"
#import "RSLocation.h"
#import "RSSpot.h"

@interface RSDBClient ()
{
    
}

@end

static RSDBClient *_sharedClient = nil;

@implementation RSDBClient



+ (RSDBClient*)sharedInstance{
    
    
    if (_sharedClient == nil) {
        _sharedClient = [[RSDBClient alloc]init];
        
        //パス準備
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _sharedClient.dbPath = [paths[0] stringByAppendingPathComponent:@"database.db"];
        NSLog(@"database:path:%@",_sharedClient.dbPath);
        
    }
    
    return _sharedClient;
    
}



//db作成
- (void)createDBFile{

    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
}


//テーブル作成
- (void)createTable{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"CREATE TABLE IF NOT EXISTS spots (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, latitude TEXT, longitude TEXT, x TEXT, y TEXT)";
    
    [db open];
    [db executeUpdate:sql];
    [db close];
    
     
}



//データ挿入
- (void)insertSpot:(RSSpot*)spot{
        
    //挿入
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql_name = @"INSERT INTO spots(name) VALUES(?)";
    NSString *sql_lat = @"INSERT INTO spots(latitude) VALUES(?)";
    NSString *sql_lng = @"INSERT INTO spots(longitude) VALUES(?)";
    NSString *sql_x = @"INSERT INTO spots(x) VALUES(?)";
    NSString *sql_y = @"INSERT INTO spots(y) VALUES(?)";

    [db open];
    [db executeUpdate:sql_name,spot.name];
    [db executeUpdate:sql_lat, spot.latitude];
    [db executeUpdate:sql_lng, spot.longitude];
    [db executeUpdate:sql_x, spot.point_x];
    [db executeUpdate:sql_y, spot.point_y];
    
    [db close];
    
    
}


//データ削除
- (void)deleteSpot:(RSSpot*)spot{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"DELETE FROM spots WHERE id = ?";
    
    [db open];
    [db executeUpdate:sql, [NSNumber numberWithInt:[spot.identifier intValue]]];
    [db close];
    
}


//データ取得
- (void)selectAllSpots{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT name FROM spots";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    while ([results next]) {
        NSLog(@"name:%@",[results stringForColumn:@"name"]);
    }
    
     
}




@end
