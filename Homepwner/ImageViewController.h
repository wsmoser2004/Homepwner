//
//  ImageViewController.h
//  Homepwner
//
//  Created by Moser, Wesley on 3/28/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) UIImage *image;

@end
