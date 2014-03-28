//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Moser, Wesley on 1/22/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize imageKey;
@synthesize thumbnail, thumbnailData;

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    self = [super init];
    
    if (self)
    {
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:0];
        dateCreated = [[NSDate alloc] init];
    }
    
    return self;
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *) sNumber
{
    self = [super init];
    
    if (self)
    {
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    
    return self;
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"%@", [self itemName]];
}

- (NSString *) itemName
{
    return itemName;
}

- (void) setItemName:(NSString *)str
{
    itemName = str;
}

- (NSString *) serialNumber
{
    return serialNumber;
}

- (void) setSerialNumber:(NSString *)str
{
    serialNumber = str;
}

- (int) valueInDollars
{
    return valueInDollars;
}

- (void) setValueInDollars:(int)val
{
    valueInDollars = val;
}

- (NSDate *) dateCreated
{
    return dateCreated;
}

- (void) setDateCreated:(NSDate *)date
{
    dateCreated = date;
}

+ (id) randomItem
{
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy", @"Rusty", @"Shiny", nil];
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Mac", nil];
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    
    return newItem;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        self.imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        self.valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        self.dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        self.thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

- (UIImage *)thumbnail
{
    // If there is no thumbnailData, then I have no thumbnail to return
    if (!thumbnailData)
    {
        return nil;
    }
    
    if (!thumbnail)
    {
        // Create the image from the data
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    [image drawInRect:projectRect];
    
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
}

@end
