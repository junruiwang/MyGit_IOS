//
//  SqliteService.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-5-19.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "SqliteService.h"
#import "FileManager.h"

@implementation SqliteService

@synthesize _database;

//创建，打开数据库
- (BOOL)openDB {
	//获取数据库路径
	NSString *path = [FileManager fileCachesPath:kFilename];
	//文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	//判断数据库是否存在
	BOOL find = [fileManager fileExistsAtPath:path];
	
	//如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
	if (find) {
		NSLog(@"Database file have already existed.");
		//打开数据库，这里的[path UTF8String]是将NSString转换为C字符串，因为SQLite3是采用可移植的C(而不是
		//Objective-C)编写的，它不知道什么是NSString.
		if(sqlite3_open([path UTF8String], &_database) != SQLITE_OK) {
			//如果打开数据库失败则关闭数据库
			sqlite3_close(self._database);
			NSLog(@"Error: open database file.");
			return NO;
		}
		//创建一个新表
		[self CreatTable:self._database];
		return YES;
	}
	//如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
	if(sqlite3_open([path UTF8String], &_database) == SQLITE_OK) {
		//创建一个新表
		[self CreatTable:self._database];
		return YES;
    } else {
		//如果创建并打开数据库失败则关闭数据库
		sqlite3_close(self._database);
		NSLog(@"Error: open database file.");
		return NO;
    }
	return NO;
}
//创建表
- (BOOL) CreatTable:(sqlite3 *)db
{
	char *sql = "create table if not exists weatherTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,_1city text, _2cityid text, _3time text, _4temp text, _5WD text, _6WS text, _7SD text, _8date_y text,_9week text, _10temp1 text, _11temp2 text, _12temp3 text, _13temp4 text, _14temp5 text, _15temp6 text, _16weather1 text, _17weather2 text, _18weather3 text, _19weather4 text, _20weather5 text, _21weather6 text, _22img1 text, _23img3 text, _24img5 text, _25img7 text, _26img9 text, _27img11 text, _28wind1 text, _29wind2 text, _30wind3 text, _31wind4 text, _32wind5 text, _33wind6 text, _34fl1 text, _35fl2 text, _36fl3 text, _37fl4 text, _38fl5 text, _39fl6 text, _40index_d text, _41index_uv text, _42index_xc text, _43index_tr text, _44index_co text, _45index_cl text, _46index_ls text, _47index_ag text)";
	sqlite3_stmt *statement;
	//sqlite3_prepare_v2 接口把一条SQL语句解析到statement结构里去. 使用该接口访问数据库是当前比较好的的一种方法
	NSInteger sqlReturn = sqlite3_prepare_v2(_database, sql, -1, &statement, nil);
	//第一个参数跟前面一样，是个sqlite3 * 类型变量，
	//第二个参数是一个 sql 语句。
	//第三个参数我写的是-1，这个参数含义是前面 sql 语句的长度。如果小于0，sqlite会自动计算它的长度（把sql语句当成以\0结尾的字符串）。
	//第四个参数是sqlite3_stmt 的指针的指针。解析以后的sql语句就放在这个结构里。
	//第五个参数我也不知道是干什么的。为nil就可以了。
	//如果这个函数执行成功（返回值是 SQLITE_OK 且 statement 不为NULL ），那么下面就可以开始插入二进制数据。
	
	//如果SQL语句解析出错的话程序返回
	if(sqlReturn != SQLITE_OK) {
		NSLog(@"Error: failed to prepare statement:create test table");
		return NO;
	}
	//执行SQL语句
	int success = sqlite3_step(statement);
	//释放sqlite3_stmt
	sqlite3_finalize(statement);
	
	//执行SQL语句失败
	if ( success != SQLITE_DONE) {
		NSLog(@"Error: failed to dehydrate:create table test");
		return NO;
	}
	NSLog(@"Create table 'weatherTable' successed.");
	return YES;
}

