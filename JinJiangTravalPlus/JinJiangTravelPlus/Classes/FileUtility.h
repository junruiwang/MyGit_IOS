//
//  FileUtility.h
//  GLImageProcessing
//
//  Created by 吕 硕 on 11-12-6.  谢谢 范建峰
//  Copyright (c) 2011年 吕 硕. All rights reserved.
//

#ifndef GLImageProcessing_FileUtility_h
#define GLImageProcessing_FileUtility_h

/*	
 this is a utility tool about manipulating file 
 */


/*
 get the basic file about current user, the path  in the simulator would be 
 /Users/xxx/Library/Application Support/iPhone Simulator/xxxx/Applications/xxxxx/Documents
 */
static inline NSString *kGetBasicFilePath()
{	
	NSArray *pahts = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
	NSString *document = [pahts objectAtIndex:0];
	return document;
}

static inline NSString *kGetOverAllFilePath(NSString *path, NSString *file)
{	
	return [path stringByAppendingPathComponent:file];
}

/*
 get the string about a passing filename at the basis diectory
 */
static inline NSString *kGetFilePath(NSString *fileName)
{	
	NSString *document = kGetBasicFilePath();
	return [document stringByAppendingPathComponent:fileName];
}

/*
 create file at a giving path 
 path which you want to create a file 
 fileName that you want to create a file named 
 overlay that detecting whethe you want to overlay the exsit file named fileName
 */
static inline bool kCreateNewFileInPath(NSString *path, NSString *fileName, bool overlay)
{	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager changeCurrentDirectoryPath:path];

	NSError *error;

	if([fileManager fileExistsAtPath:fileName] && overlay)
    {
		[fileManager removeItemAtPath:fileName error:&error];
	}

	return [fileManager createFileAtPath:fileName contents:NULL attributes:NULL];
}

/*
 create file at the basis path, and overlay detecting whethe overlay the exsit file
 */
static inline bool kCreateNewFileInBasisPath(NSString *fileName, bool overlay)
{
	NSString *path = kGetBasicFilePath();
	return kCreateNewFileInPath(path, fileName, overlay);
}

/*
 create directory at a giving path 
 path which you want to create a directory 
 fileName that you want to create a directory named 
 overlay that detecting whethe you want to overlay the exsit directory named fileName
 */
static inline bool kCreateNewDirectoryInPath(NSString *path, NSString *directory, bool overlay)
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager changeCurrentDirectoryPath:path];

	NSError *error;

	if([fileManager fileExistsAtPath:directory] && overlay)
    {
		[fileManager removeItemAtPath:directory error:&error];
	}

	return [fileManager createDirectoryAtPath:directory withIntermediateDirectories:true attributes:NULL error:&error];
}

static inline bool kCreateNewDirectoryInBasisPath(NSString *directory, bool overlay)
{
	NSString *path = kGetBasicFilePath();
	return kCreateNewDirectoryInPath(path, directory, overlay);
}

/*
 remove all the items in the Directory (all Links, Files, subDirectorys and so on)
 remove the file
 remove the Link
 the delegate that you can set in order to NSFilemanager would send message to,	
 
 when befor removing, the message 
 - (BOOL)fileManager:(NSFileManager *)fileManager 
 shouldMoveItemAtPath:(NSString *)srcPath 
 toPath:(NSString *)dstPath   would send to delegate
 
 when error arriving, the message 
 - (BOOL)fileManager:(NSFileManager *)fileManager 
 shouldProceedAfterError:(NSError *)error 
 movingItemAtPath:(NSString *)srcPath 
 toPath:(NSString *)dstPath  would send to delegate
 
 and etd.
 */

static inline bool kRemoveAllItemAtPath(id delegate, NSString *path, NSString *directory)
{
	if(!path || !directory)
    {
		return true;
	}

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *removePath = [path stringByAppendingPathComponent:directory];

	NSError *error;
	return [fileManager removeItemAtPath:removePath error:&error];
}

static inline bool kRemoveAllItemAtBasisPath(id delegate, NSString *directory)
{
	NSString *path = kGetBasicFilePath();
	return kRemoveAllItemAtPath(delegate, path, directory);
}

/*
 get the size of file
 */

static inline size_t kGetAtPathFileSize(NSString *path, NSString *file)
{
	NSString *filePath = kGetOverAllFilePath(path, file);
	NSError *error;
	NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMapped error:&error];
	if(!data)
    {
		return 0;
	}
	return [data length];
}

static inline size_t kGetAtBasisPathFileSize(NSString *file)
{
	NSString *path = kGetBasicFilePath();
	return kGetAtPathFileSize(path, file);
}

/*
 find the file or directory whethe at path
 */
static inline bool kFindItemAtPath(NSString *path, NSString *item)
{
	if(!item || !path)
    {
		return false;
	}

	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager changeCurrentDirectoryPath:path];

	return [fileManager fileExistsAtPath:item];
}

static inline bool kFindItemAtBasisPath(NSString *item)
{
	NSString *path = kGetBasicFilePath();
	return kFindItemAtPath(path, item);
}

static inline NSString* kCopyItemToNewPath(NSString *path, NSString *item, bool *success)
{
	*success = false;
	if(!item)
    {
		return NULL;
	}
	NSArray *paths = [item componentsSeparatedByString:@"."];
	if(!paths)
    {
		return NULL;
	}

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	kCreateNewDirectoryInBasisPath(path, false);
	NSString *writableDBPath = [kGetFilePath(path) stringByAppendingPathComponent:item];
#if kTestConnectServer
	printf(" file path ===== %s \n", [writableDBPath UTF8String]);
#endif
	if ([fileManager fileExistsAtPath:writableDBPath] == false)
    {
		NSString *defaultDBPath = NULL;
		if([paths count] == 2)
        {
			defaultDBPath = [[NSBundle mainBundle] pathForResource:[paths objectAtIndex:0] ofType:[paths objectAtIndex:1]];
			*success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		}
		else
        {
			*success = kCreateNewFileInPath(kGetFilePath(path), item, false);
		}
	}
	return writableDBPath;
}

#endif
