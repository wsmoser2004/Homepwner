//
//  DetailViewController.m
//  Homepwner
//
//  Created by Moser, Wesley on 2/17/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize dismissBlock;

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self)
    {
        if (isNew)
        {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(save:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                       target:self
                                       action:@selector(cancel:)];
        [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:item];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        clr = [UIColor colorWithRed:.875 green:.88 blue:.91 alpha:1];
    }
    else
    {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:clr];
    [self.nameField setDelegate:self];
    [self.serialField setDelegate:self];
    [self.valueField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nameField setText:[item itemName]];
    [self.serialField setText:[item serialNumber]];
    [self.valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    NSString *imageKey = item.imageKey;
    if (imageKey)
    {
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        [self.imageView setImage:imageToDisplay];
    }
    else
    {
        [self.imageView setImage:nil];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [self.dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
    item.itemName = [self.nameField text];
    item.serialNumber = [self.serialField text];
    item.valueInDollars = [[self.valueField text] intValue];
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (IBAction)takePicture:(id)sender
{
    if ([imagePickerPopover isPopoverVisible])
    {
        // If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    if ([UIImagePickerController
            isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller; sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    }
    else
    {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (IBAction)clearPicture:(id)sender
{
    [[BNRImageStore sharedStore]deleteImageForKey:item.imageKey];
    [[self imageView] setImage:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (item.imageKey)
        [[BNRImageStore sharedStore] deleteImageForKey:item.imageKey];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *key = (__bridge NSString *)newUniqueIDString;
    item.imageKey = key;
    [[BNRImageStore sharedStore] setImage:image forKey:item.imageKey];
    
    [[self imageView] setImage:image];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // If on the phone, the image picker is presented modaly. Dismiss it.
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        // If on the pad, the image picker is in the popover. Dismiss the popover.
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
