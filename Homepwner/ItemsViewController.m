//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Moser, Wesley on 2/12/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        for (int i = 0; i < 5; i++)
        {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell =
//    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                           reuseIdentifier:@"UITableViewCell"];
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[p description]];
    return cell;
}

@end
