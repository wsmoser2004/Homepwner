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
#import "DetailViewController.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Homepwner"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
         
//        for (int i = 0; i < 5; i++)
//        {
//            [[BNRItemStore sharedStore] createItem];
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
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
//        [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    
//    if (!cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:@"UITableViewCell"];
//    }
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
//    [[cell textLabel] setText:[p description]];
    
    // Get the new or recycled cell
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    // Configure the cell with the BNRItem
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%d", [p valueInDollars]]];
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    return cell;
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    DetailViewController *detailViewController =
        [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController =
        [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
//    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *store = [BNRItemStore sharedStore];
        NSArray *items = [store allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [store removeItem:p];
        [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:(int)[sourceIndexPath row]
                                        toIndex:(int)[destinationIndexPath row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selected = [items objectAtIndex:[indexPath row]];
    
    detailViewController.item = selected;
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    NSLog(@"Going to show the image for %@", ip);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // Get the item for the index path
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
        NSString *imageKey = [i imageKey];
        
        // If there is no image, we dont' need to display anything
        UIImage *img = [[BNRImageStore sharedStore] imageForKey:imageKey];
        if (!img)
            return;
        
        // Make a rectangel that the frame of the button relative to our table view
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        
        // Create a new ImageViewController and set its image
        ImageViewController *ivc = [[ImageViewController alloc] init];
        [ivc setImage:img];
        
        // Present a 600x600 popover from the rect
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
        [imagePopover presentPopoverFromRect:rect
                                      inView:[self view]
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}

@end
