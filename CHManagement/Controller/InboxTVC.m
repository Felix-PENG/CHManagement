//
//  InboxTVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "InboxTVC.h"
#import "NetworkManager.h"
#import "ResultVO.h"
#import "MessageVO.h"
#import "LoadMoreCell.h"
#import "MailCell.h"

#define INBOX_FLAG 0

static NSString * const CellIdentifier = @"MailCell";
static NSString * const LoadMoreCellIdentifier = @"LoadMoreCell";

@interface InboxTVC ()

@end

@implementation InboxTVC
{
    UIRefreshControl *_refreshControl;
    NSMutableArray* _messageList;
    NSInteger _page;
    BOOL _noMoreData;
    BOOL _repeatLoad;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    nib = [UINib nibWithNibName:LoadMoreCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:LoadMoreCellIdentifier];
    
    // cell自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 95.0;
    
    // 刷新控件
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_refreshControl];
    
    _messageList = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated{
    if(!_repeatLoad){
        [self.refreshControl beginRefreshing];
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        _repeatLoad = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    _repeatLoad = NO;
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
    return _messageList.count > 0 ? _messageList.count + 1 : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < _messageList.count){
        MailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        MessageVO* message = [_messageList objectAtIndex:indexPath.row];
        
        [cell configureWithContent:message.content withSender:message.sender.name withTime:message.time];
        
        return cell;
    }else{
        LoadMoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        cell.status = _noMoreData ? NoMore : ClickToLoad;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < _messageList.count){
        
    }else{
        LoadMoreCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.status = Loading;
        [self loadInboxEmail:++_page];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refresh
{
    _page = 1;
    [self loadInboxEmail:_page];
}

#pragma mark load data
- (void)loadInboxEmail:(NSInteger)page{
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [[userData objectForKey:@"user_id"]integerValue];
    
    [[NetworkManager sharedInstance]getMessagesWithPage:page withInOff:INBOX_FLAG withUserId:user_id completionHandler:^(NSDictionary *response) {
        ResultVO* resultVO = [[ResultVO alloc]initWithDictionary:[response objectForKey:@"resultVO"] error:nil];
        
        if([resultVO success] == 0){
            NSArray* messageVOList = [response objectForKey:@"messageVOList"];
            NSLog(@"%lu",[messageVOList count]);
            if(messageVOList.count > 0){
                for(NSDictionary* messageDict in messageVOList){
                    MessageVO* message = [[MessageVO alloc]initWithDictionary:messageDict error:nil];
                    [_messageList addObject:message];
                }
                _noMoreData = NO;
            }else{
                _noMoreData = YES;
            }
            
            [self.tableView reloadData];
        }else{
            
        }
        
        if([self.refreshControl isRefreshing]){
            [self.refreshControl endRefreshing];
        }
    }];
}

@end
