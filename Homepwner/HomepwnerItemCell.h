//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Moser, Wesley on 3/26/14.
//  Copyright (c) 2014 Moser, Wesley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepwnerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

- (IBAction)showImage:(id)sender;

@end
