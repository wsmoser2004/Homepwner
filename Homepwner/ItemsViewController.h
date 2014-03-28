//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Moser, Wesley on 2/12/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomepwnerItemCell.h"

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}

- (IBAction)addNewItem:(id)sender;

@end
