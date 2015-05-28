//
//  WebViewController.m
//  RssLevel1
//
//  Created by Kenny Chu on 2015/5/27.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "WebViewController.h"
#import "AFNetworking.h"
#import "UIWebView+AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    NSURL *nsUrl = [NSURL URLWithString:self.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:urlRequest progress:nil success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        return HTML;
    } failure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidStartLoad:(UIWebView *)webView{
    // web view 中有載入事件時，將 manager 的計數器+1
    [AFNetworkActivityIndicatorManager.sharedManager incrementActivityCount];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // web view 中的載入事件結束時，將 manager 的計數器-1
    [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // web view 中的載入事件失敗時，將 manager 的計數器-1
    [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
}

- (void) viewWillAppear:(BOOL)animated {
    while ([AFNetworkActivityIndicatorManager.sharedManager isNetworkActivityIndicatorVisible]){
        [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
    }
}

@end
