//
//  SomeService.m
//  ProtocolsTest
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"
#import "Photo.h"


@interface NetworkService ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation NetworkService

- (void)configureUrlSessionWithParams:(NSDictionary *)params
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Настравиваем Session Configuration
    [sessionConfiguration setAllowsCellularAccess:YES];
    if (params)
    {
        [sessionConfiguration setHTTPAdditionalHeaders:params];//@{ @"Accept" : @"application/json" }];
    }
    else
    {
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    }
    
    // Создаем сессию
    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}

- (void)startImageLoading
{
    if (!self.urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg"]];
    /* http://is1.mzstatic.com/image/thumb/Purple2/v4/91/59/e1/9159e1b3-f67c-6c05-0324-d56f4aee156a/source/100x100bb.jpg */
    [self.downloadTask resume];
}

- (BOOL)resumeNetworkLoading
{
    if (!self.resumeData)
        return NO;
    
    // Восстанавливаем загрузку с учетом уже загруженных данных
    self.downloadTask = [self.urlSession downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    self.resumeData = nil;
    
    return YES;
}

- (void)suspendNetworkLoading
{
    if (!self.downloadTask)
        return;
    
    self.resumeData = nil;
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData)
        {
            return;
        }
        self.resumeData = resumeData;
        [self setDownloadTask:nil];
    }];
}

- (void)findFlickrPhotoWithSearchString:(NSString *)searchSrting
{
    NSString *urlString = [NetworkHelper URLForSearchString:searchSrting];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:30];
    
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //NSMutableArray *urls = nil;
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"%@", [NSString stringWithFormat:@"строка поиска %@", searchSrting]);
        // Для получение деталей по фото
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        // example https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
        NSArray *photos = temp[@"photos"][@"photo"];
        
        //NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:photos.count];
        NSMutableArray<Photo *> *imageDataArray = [[NSMutableArray alloc] initWithCapacity:photos.count];
        
        for(int i=0; i<photos.count; i++)
        {
            NSNumber *farmId = photos[i][@"farm"];
            NSString *serverId = photos[i][@"server"];
            NSString *imageId  = photos[i][@"id"];
            NSString *secret  = photos[i][@"secret"];
        
            NSString *imageUrl = [[NSString alloc] initWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmId, serverId, imageId, secret];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
            
            imageDataArray[i] = [[Photo alloc] initWithPhotoUrl:imageUrl andData:imageData];
            //urls[i] = imageUrl;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.output loadingIsDoneWithDataRecieved:[imageDataArray copy]];
        });
        
        
        /*
         {
         farm = 66;
         id = 32732611187;
         isfamily = 0;
         isfriend = 0;
         ispublic = 1;
         owner = "156700692@N02";
         secret = 8d4b1d25cc;
         server = 65535;
         title = grass;
         }
         
         */
        

    }];
    [sessionDataTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}

@end

