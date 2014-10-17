//
//  ViewController.m
//  HaidoraSegment
//
//  Created by DaiLingchi on 14-10-17.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "ViewController.h"
#import "HDSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *arr = @[ @"hello", @"English", @"close" ];
    HDSegmentedControl *segment = [[HDSegmentedControl alloc] initWithItems:arr];
    segment.frame = CGRectMake(20, 100, 250, 20);
//	segment.borderWidth = 2;
//	segment.borderColor = [UIColor redColor];
//	segment.backgroundColor = [UIColor grayColor];
//	[segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(test:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test:(HDSegmentedControl *)sender
{
    NSLog(@"%ld", sender.selectedSegmentIndex);
}

@end
