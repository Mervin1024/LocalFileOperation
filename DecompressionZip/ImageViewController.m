//
//  ImageViewController.m
//  DecompressionZip
//
//  Created by sh219 on 15/11/26.
//  Copyright © 2015年 sh219. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableDictionary *tableData;
}

@property (weak, nonatomic) IBOutlet UITableView *direcTableView;
@end

@implementation ImageViewController
@synthesize directories;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = [NSString stringWithFormat:@"%@",[directories firstObject]];
    
    // Do any additional setup after loading the view.
    [self setBackBarButton];
    [self initTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackBarButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0, 0, 50, 33);
    backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)initTableData{
    tableData = [NSMutableDictionary dictionaryWithCapacity:10];
    for (NSString *path in directories) {
        NSArray *strings = [path componentsSeparatedByString:@"/"];
        if ([strings count] > 1) {
            NSString *first = [strings firstObject];
            NSArray *items = [tableData allKeys];
            BOOL have = NO;
            for (int i = 0; i < [items count]; i++) {
                if (![first isEqualToString:items[i]]) {
                    continue;
                }
                have = YES;
                NSMutableArray *details = [tableData objectForKey:items[i]];
                [details addObject:path];
            }
            if (!have) {
                NSMutableArray *details = [NSMutableArray array];
                [details addObject:path];
                [tableData setObject:details forKey:first];
            }
        }
    }
//    NSLog(@"%@",tableData);
}

- (void)backAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCell"];
    }
    cell.textLabel.text = [[tableData allKeys] objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
