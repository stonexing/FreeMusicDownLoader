//
//  ViewController.m
//  FreeMusicDownLoader
//
//  Created by Xingyan on 14-3-11.
//  Copyright (c) 2014年 Xingyan. All rights reserved.
//  stonexing@icloud.com
//

/**************
 
 免费音乐下载器 真机状态下无效 模拟器下正常工作
 FreeMusicDownLoader only work on iOS Simulator
 
 **************/

#import "ViewController.h"
#import "PBWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //redirect NSLog
    //[self redirectSTD:STDOUT_FILENO];
    [self redirectSTD:STDERR_FILENO];
}

- (void)viewDidAppear:(BOOL)animated
{
    PBWebViewController *web = [[PBWebViewController alloc]init];
    web.URL = [NSURL URLWithString:@"http://y.qq.com"];
    [self presentViewController:web animated:NO completion:nil];
}


- (void)redirectNotificationHandle:(NSNotification *)nf{
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    printf([str cStringUsingEncoding:NSUTF8StringEncoding]);
    NSRange range = [str rangeOfString:@"setting movie path:"];
    if (range.location != NSNotFound)
    {
        NSArray *array = [str componentsSeparatedByString:@"setting movie path:"];
        NSString *obj = array.lastObject;
        if (obj.length > 5) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"setting movie path:" message:obj delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"DownLoad", @"Copy Link", nil];
            [alert setDelegate:self];
            [alert show];
        }
    }
    //self.logTextView.text = [NSString stringWithFormat:@"%@\n%@",self.logTextView.text, str];
    [[nf object] readInBackgroundAndNotify];
}

- (void)redirectSTD:(int )fd{
    NSPipe * pipe = [NSPipe pipe] ;
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading] ;
    dup2([[pipe fileHandleForWriting] fileDescriptor], fd) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle] ;
    [pipeReadHandle readInBackgroundAndNotify];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        printf("write code to download the media link\r\n");
    }else if(buttonIndex == 1)
    {
        printf("copy link\r\n");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