//插入数据
- (BOOL) insertModel:(ModelWeather *)modelWeather
{
    NSMutableArray *tempdata=[[NSMutableArray alloc]init];
	tempdata=[self getWeatherModelArray];
    NSMutableArray *hisvalue=[[NSMutableArray alloc]init ];
    for (int i=0; i<[tempdata count]; i++) {
        [hisvalue addObject:((ModelWeather *)[tempdata objectAtIndex:i])._1city];
    }
    //如果本地有,则不插入新的数据
    if (![hisvalue containsObject:modelWeather._1city]) {
        //先判断数据库是否打开
        if ([self openDB]) {
            sqlite3_stmt *statement;
            //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
            static char *sql = "INSERT INTO weatherTable(_1city, _2cityid, _3time, _4temp, _5WD, _6WS, _7SD, _8date_y,_9week, _10temp1, _11temp2, _12temp3, _13temp4, _14temp5, _15temp6, _16weather1, _17weather2, _18weather3, _19weather4, _20weather5, _21weather6, _22img1, _23img3, _24img5, _25img7, _26img9, _27img11, _28wind1, _29wind2, _30wind3, _31wind4, _32wind5, _33wind6, _34fl1, _35fl2, _36fl3, _37fl4, _38fl5, _39fl6, _40index_d, _41index_uv, _42index_xc, _43index_tr, _44index_co, _45index_cl, _46index_ls, _47index_ag) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            
            int success2 = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
            if (success2 != SQLITE_OK) {
                NSLog(@"Error: failed to insert:weatherTable");
                sqlite3_close(_database);
                return NO;
            }
            //这里的数字1，2，3代表第几个问号，这里将两个值绑定到两个绑定变量
            sqlite3_bind_text(statement, 1, [modelWeather._1city UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [modelWeather._2cityid UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [modelWeather._3time UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [modelWeather._4temp UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [modelWeather._5WD UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [modelWeather._6WS UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 7, [modelWeather._7SD UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 8, [modelWeather._8date_y UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 9, [modelWeather._9week UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 10, [modelWeather._10temp1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 11, [modelWeather._11temp2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 12, [modelWeather._12temp3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 13, [modelWeather._13temp4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 14, [modelWeather._14temp5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 15, [modelWeather._15temp6 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 16, [modelWeather._16weather1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 17, [modelWeather._17weather2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 18, [modelWeather._18weather3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 19, [modelWeather._19weather4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 20, [modelWeather._20weather5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 21, [modelWeather._21weather6 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 22, [modelWeather._22img1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 23, [modelWeather._23img3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 24, [modelWeather._24img5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 25, [modelWeather._25img7 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 26, [modelWeather._26img9 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 27, [modelWeather._27img11 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 28, [modelWeather._28wind1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 29, [modelWeather._29wind2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 30, [modelWeather._30wind3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 31, [modelWeather._31wind4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 32, [modelWeather._32wind5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 33, [modelWeather._33wind6 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 34, [modelWeather._34fl1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 35, [modelWeather._35fl2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 36, [modelWeather._36fl3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 37, [modelWeather._37fl4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 38, [modelWeather._38fl5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 39, [modelWeather._39fl6 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 40, [modelWeather._40index_d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 41, [modelWeather._41index_uv UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 42, [modelWeather._42index_xc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 43, [modelWeather._43index_tr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 44, [modelWeather._44index_co UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 45, [modelWeather._45index_cl UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 46, [modelWeather._46index_ls UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 47, [modelWeather._47index_ag UTF8String], -1, SQLITE_TRANSIENT);
            //执行插入语句
            success2 = sqlite3_step(statement);
            //释放statement
            sqlite3_finalize(statement);
            
            //如果插入失败
            if (success2 == SQLITE_ERROR) {
                NSLog(@"Error: failed to insert into the database with message.");
                //关闭数据库
                sqlite3_close(_database);
                return NO;
            }
            //关闭数据库
            sqlite3_close(_database);
            return YES;
        }
    }
	return NO;
}

//删除数据
- (BOOL)deleteWeatherModel:(NSString *)cityName
{
	if ([self openDB]) {
		
		sqlite3_stmt *statement;
		//组织SQL语句
		static char *sql = "delete from weatherTable where _1city=? ";
		//将SQL语句放入sqlite3_stmt中
		int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
		if (success != SQLITE_OK) {
			NSLog(@"Error: failed to delete:weatherTable");
			sqlite3_close(_database);
			return NO;
		}
		//这里的数字1，2，3代表第几个问号。这里只有1个问号
		sqlite3_bind_text(statement, 1, [cityName UTF8String], -1, SQLITE_TRANSIENT);
		//执行SQL语句。这里是更新数据库
		success = sqlite3_step(statement);
		//释放statement
		sqlite3_finalize(statement);
		//如果执行失败
		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to delete the database with message.");
			//关闭数据库
			sqlite3_close(_database);
			return NO;
		}
		//执行成功后依然要关闭数据库
		sqlite3_close(_database);
		return YES;
	}
	return NO;
}

//更新数据
- (BOOL)updateWeatherModel:(ModelWeather *)modelWeather
{
	if ([self openDB]) {
		sqlite3_stmt *statement;
		//组织SQL语句
        char *sql = "update weatherTable set _2cityid=?,_3time=?,_4temp=?,_5WD=?,_6WS=?,_7SD=?,_8date_y,_9week=?,_10temp1=?,_11temp2=?,_12temp3=?,_13temp4=?,_14temp5=?,_15temp6=?,_16weather1=?,_17weather2=?,_18weather3=?,_19weather4=?,_20weather5=?,_21weather6=?,_22img1=?,_23img3=?,_24img5=?,_25img7=?,_26img9=?,_27img11=?,_28wind1=?,_29wind2=?,_30wind3=?,_31wind4=?,_32wind5=?,_33wind6=?,_34fl1=?,_35fl2=?,_36fl3=?,_37fl4=?,_38fl5=?,_39fl6=?,_40index_d=?,_41index_uv=?,_42index_xc=?,_43index_tr=?,_44index_co=?,_45index_cl=?,_46index_ls=?,_47index_ag=? where _1city=? ";
		
		//将SQL语句放入sqlite3_stmt中
		int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
		if (success != SQLITE_OK) {
			NSLog(@"Error: failed to update:testTable");
			sqlite3_close(_database);
			return NO;
		}
		sqlite3_bind_text(statement, 1, [modelWeather._2cityid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [modelWeather._3time UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [modelWeather._4temp UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [modelWeather._5WD UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [modelWeather._6WS UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [modelWeather._7SD UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [modelWeather._8date_y UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [modelWeather._9week UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9, [modelWeather._10temp1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10, [modelWeather._11temp2 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11, [modelWeather._12temp3 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 12, [modelWeather._13temp4 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 13, [modelWeather._14temp5 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 14, [modelWeather._15temp6 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 15, [modelWeather._16weather1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 16, [modelWeather._17weather2 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 17, [modelWeather._18weather3 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 18, [modelWeather._19weather4 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 19, [modelWeather._20weather5 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 20, [modelWeather._21weather6 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 21, [modelWeather._22img1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 22, [modelWeather._23img3 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 23, [modelWeather._24img5 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 24, [modelWeather._25img7 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 25, [modelWeather._26img9 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 26, [modelWeather._27img11 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 27, [modelWeather._28wind1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 28, [modelWeather._29wind2 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 29, [modelWeather._30wind3 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 30, [modelWeather._31wind4 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 31, [modelWeather._32wind5 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 32, [modelWeather._33wind6 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 33, [modelWeather._34fl1 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 34, [modelWeather._35fl2 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 35, [modelWeather._36fl3 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 36, [modelWeather._37fl4 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 37, [modelWeather._38fl5 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 38, [modelWeather._39fl6 UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 39, [modelWeather._40index_d UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 40, [modelWeather._41index_uv UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 41, [modelWeather._42index_xc UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 42, [modelWeather._43index_tr UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 43, [modelWeather._44index_co UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 44, [modelWeather._45index_cl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 45, [modelWeather._46index_ls UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 46, [modelWeather._47index_ag UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 47, [modelWeather._1city UTF8String], -1, SQLITE_TRANSIENT);
		//执行SQL语句。这里是更新数据库
		success = sqlite3_step(statement);
		//释放statement
		sqlite3_finalize(statement);
		//如果执行失败
		if (success == SQLITE_ERROR) {
			NSLog(@"Error: failed to update the database with message.");
			//关闭数据库
			sqlite3_close(_database);
			return NO;
		}
		//执行成功后依然要关闭数据库
		sqlite3_close(_database);
		return YES;
	}
	return NO;
}

//获取数据
- (NSMutableArray*)getWeatherModelArray
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
	//判断数据库是否打开
	if ([self openDB]) {
		sqlite3_stmt *statement = nil;
		//sql语句
		char *sql = "SELECT * FROM weatherTable";
		
		if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog(@"Error: failed to prepare statement with message:get testValue.");
			return NO;
		}
		else {
			//查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
			while (sqlite3_step(statement) == SQLITE_ROW) {
				ModelWeather* sqlList = [[ModelWeather alloc] init];
				sqlList._1city = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                sqlList._2cityid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                sqlList._3time = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                sqlList._4temp = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                sqlList._5WD = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                sqlList._6WS = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
                sqlList._7SD = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                sqlList._8date_y = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
                sqlList._9week = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 9)];
                sqlList._10temp1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 10)];
                sqlList._11temp2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 11)];
                sqlList._12temp3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 12)];
                sqlList._13temp4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 13)];
                sqlList._14temp5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 14)];
                sqlList._15temp6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 15)];
                sqlList._16weather1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 16)];
                sqlList._17weather2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 17)];
                sqlList._18weather3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 18)];
                sqlList._19weather4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 19)];
                sqlList._20weather5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 20)];
                sqlList._21weather6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 21)];
                sqlList._22img1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 22)];
                sqlList._23img3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 23)];
                sqlList._24img5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 24)];
                sqlList._25img7 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 25)];
                sqlList._26img9 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 26)];
                sqlList._27img11 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 27)];
                sqlList._28wind1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 28)];
                sqlList._29wind2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 29)];
                sqlList._30wind3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 30)];
                sqlList._31wind4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 31)];
                sqlList._32wind5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 32)];
                sqlList._33wind6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 33)];
                sqlList._34fl1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 34)];
                sqlList._35fl2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 35)];
                sqlList._36fl3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 36)];
                sqlList._37fl4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 37)];
                sqlList._38fl5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 38)];
                sqlList._39fl6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 39)];
                sqlList._40index_d = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 40)];
                sqlList._41index_uv = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 41)];
                sqlList._42index_xc = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 42)];
                sqlList._43index_tr = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 43)];
                sqlList._44index_co = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 44)];
                sqlList._45index_cl = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 45)];
                sqlList._46index_ls = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 46)];
                sqlList._47index_ag = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 47)];
                
                [array addObject:sqlList];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(_database);
	}
	return [array mutableCopy];
}

@end
