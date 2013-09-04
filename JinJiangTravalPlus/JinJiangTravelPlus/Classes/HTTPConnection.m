//
//  HTTPConnection.m
//  chengguo
//
//  Created by Jeff.Yan on 11-5-14.
//  Copyright 2011年 W+K. All rights reserved.
//

#import "HTTPConnection.h"

@implementation HTTPConnection

@synthesize delegate,requestType;
/*!
 *    @override
 *    @return object
 */
- (id)init
{
    self = [super init];
    if (self!=nil) {
        _isHTTPResponseOK = NO;
    }
    return self;
}

/*!
 *  @override
 *  @param connection
 *  @param response
 *  @return null
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //convert to HTTP response
    NSHTTPURLResponse * responseHTTP = (NSHTTPURLResponse *)response;
    if (([responseHTTP statusCode] / 100) != 2){    //if HTTP response error
        _isHTTPResponseOK = NO;
        
    }else{      //if HTTP response ok
        _isHTTPResponseOK = YES;
        
    }
}
- (void)cancelDownload
{
    
    if(_receivedData!=nil){
        
        _receivedData=nil;
    }
    
    if(_connection!=nil){
        [_connection cancel];
        _connection=nil;
    }
    
}


/*!
 *    @override
 *  @param connection
 *  @param error
 *  @return null
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //[connection release];
    [self postHTTPError];
    
}

/*!
 *    @override
 *  @param connection
 *  @param data
 *  @return null
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //join the data
   
    if(_receivedData!=nil)
     [_receivedData appendData:data];
 
}

/*!
 *  @override
 *  @param connection
 *  @return null
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[connection release];
    if (_isHTTPResponseOK) {        
 
        [self postExtracted];

    }else {
        [self postHTTPError];

    }
    

}

-(void)uploadImage:(NSString *)url imageData:(NSData *)imageData{
    //UIImageJPEGRepresentation(image.image, 90)
	//NSData *imageData = UIImageJPEGRepresentation(image.image, 90);
	// setting up the URL to post to
	//NSString *urlString = @"http://127.0.0.1/app-test/test-upload.php";
    
	// setting up the request object now
    //NSLog(@"url::::::%@",url);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
    
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
     
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
     */
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	/*
	 now lets create the body of the post
     */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
    
	// now lets make the connection to the web
    if(_receivedData!=nil){
        _receivedData=nil;
    }
    _receivedData=[[NSMutableData alloc] init];
    
    _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	//NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	//NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
	//NSLog(@"returnString:::%@",returnString);
}
- (void)loadImage:(NSString *)url type:(NSString *)_type{
   
    self.requestType =_type;// [_type retain];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    
     
    
    if(_receivedData!=nil){
        _receivedData=nil;
    }
    
    if(_connection!=nil){
        _connection=nil;
    }
    _receivedData=[[NSMutableData alloc] init];
    
    _connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //NSLog(@"loadImage_url::::::::::::::::::::%@:::%@::%@",request,url,[NSURL URLWithString:url]);
    
   // [request release];
    
    //[_connection release];
    
}


/*!
 *  send a request type A
 *  @return null
 */
//[token URLEncodedString];
- (void)sendRequest:(NSString *)url postData:(NSMutableDictionary *)_postData type:(NSString *)_type
{
    
    //NSString * url = @"http://";
    //create a request
   
    @autoreleasepool {
    
        NSMutableString *post = [NSMutableString stringWithFormat:@""]; 
        [post appendString:url];
   
        if(_postData){
             [post appendString:@"?"];
            for (NSString *key in _postData) {
                //NSLog(@"::%@:%@",key,[_postData objectForKey:key]);
                [post appendString:key];
                [post appendString:@"="];
            
                [post appendString:[[_postData objectForKey:key] URLEncodedString]];
                [post appendString:@"&"];
            }
        }
        
        /*
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
        
         NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        //[request setHTTPMethod:@"GET"]; 
        [request setHTTPMethod:@"POST"]; 
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
        [request setHTTPBody:postData];  
         
         NSMutableString *ns=[NSMutableString stringWithFormat:@""];
         [ns appendString:url];
         [ns appendString:@"?"];
         for(NSString *str in _postData){
         [ns appendString:[NSString stringWithFormat:@"%@=%@&",str,[_postData objectForKey:str]]]; 
         }
         
  */
   
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[post stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        [request setHTTPMethod:@"GET"]; 
         
        
        self.requestType =_type;

        //NSLog(@"url:::%@",post);
        if(_receivedData!=nil){
            _receivedData=nil;
        }
        
        if(_connection!=nil){
            _connection=nil;
        }
        _receivedData=[[NSMutableData alloc] init];
        
        _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

/*!
 *  extract data for request type A
 *  @return null
 */

/*!
 *  post http error notification
 *  @return null
 */
- (void)postHTTPError
{
    //NSLog(@"postHTTPError");
    if(delegate!=nil){
        [delegate postHTTPError:self];
    }
    if(_receivedData!=nil){
        _receivedData=nil;
    }
    
    if(_connection!=nil){
        _connection=nil;
    }
     self.delegate=nil;
}

/*!
 *  post notification "data for type a extracted"
 *  @return null
 */
- (void)postExtracted
{
    //NSLog(@"postExtracted");
    //NSLog(@"postExtracted::%@", _receivedData);
    if(delegate!=nil){
        [delegate postHTTPDidFinish:_receivedData hc:self];
    }
    if(_receivedData!=nil){
        _receivedData=nil;
    }
    
    if(_connection!=nil){
        _connection=nil;
    }
     self.delegate=nil;
}

/*!
 *  @override
 *  @return null
 */
- (void)dealloc
{

    //NSLog(@"HTTPConnection dealloc");
    if(_receivedData!=nil){
        _receivedData=nil;
    }
    
    if(_connection!=nil){
        _connection=nil;
    }
}

@end
