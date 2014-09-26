//
//  FavGalleryCell.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 12/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavGalleryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;
@end
