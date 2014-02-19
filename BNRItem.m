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
//    return [NSString stringWithFormat:@"%@ $%d %@", [self itemName], [self valueInDollars], [self serialNumber]];
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
    //BNRItem *newItem = [[self alloc] initWithItemName:randomName
    //                                     serialNumber:randomSerialNumber];
    
    return newItem;
}

@end
