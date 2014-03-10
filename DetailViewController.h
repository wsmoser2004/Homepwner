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
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
}

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) BNRItem *item;

- (IBAction)takePicture:(id)sender;
- (IBAction)clearPicture:(id)sender;

@end
