//
//  ViewController.m
//  DecompressionZip
//
//  Created by sh219 on 15/11/26.
//  Copyright © 2015年 sh219. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewController.h"
#import <ZipArchive.h>
#import <SVProgressHUD.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *imageTableView;
    NSMutableArray *data;
    NSFileManager *fileManager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [NSMutableArray arrayWithCapacity:12];
    [self initTableView];
    fileManager = [NSFileManager defaultManager];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    imageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT)];
    imageTableView.delegate = self;
    imageTableView.dataSource = self;
    imageTableView.center = self.view.center;
    imageTableView.alpha = 0.0f;
    [self.view addSubview:imageTableView];
}

- (IBAction)decompressionAction:(id)sender {
    
    [self decompressionFile:[self filePathOfName:@"2048" type:@"zip"]];
//    NSLog(@"解压");
}

- (void)decompressionFile:(NSString *)filePath{
    if (!filePath) {
        [SVProgressHUD showErrorWithStatus:@"没有找到此文件"];
        return;
    }
    // 获取解压包名称
    NSArray *array = [filePath componentsSeparatedByString:@"/"];
    NSString *fileNameWithType = [array lastObject];
    NSString *fileName = [[fileNameWithType componentsSeparatedByString:@"."] firstObject];
    
    // 获取Document文件夹路径
    ZipArchive *zipFile = [[ZipArchive alloc] init];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    
    // 以解压包名称创建新文件夹
    NSString *zipDirectoryPath = [documentPath stringByAppendingPathComponent:fileName];
    fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:zipDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 解压
    if ([zipFile UnzipOpenFile:filePath]) {
        [SVProgressHUD show];
        BOOL ret = [zipFile UnzipFileTo:zipDirectoryPath overWrite:YES];
        if (!ret) {
            [SVProgressHUD showErrorWithStatus:@"解压不成功"];
        }else{
//            [SVProgressHUD showSuccessWithStatus:@"解压成功"];
//            // 打印所有文件
            NSArray *allDirectorise = [fileManager subpathsOfDirectoryAtPath:zipDirectoryPath error:nil];
//            NSLog(@"All Directories:%@",allDirectorise);
            
            UINavigationController *navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ImageViewNavigationController"];
            ImageViewController *controller = (ImageViewController *)navController.topViewController;
            controller.directories = allDirectorise;
            [SVProgressHUD dismiss];
            [self presentViewController:navController animated:YES completion:nil];
        }
        [zipFile UnzipCloseFile];
    }else{
        [SVProgressHUD showErrorWithStatus:@"没有找到解压文件"];
    }
    
}

- (NSString *)filePathOfName:(NSString *)name type:(NSString *)type{
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return zipPath;
}
- (IBAction)deleteAction:(id)sender {
    [data removeAllObjects];
    for (int i = 1; i < 9; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d",(int)pow(2, i)];
        NSString *filePath = [self filePathOfName:imageName type:@"png"];
        if (!filePath) {
            continue;
        }
        [data addObject:imageName];
    }
    CGRect frame = imageTableView.frame;
    frame.size.height = [data count] * 69;
    imageTableView.frame = frame;
    imageTableView.center = self.view.center;
    [imageTableView reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        imageTableView.alpha = 1.0f;
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[data objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        tableView.alpha = 0.0f;
    }completion:^(BOOL finished) {
        if (finished) {
            
            NSString *filePath = [self filePathOfName:[data objectAtIndex:indexPath.row] type:@"png"];
//            NSLog(@"Delete filePath:%@",filePath);
            [self isFileExists:filePath];
//            NSError *error = [[NSError alloc] init];
            BOOL delete = [fileManager removeItemAtPath:filePath error:nil];
            
//            [self isFileExists:filePath];
            
            if (!delete) {
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
//                NSLog(@"%@",error);
            }else{
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            }
            
            [self isFileExists:filePath];
        }
    }];
    
}

- (BOOL)isFileExists:(NSString *)filePath{
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"文件存在");
        return YES;
    }else{
        NSLog(@"文件不存在");
        return NO;
    }
}

@end
