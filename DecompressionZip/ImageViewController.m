//
//  ImageViewController.m
//  DecompressionZip
//
//  Created by sh219 on 15/11/26.
//  Copyright © 2015年 sh219. All rights reserved.
//


#import "ImageViewController.h"

@implementation FilePath


@end

@interface ImageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tableData;
}

@property (weak, nonatomic) IBOutlet UITableView *direcTableView;
@end

@implementation ImageViewController
@synthesize directories, directoryPath, isRoot;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
//    self.title = [NSString stringWithFormat:@"%@",[directories firstObject]];
    
    // Do any additional setup after loading the view.
    if (isRoot) {
        [self setBackBarButtonWithType:BankButtonTypeDismiss];
    }else{
        [self setBackBarButtonWithType:BankButtonTypeRevoke];
    }
    
    [self initTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackBarButtonWithType:(BankButtonType)type{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(0, 0, 60, 33);
    backButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    if (BankButtonTypeDismiss == type) {
        [backButton setTitle:@"取消" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [backButton setTitle:@"上一级" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)initTableData{
    tableData = [NSMutableArray arrayWithCapacity:10];
    for (NSString *path in directories) {
        NSArray *strings = [path componentsSeparatedByString:@"/"];
        if ([strings count] > 1) {
            NSString *first = [strings firstObject];
            BOOL have = NO;
            NSString *childPath = [path substringFromIndex:[first length]+1];
            for (int i = 0; i < [tableData count]; i++) {
                FilePath *dataPath = [tableData objectAtIndex:i];
                if (![first isEqualToString:dataPath.name]) {
                    continue;
                }
                have = YES;
                [dataPath.childPaths addObject:childPath];
            }
            if (!have) {
                NSMutableArray *details = [NSMutableArray array];
                [details addObject:childPath];
                FilePath *filePath = [[FilePath alloc] init];
                filePath.name = first;
                filePath.childPaths = details;
                filePath.image = [UIImage imageNamed:@"folder"];
                [tableData addObject:filePath];
            }
        }else{
            NSArray *stringAndType = [path componentsSeparatedByString:@"."];
            UIImage *image;
            if ([stringAndType count] > 1 && ([[stringAndType lastObject] isEqualToString:@"png"] || [[stringAndType lastObject] isEqualToString:@"jpg"])) {
                image = [UIImage imageWithContentsOfFile:[directoryPath stringByAppendingPathComponent:path]];
            }else{
                image = [UIImage imageNamed:@"folder"];
            }
            
            FilePath *file = [[FilePath alloc] init];
            file.name = path;
            file.image = image;
            file.childPaths = [NSMutableArray arrayWithCapacity:10];
            [tableData addObject:file];
        }
    }
//    NSLog(@"%@",tableData);
}

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    FilePath *filePath = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = filePath.name;
    cell.imageView.image = filePath.image;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FilePath *filePath = [tableData objectAtIndex:indexPath.row];
    if ([filePath.childPaths count] < 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO animated:YES];
        return;
    }
    ImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageViewController"];
    controller.isRoot = NO;
    controller.directories = filePath.childPaths;
    controller.directoryPath = [directoryPath stringByAppendingPathComponent:filePath.name];
    controller.title = filePath.name;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
