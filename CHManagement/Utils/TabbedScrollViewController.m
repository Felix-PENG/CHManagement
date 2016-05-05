//
//  TabbedScrollViewController.m
//  CHManagement
//
//  Created by 黄嘉伟 on 16/5/2.
//  Copyright © 2016年 楚淮集团. All rights reserved.
//

#import "TabbedScrollViewController.h"
#import "TabItem.h"

#define TAB_COLOR [UIColor darkGrayColor]
#define SELECTED_TAB_COLOR [self.view tintColor]
#define TAB_HEIGHT 44.0
#define SELECTED_LINE_HEIGHT 2.0

@interface TabbedScrollViewController () <UIScrollViewDelegate>

@end

@implementation TabbedScrollViewController
{
    UIScrollView *_contentScrollView;
    NSInteger _currentIndex;
    UIView *_selectedLine;
}


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.frame = CGRectMake(0, TAB_HEIGHT, frame.size.width, frame.size.height - TAB_HEIGHT);
        [self.view addSubview:_contentScrollView];
        
        _currentIndex = -1;
        
        NSUInteger tabCount = items.count;
        
        if (tabCount > 0) {
            CGFloat tabWidth = self.view.frame.size.width / tabCount;
            
            _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, TAB_HEIGHT - SELECTED_LINE_HEIGHT, tabWidth, SELECTED_LINE_HEIGHT)];
            _selectedLine.backgroundColor = SELECTED_TAB_COLOR;
            [self.view addSubview:_selectedLine];
            
            _contentScrollView.contentSize = CGSizeMake(tabCount * frame.size.width, frame.size.height - TAB_HEIGHT);
            
            for (NSUInteger i = 0; i < tabCount; i++) {
                TabItem *item = items[i];
                
                UILabel *tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * tabWidth, 0, tabWidth, TAB_HEIGHT)];
                tabLabel.font = [UIFont systemFontOfSize:17.0];
                tabLabel.textColor = TAB_COLOR;
                tabLabel.textAlignment = NSTextAlignmentCenter;
                tabLabel.text = item.tabName;
                tabLabel.tag = i + 1;
                tabLabel.userInteractionEnabled = YES;
                tabLabel.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:tabLabel];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabTapped:)];
                [tabLabel addGestureRecognizer:tap];
                
                UIView *contentView = item.controller.view;
                [contentView setFrame:CGRectMake(i * frame.size.width, 0, frame.size.width, frame.size.height - TAB_HEIGHT)];
                [_contentScrollView addSubview:contentView];
                [self addChildViewController:item.controller];
            }
            
            [self.view bringSubviewToFront:_selectedLine];
            [self scrollToLabel:0];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)tabTapped:(UITapGestureRecognizer *)recognizer
{
    UILabel *tabLabel = (UILabel *)recognizer.view;
    [self switchToIndex:tabLabel.tag - 1];
}

- (void)switchToIndex:(NSUInteger)index
{
    if (index != _currentIndex) {
        [self scrollToContent:index];
    }
}

- (void)scrollToLabel:(NSUInteger)index
{
    if (_currentIndex >= 0) {
        UILabel *currLabel = [self.view viewWithTag:_currentIndex + 1];
        currLabel.textColor = TAB_COLOR;
    }
    
    UILabel *tabLabel = [self.view viewWithTag:index + 1];
    tabLabel.textColor = [self.view tintColor];
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^
    {
                _selectedLine.frame = CGRectMake(tabLabel.frame.origin.x, TAB_HEIGHT - SELECTED_LINE_HEIGHT, tabLabel.frame.size.width, SELECTED_LINE_HEIGHT);
    }
                     completion:nil];
    _currentIndex = index;
}

- (void)scrollToContent:(NSUInteger)index
{
    [_contentScrollView setContentOffset:CGPointMake(index * _contentScrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index = (scrollView.contentOffset.x + scrollView.frame.size.width / 2) / scrollView.frame.size.width;
    if (index != _currentIndex) {
        [self scrollToLabel:index];
    }
}

@end
