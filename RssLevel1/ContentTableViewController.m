//
//  ContentTableViewController.m
//  RssLevel1
//
//  Created by Kenny Chu on 2015/5/27.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import "ContentTableViewController.h"
#import "ContentTableViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"

@interface ContentTableViewController ()

@end

@implementation ContentTableViewController

bool inItem = false;
bool inTitle = false;
bool inLink = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContents];
    
}

- (void)loadContents {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager GET:self.rssUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *parser = (NSXMLParser*)responseObject;
        parser.delegate = self;
        [parser setShouldProcessNamespaces:YES];
        [parser parse];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error get context" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    
    NSLog(@"start parsing");
    self.currentDictionary = [NSMutableDictionary dictionary];
    self.result = [[NSMutableArray alloc] init];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSLog(@"element:%@", qName);
    
    if ([qName isEqualToString:@"item"]) {
        inItem = true;
    }
    if ([qName isEqualToString:@"title"]) {
        inTitle = true;
    }
    if ([qName isEqualToString:@"link"]) {
        inLink = true;
    }
    
    if (inItem) {
        if ([qName isEqualToString:@"media:content"]) {
            NSLog(@"attr %@", attributeDict[@"url"]);
            [self.currentDictionary setObject:attributeDict[@"url"] forKey:@"imgUrl"];
        }
    }

}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    NSLog(@"value: %@",string);
    
    if (inLink && inItem) {
        [self.currentDictionary setObject:string forKey:@"link"];
    } else if (inTitle && inItem) {
        if ([self.currentDictionary objectForKey:@"title"] != nil) {
            NSMutableString *tmpTitle = [[NSMutableString alloc]init];
            [tmpTitle appendString:[self.currentDictionary objectForKey:@"title"]];
            [tmpTitle appendString:string];
            string = tmpTitle;
        }
        [self.currentDictionary setObject:string forKey:@"title"];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"endparse: %@",qName);
    
    if ([qName isEqualToString:@"item"]) {
        inItem = false;
        [self.result addObject:self.currentDictionary];
        self.currentDictionary = [NSMutableDictionary dictionary];;
    }
    if ([qName isEqualToString:@"title"]) {
        inTitle = false;
    }
    if ([qName isEqualToString:@"link"]) {
        inLink = false;
    }
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser{
    
    NSLog(@"end");
    NSLog(@"%@", self.result);
    [self.tableView reloadData];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.result count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    
    NSDictionary *context =self.result[indexPath.row];
    cell.titleLabel.text = context[@"title"];
    UIImage *defaultImg = [UIImage imageNamed:@"FINAL.png"];
    NSString *imgUrl = context[@"imgUrl"];
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __weak ContentTableViewCell *weakCell = cell;
    [cell.thumbImageView setImageWithURLRequest:request placeholderImage:defaultImg success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.thumbImageView.image = image;
    } failure:nil
     ];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *context = self.result[self.tableView.indexPathForSelectedRow.row];
    NSString *url = context[@"link"];
    WebViewController *webViewController = segue.destinationViewController;
    webViewController.url = url;
}


@end
