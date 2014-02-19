//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Moser, Wesley on 1/22/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
{
    NSString *itemName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
}

@property (nonatomic, copy) NSString *imageKey;

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;
- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *) sNumber;

- (NSString *) itemName;
- (void) setItemName:(NSString *)str;

- (NSString *) serialNumber;
- (void) setSerialNumber:(NSString *)str;

- (int) valueInDollars;
- (void) setValueInDollars:(int)val;

- (NSDate *) dateCreated;
- (void) setDateCreated:(NSDate *)date;

+ (id) randomItem;


@end
