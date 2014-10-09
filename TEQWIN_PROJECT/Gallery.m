//
//  Gallery.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 16/9/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
#import "MBProgressHUD.h"
#import "GalleryCell.h"
#import "Gallery.h"
#import "Tattoo_Detail_ViewController.h"
#import "TattooMasterCell.h"
#import "SWRevealViewController.h"
#import "CFShareCircleView.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
@interface Gallery ()<UIScrollViewDelegate,CFShareCircleViewDelegate>
{
    TattooMasterCell *tattoomasterCell;
CFShareCircleView *shareCircleView;
    CGRect frame_first;
    UIImageView *fullImageView;
     int lastClickedRow;
}
@end

@implementation Gallery
@synthesize tableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
   

    [self queryParseMethod];
    
    
    self.title=@"作品庫";
    self.tableView.bounces=NO;
    // Create array object and assign it to _feedItems variable
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationController.navigationBar.translucent = NO;
    shareCircleView = [[CFShareCircleView alloc] initWithFrame:self.view.frame];
    shareCircleView.delegate = self;
    [self.navigationController.view addSubview:shareCircleView];
    }

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)queryParseMethod {
    NSLog(@"start query");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];

    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"Master_id" equalTo:self.tattoomasterCell.master_id];
     query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
            if (imageFilesArray.count==0) {
                [self noimage];
                
            }
                        [tableView reloadData];
            [hud hide:YES];
            NSLog(@"%d",imageFilesArray.count);
            
       
        }
        
    }];
    
}
#pragma mark - Table view data source
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
//    if([button isEqualToString:@"OK"])
        
//    {
//        Tattoo_Detail_ViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
//        [self.navigationController pushViewController:galleryVC animated:YES];
//        galleryVC.tattoomasterCell=_tattoomasterCell;
//        ;

        
//    }}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageFilesArray count];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", imageFilesArray);
}
- (void) noimage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"對不起" message:@"沒有照片" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *CellIdentifier = @"parallaxCell";
    GalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    
    PFFile *imageFile = [imageObject objectForKey:@"image"];

    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
      cell.image.image = [UIImage imageNamed:@"loading_image.gif"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.image.layer.borderWidth=2.0;
         cell.image.layer.masksToBounds = YES;
         cell.image.layer.borderColor=[[UIColor whiteColor] CGColor];
            cell.image.image = [UIImage imageWithData:data];
        [cell.loadingSpinner stopAnimating];
        cell.loadingSpinner.hidden = YES;
    }];
     cell.image.tag=9999;
    cell.image.userInteractionEnabled=YES;
    [ cell.image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
   
        return cell;
}

//按圖第一下放大至fullscreen
-(void)actionTap:(UITapGestureRecognizer *)sender{
    
    
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath  = [self.tableView indexPathForRowAtPoint:location];
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableView  cellForRowAtIndexPath:indexPath];
    
    
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:9999];
    
    
    frame_first=CGRectMake(cell.frame.origin.x+imageView.frame.origin.x, cell.frame.origin.y+imageView.frame.origin.y-self.tableView.contentOffset.y, imageView.frame.size.width, imageView.frame.size.height);
    
    fullImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    fullImageView.backgroundColor=[UIColor blackColor];
    fullImageView.userInteractionEnabled=YES;
    [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
    fullImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    if (![fullImageView superview]) {
        
        fullImageView.image=imageView.image;
        
        [self.view.window addSubview:fullImageView];
        
        
        
        fullImageView.frame=frame_first;
        [UIView animateWithDuration:0.5 animations:^{
            
            fullImageView.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
            
            
        } completion:^(BOOL finished) {
            
            [UIApplication sharedApplication].statusBarHidden=YES;
            
        }];
        
    }
    
}
////按圖第二下縮回原型
-(void)actionTap2:(UITapGestureRecognizer *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        fullImageView.frame=frame_first;
        
    } completion:^(BOOL finished) {
        
        [fullImageView removeFromSuperview];
        
    }];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    
}





- (IBAction)btn_share:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint =
    [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
    
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    
   shareimageFile = [imageObject objectForKey:@"image"];

  
   
    lastClickedRow = indexPath.row;
    [shareCircleView show];
    
}

