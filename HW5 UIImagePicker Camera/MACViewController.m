//
//  MACViewController.m
//  HW5 UIImagePicker Camera
//
//  Created by Macy Aviles on 11/6/13.
//  Copyright (c) 2013 Macy Aviles. All rights reserved.
//

#import "MACViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MACViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end


//fix storyboard to fit all screen types


@implementation MACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera. Choose only Select Photo option"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerController

- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"Showing Photo Library");
    }];
}


- (IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated: YES completion:^{
        NSLog(@"Showing Camera");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self applyFilterToImage:pickedImage];
        
    }];
}

- (void)applyFilterToImage:(UIImage *)image {

// filter the image
CIContext *context = [CIContext contextWithOptions:nil];

CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];

CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];

[filter setValue:ciImage forKey:kCIInputImageKey];

CIImage *result = [filter valueForKey:kCIOutputImageKey];

CGRect extent = [result extent];

CGImageRef cgImage = [context createCGImage:result fromRect:extent];

UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];

    
// show the image to the user
UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
[imageView setImage:filteredImage];
[self.view addSubview:imageView];
    
    
// round image view
CALayer *imageLayer = imageView.layer;
[imageLayer setCornerRadius:150];
[imageLayer setBorderWidth:1];
[imageLayer setMasksToBounds:YES];

    
// save the image to the photos album
UIImageWriteToSavedPhotosAlbum(filteredImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"User cancelled image selection");
    }];
}

- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *)contextInfo{
    if (error) {
        NSLog(@"Unable to save photo to camera roll");
    } else {
        NSLog(@"Saved Image to Camera Roll");
    }
}
@end
