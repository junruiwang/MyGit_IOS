//
//  SqliteService.m
//  WeatherReport
//
//  Created by 汪君瑞 on 13-5-19.
//  Copyright (c) 2013年 jerry. All rights reserved.
//

#import "SqliteService.h"
#import "FileManager.h"
#import "City.h"
#import "LocalCityListManager.h"

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
	char *sql = "create table if not exists weatherTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,_1city text, _2cityid text, _3time text, _4temp text, _5WD text, _6WS text, _7SD text, _8date_y text,_9week text, _10temp1 text, _11temp2 text, _12temp3 text, _13temp4 text, _14temp5 text, _15temp6 text, _16weather1 text, _17weather2 text, _18weather3 text, _19weather4 text, _20weather5 text, _21weather6 text, _22img1 text, _23img2 text, _24img3 text, _25img4 text, _26img5 text, _27img6 text, _28img7 text, _29img8 text, _30img9 text, _31img10 text, _32img11 text, _33img12 text, _34img_title1 text, _35img_title2 text, _36img_title3 text, _37img_title4 text, _38img_title5 text, _39img_title6 text, _40img_title7 text, _41img_title8 text, _42img_title9 text, _43img_title10 text, _44img_title11 text, _45img_title12 text, _46wind1 text, _47wind2 text, _48wind3 text, _49wind4 text, _50wind5 text, _51wind6 text, _52fl1 text, _53fl2 text, _54fl3 text, _55fl4 text, _56fl5 text, _57fl6 text, _58index text, _59index_d text, _60index48 text, _61index48_d text, _62index_uv text, _63index48_uv text, _64index_xc text, _65index_tr text, _66index_co text, _67index_cl text, _68index_ls text, _69index_ag text)";
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
    NSMutableArray *tempdata=[self getWeatherModelArray];
    NSMutableArray *hisvalue=[[NSMutableArray alloc] init];
    
    for (int i=0; i<[tempdata count]; i++) {
        [hisvalue addObject:((ModelWeather *)[tempdata objectAtIndex:i])._2cityid];
    }
    //如果本地有,则不插入新的数据
    if (![hisvalue containsObject:modelWeather._2cityid]) {
        //先判断数据库是否打开
        if ([self openDB]) {
            @try {
                sqlite3_stmt *statement;
                //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
                static char *sql = "INSERT INTO weatherTable(_1city, _2cityid, _3time, _4temp, _5WD, _6WS, _7SD, _8date_y,_9week, _10temp1, _11temp2, _12temp3, _13temp4, _14temp5, _15temp6, _16weather1, _17weather2, _18weather3, _19weather4, _20weather5, _21weather6, _22img1, _23img2, _24img3, _25img4, _26img5, _27img6, _28img7, _29img8, _30img9, _31img10, _32img11, _33img12, _34img_title1, _35img_title2, _36img_title3, _37img_title4, _38img_title5, _39img_title6, _40img_title7, _41img_title8, _42img_title9, _43img_title10, _44img_title11, _45img_title12, _46wind1, _47wind2, _48wind3, _49wind4, _50wind5, _51wind6, _52fl1, _53fl2, _54fl3, _55fl4, _56fl5, _57fl6, _58index, _59index_d, _60index48, _61index48_d, _62index_uv, _63index48_uv, _64index_xc, _65index_tr, _66index_co, _67index_cl, _68index_ls, _69index_ag) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                
                int success2 = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
                if (success2 != SQLITE_OK) {
                    NSLog(@"Error: failed to insert:weatherTable");
                    sqlite3_close(_database);
                    return NO;
                }
                //这里的数字1，2，3代表第几个问号，这里将值绑定到变量
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
                sqlite3_bind_text(statement, 23, [modelWeather._23img2 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 24, [modelWeather._24img3 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 25, [modelWeather._25img4 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 26, [modelWeather._26img5 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 27, [modelWeather._27img6 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 28, [modelWeather._28img7 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 29, [modelWeather._29img8 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 30, [modelWeather._30img9 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 31, [modelWeather._31img10 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 32, [modelWeather._32img11 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 33, [modelWeather._33img12 UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 34, [modelWeather._34img_title1 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 35, [modelWeather._35img_title2 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 36, [modelWeather._36img_title3 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 37, [modelWeather._37img_title4 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 38, [modelWeather._38img_title5 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 39, [modelWeather._39img_title6 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 40, [modelWeather._40img_title7 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 41, [modelWeather._41img_title8 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 42, [modelWeather._42img_title9 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 43, [modelWeather._43img_title10 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 44, [modelWeather._44img_title11 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 45, [modelWeather._45img_title12 UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 46, [modelWeather._46wind1 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 47, [modelWeather._47wind2 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 48, [modelWeather._48wind3 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 49, [modelWeather._49wind4 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 50, [modelWeather._50wind5 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 51, [modelWeather._51wind6 UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 52, [modelWeather._52fl1 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 53, [modelWeather._53fl2 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 54, [modelWeather._54fl3 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 55, [modelWeather._55fl4 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 56, [modelWeather._56fl5 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 57, [modelWeather._57fl6 UTF8String], -1, SQLITE_TRANSIENT);
                
                sqlite3_bind_text(statement, 58, [modelWeather._58index UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 59, [modelWeather._59index_d UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 60, [modelWeather._60index48 UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 61, [modelWeather._61index48_d UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 62, [modelWeather._62index_uv UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 63, [modelWeather._63index48_uv UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 64, [modelWeather._64index_xc UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 65, [modelWeather._65index_tr UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 66, [modelWeather._66index_co UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 67, [modelWeather._67index_cl UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 68, [modelWeather._68index_ls UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 69, [modelWeather._69index_ag UTF8String], -1, SQLITE_TRANSIENT);
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
            @catch (NSException *exception) {
                sqlite3_close(_database);
                return NO;
            }
            @finally {
                
            }
        }
        return NO;
    }
	return NO;
}

//删除数据
- (BOOL)deleteWeatherModel:(NSString *)searchCode
{
	if ([self openDB]) {
		@try {
            sqlite3_stmt *statement;
            //组织SQL语句
            static char *sql = "delete from weatherTable where _2cityid=? ";
            //将SQL语句放入sqlite3_stmt中
            int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
            if (success != SQLITE_OK) {
                NSLog(@"Error: failed to delete:weatherTable");
                sqlite3_close(_database);
                return NO;
            }
            sqlite3_bind_text(statement, 1, [searchCode UTF8String], -1, SQLITE_TRANSIENT);
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
        @catch (NSException *exception) {
            sqlite3_close(_database);
            return NO;
        }
        @finally {
            
        }
	}
	return NO;
}

//更新数据
- (BOOL)updateWeatherModel:(ModelWeather *)modelWeather
{
	if ([self openDB]) {
        
        @try {
            sqlite3_stmt *statement;
            //组织SQL语句
            char *sql = "update weatherTable set _1city=?,_3time=?,_4temp=?,_5WD=?,_6WS=?,_7SD=?,_8date_y=?,_9week=?,_10temp1=?,_11temp2=?,_12temp3=?,_13temp4=?,_14temp5=?,_15temp6=?,_16weather1=?,_17weather2=?,_18weather3=?,_19weather4=?,_20weather5=?,_21weather6=?,_22img1=?,_23img2=?,_24img3=?,_25img4=?,_26img5=?,_27img6=?,_28img7=?,_29img8=?,_30img9=?,_31img10=?,_32img11=?,_33img12=?,_34img_title1=?,_35img_title2=?,_36img_title3=?,_37img_title4=?,_38img_title5=?,_39img_title6=?,_40img_title7=?,_41img_title8=?,_42img_title9=?,_43img_title10=?,_44img_title11=?,_45img_title12=?,_46wind1=?,_47wind2=?,_48wind3=?,_49wind4=?,_50wind5=?,_51wind6=?,_52fl1=?,_53fl2=?,_54fl3=?,_55fl4=?,_56fl5=?,_57fl6=?,_58index=?,_59index_d=?,_60index48=?,_61index48_d=?,_62index_uv=?,_63index48_uv=?,_64index_xc=?,_65index_tr=?,_66index_co=?,_67index_cl=?,_68index_ls=?,_69index_ag=? where _2cityid=? ";
            
            //将SQL语句放入sqlite3_stmt中
            int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
            if (success != SQLITE_OK) {
                NSLog(@"Error: failed to update:weatherTable");
                sqlite3_close(_database);
                return NO;
            }
            sqlite3_bind_text(statement, 1, [modelWeather._1city UTF8String], -1, SQLITE_TRANSIENT);
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
            sqlite3_bind_text(statement, 22, [modelWeather._23img2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 23, [modelWeather._24img3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 24, [modelWeather._25img4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 25, [modelWeather._26img5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 26, [modelWeather._27img6 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 27, [modelWeather._28img7 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 28, [modelWeather._29img8 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 29, [modelWeather._30img9 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 30, [modelWeather._31img10 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 31, [modelWeather._32img11 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 32, [modelWeather._33img12 UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 33, [modelWeather._34img_title1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 34, [modelWeather._35img_title2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 35, [modelWeather._36img_title3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 36, [modelWeather._37img_title4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 37, [modelWeather._38img_title5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 38, [modelWeather._39img_title6 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 39, [modelWeather._40img_title7 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 40, [modelWeather._41img_title8 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 41, [modelWeather._42img_title9 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 42, [modelWeather._43img_title10 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 43, [modelWeather._44img_title11 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 44, [modelWeather._45img_title12 UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 45, [modelWeather._46wind1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 46, [modelWeather._47wind2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 47, [modelWeather._48wind3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 48, [modelWeather._49wind4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 49, [modelWeather._50wind5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 50, [modelWeather._51wind6 UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 51, [modelWeather._52fl1 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 52, [modelWeather._53fl2 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 53, [modelWeather._54fl3 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 54, [modelWeather._55fl4 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 55, [modelWeather._56fl5 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 56, [modelWeather._57fl6 UTF8String], -1, SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement, 57, [modelWeather._58index UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 58, [modelWeather._59index_d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 59, [modelWeather._60index48 UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 60, [modelWeather._61index48_d UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 61, [modelWeather._62index_uv UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 62, [modelWeather._63index48_uv UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 63, [modelWeather._64index_xc UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 64, [modelWeather._65index_tr UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 65, [modelWeather._66index_co UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 66, [modelWeather._67index_cl UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 67, [modelWeather._68index_ls UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 68, [modelWeather._69index_ag UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 69, [modelWeather._2cityid UTF8String], -1, SQLITE_TRANSIENT);
            
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
        @catch (NSException *exception) {
            sqlite3_close(_database);
            return NO;
        }
        @finally {
            
        }
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
                ModelWeather* weather = [[ModelWeather alloc] init];
                @try {
                    weather._1city = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                    weather._2cityid = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                    weather._3time = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                    weather._4temp = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                    weather._5WD = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                    weather._6WS = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
                    weather._7SD = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                    weather._8date_y = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
                    weather._9week = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 9)];
                    weather._10temp1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 10)];
                    weather._11temp2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 11)];
                    weather._12temp3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 12)];
                    weather._13temp4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 13)];
                    weather._14temp5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 14)];
                    weather._15temp6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 15)];
                    weather._16weather1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 16)];
                    weather._17weather2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 17)];
                    weather._18weather3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 18)];
                    weather._19weather4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 19)];
                    weather._20weather5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 20)];
                    weather._21weather6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 21)];
                    
                    weather._22img1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 22)];
                    weather._23img2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 23)];
                    weather._24img3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 24)];
                    weather._25img4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 25)];
                    weather._26img5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 26)];
                    weather._27img6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 27)];
                    weather._28img7 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 28)];
                    weather._29img8 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 29)];
                    weather._30img9 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 30)];
                    weather._31img10 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 31)];
                    weather._32img11 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 32)];
                    weather._33img12 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 33)];
                    
                    weather._34img_title1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 34)];
                    weather._35img_title2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 35)];
                    weather._36img_title3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 36)];
                    weather._37img_title4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 37)];
                    weather._38img_title5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 38)];
                    weather._39img_title6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 39)];
                    weather._40img_title7 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 40)];
                    weather._41img_title8 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 41)];
                    weather._42img_title9 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 42)];
                    weather._43img_title10 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 43)];
                    weather._44img_title11 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 44)];
                    weather._45img_title12 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 45)];
                    
                    weather._46wind1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 46)];
                    weather._47wind2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 47)];
                    weather._48wind3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 48)];
                    weather._49wind4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 49)];
                    weather._50wind5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 50)];
                    weather._51wind6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 51)];
                    
                    weather._52fl1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 52)];
                    weather._53fl2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 53)];
                    weather._54fl3 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 54)];
                    weather._55fl4 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 55)];
                    weather._56fl5 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 56)];
                    weather._57fl6 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 57)];
                    
                    weather._58index = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 58)];
                    weather._59index_d = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 59)];
                    weather._60index48 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 60)];
                    weather._61index48_d = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 61)];
                    
                    weather._62index_uv = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 62)];
                    weather._63index48_uv = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 63)];
                    weather._64index_xc = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 64)];
                    weather._65index_tr = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 65)];
                    weather._66index_co = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 66)];
                    weather._67index_cl = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 67)];
                    weather._68index_ls = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 68)];
                    weather._69index_ag = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 69)];
                    
                    [array addObject:weather];
                }
                @catch (NSException *exception) {
                    NSLog(@"查询天气列表出错，错误信息：");
                    NSLog(@"exception.name= %@" ,exception.name);
                    NSLog(@"exception.reason= %@" ,exception.reason);
                }
                @finally {
                    
                }
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(_database);
	}
	return array;
}