- (IBAction)like:(id)sender {
    FBLikeControl * like =[[FBLikeControl alloc]init];
    like.objectID = @"http://shareitexampleapp.parseapp.com/photo1/";
    
}


- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer{
   
    if ([sharer.name isEqual:@"Facebook"]) {
        
        // Check if the Facebook app is installed and we can present the share dialog
        FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
        params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentShareDialogWithParams:params]) {
            
            // Present share dialog
            [FBDialogs presentShareDialogWithLink:params.link
                                          handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                              if(error) {
                                                  // An error occurred, we need to handle the error
                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                  NSLog(@"Error publishing story: %@", error.description);
                                              } else {
                                                  // Success
                                                  NSLog(@"result %@", results);
                                              }
                                          }];
            
            // If the Facebook app is NOT installed and we can't present the share dialog
        } else {
            // FALLBACK: publish just a link using the Feed dialog
            
            // Put together the dialog parameters
           // NSString *picURLstring =
            //[NSString stringWithFormat:@"http://files.parsetfss.com/c6afcb1f-6a07-4487-8d0d-8406c9b9f69c/tfss-0366ca1a-894e-45c2-b43b-f45b82d10f6a-gallery_02_5.jpg"] ;
            
            
            
            
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           self.tattoomasterCell.name, @"name",
                                           @"TEQWIN SOLUTION", @"caption",
                                           @"作品", @"description",
                                           shareimageFile.url, @"link",
                                           shareimageFile.url,@"picture",
                                           nil];
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // An error occurred, we need to handle the error
                                                              // See: https://developers.facebook.com/docs/ios/errors
                                                              NSLog(@"Error publishing story: %@", error.description);
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                      
                                                                  } else {
                                                                      // User clicked the Share button
                                                                      NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"result %@", result);
                                                                  }
                                                              }
                                                          }
                                                      }];
        }}
    if ([sharer.name isEqual:@"Twitter"]) {
        // 判斷社群網站的服務是否可用
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            // 建立對應社群網站的ComposeViewController
            SLComposeViewController *mySocialComposeView = [[SLComposeViewController alloc] init];
            mySocialComposeView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            // 插入文字
            [mySocialComposeView setInitialText:self.tattoomasterCell.name];
            
            // 插入網址
            // NSURL *myURL = [[NSURL alloc] initWithString:@"http://cg2010studio.wordpress.com/"];
            // [mySocialComposeView addURL: myURL];
            
            // 插入圖片
            
            NSString *picURLstring = [NSString stringWithFormat:@"https://localhost:443/phpMyAdmin/fyp_php/gallery_0%@_%d.jpg",[self.tattoomasterCell valueForKey:@"master_id"],lastClickedRow+1] ;
            
            NSURL *picURL = [NSURL URLWithString:picURLstring] ;
            
            UIImage *Slide = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:picURL]];
            
            UIImage *myImage = Slide;
            [mySocialComposeView addImage:myImage];
            
            
            // 呼叫建立的SocialComposeView
            [self presentViewController:mySocialComposeView animated:YES completion:^{
                NSLog(@"成功呼叫 SocialComposeView");
            }];
            
            // 訊息成功送出與否的之後處理
            [mySocialComposeView setCompletionHandler:^(SLComposeViewControllerResult result){
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"取消送出");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"完成送出");
                        break;
                    default:
                        NSLog(@"其他例外");
                        break;
                }
            }];
        }
        else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"請先在系統設定中登入推特帳號。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [av show];
        }
        
    }
    if ([sharer.name isEqual:@"Whatsapp"]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"]; //here i am fetched image path from document directory and convert it in to URL and use bellow
        
        
        NSURL *imageFileURL =[NSURL fileURLWithPath:getImagePath];
        NSLog(@"imag %@",imageFileURL);
        
        self.documentationInteractionController.delegate = self;
        self.documentationInteractionController.UTI = @"net.whatsapp.image";
        self.documentationInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
        [self.documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        
        
    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL

                                               usingDelegate: (id ) interactionDelegate {
    
    
    
    self.documentationInteractionController =
    
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    
    self.documentationInteractionController.delegate = interactionDelegate;
    
    
    
    return self.documentationInteractionController;
    
}- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
