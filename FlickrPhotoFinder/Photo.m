//
//  Photo.m
//  FlickrPhotoFinder
//
//  Created by Lomtev on 25.04.2019.
//  Copyright © 2019 Александр Ломтев. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithPhotoUrl:(NSString *)url andData:(NSData *)data
{
    self = [super init];
    if(self)
    {
        _photoUrl = url;
        _photoData = data;
    }
    return self;
}



@end
