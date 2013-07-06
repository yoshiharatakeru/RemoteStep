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



+ (id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        if (_sharedClient == nil) {
            _sharedClient = [super allocWithZone:zone];
            return _sharedClient;
        }
    }
    return nil;
}



- (id)copyWithZone:(NSZone*)zone{
    return self;
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
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"INSERT INTO spots(name, latitude, longitude, x, y) VALUES(?,?,?,?,?)";
    
    [db open];
    [db executeUpdate:sql, spot.name, spot.latitude, spot.longitude, spot.point_x, spot.point_y];
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
- (NSMutableArray*)selectAllSpots{
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    NSString *sql = @"SELECT * FROM spots";
    
    [db open];
    FMResultSet *results = [db executeQuery:sql];
    
    NSMutableArray *array = NSMutableArray.new;
    
    while ([results next]) {
        
        RSSpot *spot = RSSpot.new;
        
        [spot setIdentifier:[NSString stringWithFormat:@"%d",[results intForColumn:@"id"]]];
        [spot setName:[results stringForColumn:@"name"]];
        [spot setLatitude:[results stringForColumn:@"latitude"]];
        [spot setLongitude:[results stringForColumn:@"longitude"]];
        [spot setPoint_x:[results stringForColumn:@"x"]];
        [spot setPoint_y:[results stringForColumn:@"y"]];
        
        [array addObject:spot];
        
    }
    
    return array;
    
    [db close];
    
    
}




@end
