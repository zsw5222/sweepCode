//
//  SweepViewController.m
//  sweepCode
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 L. All rights reserved.
//

#import "SweepViewController.h"
#import "WjlQRView.h"
 
 
@interface SweepViewController ()
{
    NSTimer *_timer;
    BOOL down;
}

@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureDevice *device;
@property(nonatomic,strong)AVCaptureDeviceInput *input;
@property(nonatomic,strong)AVCaptureMetadataOutput *output;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property(nonatomic,strong)UIImageView *imgView;//扫描框
@property(nonatomic,strong)UIButton *line;// 扫描线

@end

@implementation SweepViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //手势 退出扫描
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [self.view addGestureRecognizer:tapges];
    //设置扫描框和提示
    [self setSweepBoxAndTipLine];
    //初始化往下扫描
    down = YES;
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(lineMove) userInfo:nil repeats:YES];
    [_timer fire];
}
- (void)lineMove{
    
    CGPoint imgP = self.imgView.frame.origin;
    CGPoint center = self.line.center;
    if ( down == YES ) {
        center.y += 20;
        self.line.center = center;
        if (center.y >= imgP.y+self.imgView.frame.size.height-1) {
            down = NO;
        }
      
    }else{
        center.y = self.imgView.frame.origin.y;
        self.line.center = center;
         down = YES;
        
    }
}
- (void)setSweepBoxAndTipLine{
    CGSize size = self.view.frame.size;
    //扫描框
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pick_bg"]];
    imgView.center = CGPointMake(size.width/2,200);
    imgView.bounds = CGRectMake(0, 0, 220, 220);
    
    
    //半透明的遮罩
    WjlQRView *maskView = [[WjlQRView alloc]init];
    maskView.frame = self.view.bounds;
    maskView.clearRect = imgView.frame;
    [self.view addSubview:maskView];
    
    [self.view addSubview:imgView];
    self.imgView = imgView;
    //提示
    UILabel *tipLab = [[UILabel alloc]init];
    tipLab.text = @"将二维码图像置于矩形方框内,系统会自动识别";
    tipLab.frame =CGRectMake(imgView.frame.origin.x, self.imgView.frame.size.height+self.imgView.frame.origin.y+5, 220, 40);
    tipLab.adjustsFontSizeToFitWidth = YES;
    tipLab.numberOfLines = 2;
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.textColor = [UIColor blueColor];
    [self.view addSubview:tipLab];
    //扫描线
    UIButton *line = [[UIButton alloc]init];
    line.enabled = NO;
    UIImage *img = [UIImage imageNamed:@"line"];
//     img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(110, 20, 0.5, 0.5)];
    line.frame = CGRectMake(self.imgView.frame.origin.x, self.imgView.frame.origin.y, self.imgView.frame.size.width, 2);
    [line setImage: img forState:UIControlStateNormal];
    
    [self.view addSubview:line];
    self.line = line;
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [self setUpCamera];
}
- (void)setUpCamera{
     CGSize size = self.view.frame.size;
    //device
    _device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    //input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    //output
    _output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理
   [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描范围
 
    _output.rectOfInterest = CGRectMake( self.imgView.frame.origin.y/size.height,self.imgView.frame.origin.x/size.width,self.imgView.frame.size.height/size.height,self.imgView.frame.size.width/size.width);
    
    //session
    _session = [[AVCaptureSession alloc]init];
    [ _session setSessionPreset:AVCaptureSessionPresetHigh];
    //添加输入流
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }else{
        return;
    }
    //添加输出流
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }else{
        return;
    }
    
    [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //preview扫描图层
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
 
    [self.view.layer insertSublayer:_preview atIndex:0];
  
    //开始
    [_session startRunning];
}
#pragma mark - 实现AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
  
    
    NSString *stringValue;
    if ([metadataObjects count]>0) {
        AVMetadataMachineReadableCodeObject *metaData =  [metadataObjects objectAtIndex:0];
        stringValue = metaData.stringValue;
    }
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"扫到了" message:stringValue preferredStyle:UIAlertControllerStyleAlert ];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alter addAction:action];
    [self presentViewController:alter animated:YES completion:nil];
    
    [_session stopRunning];
    [_timer invalidate];
   
   
}














@end
