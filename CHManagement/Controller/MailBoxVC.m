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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _controllerDict = [NSMutableDictionary dictionaryWithCapacity:2];
    _index = 0;
    [self.segmentedControl setSelectedSegmentIndex:_index];
    [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.segmentedControl setSelectedSegmentIndex:_index];
    [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
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

- (UIViewController *)controllerForIndex:(NSUInteger)index
{
    UIViewController *controller = [_controllerDict objectForKey:@(index)];
    if (!controller) {
        switch (index) {
            case 0:
                controller = [[InboxTVC alloc] init];
                break;
            case 1:
                controller = [[OutboxTVC alloc] init];
                break;
            default:
                break;
        }
        controller.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        [self addChildViewController:controller];
    }
    return controller;
}

- (void)switchView:(NSUInteger)index
{
    UIViewController *controller = [self controllerForIndex:index];
    if(self.view.subviews[0] != controller.view) {
        [self.view.subviews[0] removeFromSuperview];
        [self.view addSubview:controller.view];
        [self.view bringSubviewToFront:controller.view];
    }
}

#pragma mark - IBAction

- (IBAction)segmentValueChanged:(id)sender
{
    NSUInteger index = self.segmentedControl.selectedSegmentIndex;
    [self switchView:index];
}

#pragma mark segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController* navigationController = segue.destinationViewController;
    SendMailTVC* sendMailTVC = (SendMailTVC*)navigationController.topViewController;
    [sendMailTVC setMailBoxSwitchViewDelegate:self];
}

#pragma mark segue
-(void)switchViewToOutBox{
    _index = 1;
}

@end