- (void)sortWeatherModelArray:(NSMutableArray *)cityArray
{
    NSMutableArray *modelWeatherArray = [self getWeatherModelArray];
    
    BOOL flag = NO;
    @try {
        if ([self openDB]) {
            sqlite3_stmt *statement;
            //组织SQL语句
            static char *sql = "delete from weatherTable";
            //将SQL语句放入sqlite3_stmt中
            int success = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
            if (success != SQLITE_OK) {
                NSLog(@"Error: failed to delete:weatherTable");
                sqlite3_close(_database);
            }
            //执行SQL语句。这里是更新数据库
            success = sqlite3_step(statement);
            //释放statement
            sqlite3_finalize(statement);
            //如果执行失败
            if (success == SQLITE_ERROR) {
                NSLog(@"Error: failed to delete the database with message.");
                //关闭数据库
                sqlite3_close(_database);
            }
            //执行成功后依然要关闭数据库
            sqlite3_close(_database);
            flag = YES;
        }
    }
    @catch (NSException *exception) {
        flag = NO;
        NSLog(@"删除天气列表出错，错误信息：");
        NSLog(@"exception.name= %@" ,exception.name);
        NSLog(@"exception.reason= %@" ,exception.reason);
    }
    @finally {
        
    }
    
    if (flag) {
        for (int i=0; i<[cityArray count]; i++) {
            City *city = [cityArray objectAtIndex:i];
            for (int j=0; j<[modelWeatherArray count]; j++) {
                ModelWeather *weather=((ModelWeather *)[modelWeatherArray objectAtIndex:j]);
                if ([city.searchCode isEqualToString:weather._2cityid]) {
                    [self insertModel:weather];
                    break;
                }
            }
        }
    }
}

@end
