//
//  ViewController.m
//  Receiver
//
//  Created by Grzegorz Krukiewicz-Gacek on 8/1/13.
//  Copyright (c) 2013 Estimote, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CoreBluetoothDelegate>

@property (nonatomic, strong) CoreBluetoothController *bluetoothController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _kurwinox = [[UIImageView alloc] initWithFrame:CGRectMake(320, 450, 0, 0)];
    _kurwinox.image = [UIImage imageNamed:@"kurwinox.png"];
    [self.view addSubview:_kurwinox];
    
    _skurwol = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    _skurwol.center = CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height / 2);
    _skurwol.image = [UIImage imageNamed:@"skurwol.png"];
    [self.view addSubview:_skurwol];
    _blow1 = [UIImageView new];
    _blow1.image = [UIImage imageNamed:@"wybuch.png"];
    [self.view addSubview:_blow1];
    
    _blow2 = [UIImageView new];
    _blow2.image = [UIImage imageNamed:@"wybuch.png"];
    [self.view addSubview:_blow2];
    
    _blow3 = [UIImageView new];
    _blow3.image = [UIImage imageNamed:@"wybuch.png"];
    [self.view addSubview:_blow3];
    
    _bluetoothController = [CoreBluetoothController sharedInstance];
    _bluetoothController.delegate = self;
    /*if (!_bluetoothController.isConnected)
        [_bluetoothController findPeripherals];*/
    
    [_bluetoothController startReadingRSSI];
}

#pragma mark - CoreBluetooth delegate methods

- (void)didUpdateRSSI:(int)RSSI
{
    if (RSSI < 0 && RSSI > -50) {
        [self skurwolImmediate];
    }
    else if (RSSI <= -50 && RSSI >= -80) {
        [self skurwolNear];
    }
    else if (RSSI < -80) {
        [self skurwolFar];
    }
    else {
        // chuj
    }
}

#pragma mark - bomba

- (void)skurwolFar
{
    CGRect newRect = CGRectMake(self.view.frame.size.width / 2 - 60, self.view.frame.size.height / 2 - 50, 120, 100);
    
    [UIView animateWithDuration:1 animations:^{
        
        _skurwol.frame = newRect;
        
        
    }];
}

- (void)skurwolNear
{
    CGRect kurwinoxRect = CGRectMake(400, 300, 50, 50);
    
    CGRect newRect = CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 80, 200, 160);
    [UIView animateWithDuration:1 animations:^{
        
        _skurwol.frame = newRect;
        _kurwinox.frame = kurwinoxRect;
    }];
    
}

- (void)skurwolImmediate
{
    CGRect kurwinoxRect = CGRectMake(300, 200, 100, 100);
    
    CGRect newRect = CGRectMake(self.view.frame.size.width / 2 - 150, self.view.frame.size.height / 2 - 120, 300, 240);
    [UIView animateWithDuration:1 animations:^{
        
        _skurwol.frame = newRect;
        _kurwinox.frame = kurwinoxRect;
    }];
    
    [self performSelector:@selector(skurwolBlow)];
}

- (void)skurwolBlow
{
    
    
    
    [UIView animateWithDuration:1 animations:^{
        
        _blow1.frame = CGRectMake(80, 80, 200, 200);
        
        
        
    }];
    
    [UIView animateWithDuration:1.5 animations:^{
        
        _blow2.frame = CGRectMake(150, 130, 200, 200);
        
        
    }];
    
    [UIView animateWithDuration:2 animations:^{
        
        _blow3.frame = CGRectMake(60, 200, 200, 200);
        
        
    }];
    
    [self performSelector:@selector(afterNapierdalamy) withObject:nil afterDelay:2.3];
}

- (void)afterNapierdalamy
{
    _skurwol.hidden = YES;
    _blow1.hidden = YES;
    _blow2.hidden = YES;
    _blow3.hidden = YES;
    _kurwinox.hidden = YES;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UILabel *napierdalamyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 50)];
    // [napierdalamyLabel setBackgroundColor:[UIColor blackColor]];
    [napierdalamyLabel setTextColor:[UIColor whiteColor]];
    [napierdalamyLabel setText:[NSString stringWithFormat:@"NAPIERDALAĆ!!!!!"]];
    [napierdalamyLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [napierdalamyLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:napierdalamyLabel];
    
    UILabel *paulo = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 300, 50)];
    // [paulo setBackgroundColor:[UIColor blackColor]];
    [paulo setText:[NSString stringWithFormat:@"-Paulo Coelho"]];
    [paulo setTextColor:[UIColor whiteColor]];
    [paulo setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:paulo];
    
    [self performSelector:@selector(kill) withObject:nil afterDelay:2];
}

- (void)kill
{
    exit(1);
}

@end
