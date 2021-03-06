//
//  DetailViewController.h
//  Homepwner
//
//  Created by Moser, Wesley on 2/17/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRImageStore.h"

@class BNRItem;

@interface DetailViewController : UIViewController
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *imagePickerPopover;
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *assetTypeButton;

@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, strong) BNRItem *item;

- (id)initForNewItem:(BOOL)isNew;
- (IBAction)takePicture:(id)sender;
- (IBAction)clearPicture:(id)sender;
- (IBAction)showAssetTypePicker:(id)sender;

@end
