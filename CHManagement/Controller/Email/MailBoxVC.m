//
//  MailBoxVC.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/1.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "MailBoxVC.h"
#import "InboxTVC.h"
#import "OutboxTVC.h"

@interface MailBoxVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation MailBoxVC
{
    NSMutableDictionary *_controllerDict;
    NSUInteger _index;
    InboxTVC* _inboxTVC;
    OutboxTVC* _outboxTVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _controllerDict = [NSMutableDictionary dictionaryWithCapacity:2];
    _index = 0;
    [self.segmentedControl setSelectedSegmentIndex:_index];
    [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)controllerForIndex:(NSUInteger)index
{
    UIViewController *controller = [_controllerDict objectForKey:@(index)];
    if (!controller) {
        switch (index) {
            case 0:
                _inboxTVC = [[InboxTVC alloc] init];
                controller = _inboxTVC;
                break;
            case 1:
                _outboxTVC = [[OutboxTVC alloc] init];
                controller = _outboxTVC;
                break;
            default:
                break;
        }
        controller.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        [_controllerDict setObject:controller forKey:@(index)];
        [self addChildViewController:controller];
        [self.view addSubview:controller.view];
    }
    return controller;
}

- (void)switchView:(NSUInteger)index
{
    UIViewController *controller = [self controllerForIndex:index];
    
    [self.view bringSubviewToFront:controller.view];
}

#pragma mark - IBAction

- (IBAction)segmentValueChanged:(id)sender
{
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    _index = index;
    [self switchView:index];
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController* navigationController = segue.destinationViewController;
    SendMailTVC* sendMailTVC = (SendMailTVC*)navigationController.topViewController;
    sendMailTVC.delegate = self;
}

#pragma mark implement protocol methods
- (void)switchViewToOutBox{
    _index = 1;
    [self.segmentedControl setSelectedSegmentIndex:_index];
    [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)needRefresh{
    _inboxTVC.repeatLoad = NO;
    _outboxTVC.repeatLoad = NO;
}

@end
