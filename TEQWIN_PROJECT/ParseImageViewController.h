//
//  ParseImageViewController.h
//  ParseExample
//
//  Created by Nick Barrowclough on 7/25/13.
//  Copyright (c) 2013 Nicholas Barrowclough. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageExampleCell.h"
#import <Parse/Parse.h>
#import "TattooMasterCell.h"
#import "Tattoo_Detail_ViewController.h"
@interface ParseImageViewController : UIViewController {
    
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;


@property (nonatomic, strong) TattooMasterCell *tattoomasterCell;
@end
