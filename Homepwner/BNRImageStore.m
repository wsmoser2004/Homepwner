//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Moser, Wesley on 2/19/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore *)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setImage:(UIImage *)img forKey:(NSString *)key
{
    [dictionary setObject:img forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key)
        return;
    
    [dictionary removeObjectForKey:key];
}


@end
