//
//  ViewController.m
//  sweepCode
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 L. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeGenerator.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextField *textQR;

@end

@implementation ViewController
- (IBAction)produceQR:(UIButton *)sender {
    self.imgView.image = [QRCodeGenerator qrImageForString:self.textQR.text imageSize:self.imgView.bounds.size.width];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textQR.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sweep:(UIButton *)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textQR resignFirstResponder];
    return YES;
 
}
@end
