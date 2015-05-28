//
//  ContentTableViewController.h
//  RssLevel1
//
//  Created by Kenny Chu on 2015/5/27.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewController : UITableViewController<NSXMLParserDelegate>

@property(nonatomic, strong) NSMutableDictionary *currentDictionary;   // current section being parsed
@property(nonatomic, strong) NSMutableDictionary *parsedResult;          // completed parsed xml response
@property(nonatomic, strong) NSString *currentKey;
@property(nonatomic, strong) NSMutableArray *result;
@property(nonatomic, strong) NSString *rssUrl;

@end
