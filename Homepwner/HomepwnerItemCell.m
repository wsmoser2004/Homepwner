//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Moser, Wesley on 3/26/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell
@synthesize controller;
@synthesize tableView;

- (IBAction)showImage:(id)sender
{
    // Get this name of this method, "showimage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    
    if (indexPath)
    {
        if ([[self controller] respondsToSelector:newSelector])
        {
            // Ignore warning for this line - may or may not appear, doesn't matter
            [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}
@end
