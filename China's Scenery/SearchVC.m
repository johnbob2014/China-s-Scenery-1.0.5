//
//  SearchVC.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/9.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "SearchVC.h"
#import "UIView+AutoLayout.h"
#import "PictureListWaterFlowVC.h"
#import "CSCoreDataConfig.h"
#import "SceneryModel.h"
#import "Image&DetailTVCell.h"


@interface SearchVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (assign,nonatomic) BOOL netWork;

@property (nonatomic, strong) IMQuickSearch *quickSearch;

@property (nonatomic,strong) UIView *searchBar;
@property (strong, nonatomic) UITextField *searchTextField;

@property (strong, nonatomic) UITableView *searchTableView;
@property (nonatomic, strong) NSArray *filteredResults;

@property (nonatomic,strong) NSFetchRequest *sceneryRequest;
@property (nonatomic,strong) NSArray *sortedCSceneryArray;

@end

@implementation SearchVC

-(NSFetchRequest *)sceneryRequest{
    if (!_sceneryRequest) {
        NSFetchRequest *req=[NSFetchRequest fetchRequestWithEntityName:@"CScenery"];
        req.predicate=nil;
        req.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
        _sceneryRequest=req;
    }
    return _sceneryRequest;
}

#pragma mark - UI
-(void)initSearchUI{
    
    //searchBar
    UIView *searchBar=[[UIView alloc]initForAutoLayout];
    searchBar.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:searchBar];
    [searchBar autoSetDimension:ALDimensionHeight toSize:50];
    [searchBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navigationBar];
    [searchBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [searchBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
    UILabel *imageLabel=[[UILabel alloc]initForAutoLayout];
    imageLabel.text=@"🔍";
    [searchBar addSubview:imageLabel];
    [imageLabel autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [imageLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) excludingEdge:ALEdgeRight];
    
    //searchTextField
    UITextField *searchTextField=[[UITextField alloc]initForAutoLayout];
    
    searchTextField.layer.borderColor=[UIColor whiteColor].CGColor;
    searchTextField.layer.borderWidth=2.0f;
    searchTextField.layer.cornerRadius=4.0f;
    searchTextField.clearButtonMode=UITextFieldViewModeAlways;
    
    [searchTextField addTarget:self action:@selector(textFieldTextEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [searchTextField addTarget:self action:@selector(textFieldTextEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];

    
    [searchBar addSubview:searchTextField];
    [searchTextField autoSetDimension:ALDimensionHeight toSize:40];
    [searchTextField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:searchBar];
    [searchTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [searchTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:45];
    
    //searchTableView
    UITableView *searchTableView=[[UITableView alloc]initForAutoLayout];// WithFrame:CGRectMake(0, searchBar.frame.origin.y+searchBar.frame.size.height, fDeviceWidth, fDeviceHeight/10*9) style:UITableViewStylePlain];
    
    [searchTableView registerClass:[Image_DetailTVCell class] forCellReuseIdentifier:@"CellId"];
    searchTableView.delegate=self;
    searchTableView.dataSource=self;
    
    
    [self.view addSubview:searchTableView];
    [searchTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:searchBar];
    [searchTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [searchTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [searchTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:fToolBarHeigth];
    
    self.searchBar=searchBar;
    self.searchTextField=searchTextField;
    self.searchTableView=searchTableView;
    
    
}

#pragma mark - TextField Delegate

-(void)textFieldTextEditingDidEndOnExit:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (void)textFieldTextEditingChanged:(UITextField *)textField{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
    [self performSelector:@selector(startQuickSearch) withObject:nil afterDelay:0.07];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initSearchUI];
    
    self.leftButton.hidden=YES;
    self.rightButton.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSLog(@"SearchVC");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneryModelRefreshed:) name:kSceneryModelRefreshedNotification object:nil];
    
    [self refreshUI];
    
    self.netWork=[[SceneryModel sharedModel] checkNetWork];
}

-(void)sceneryModelRefreshed:(id)sender{
    NSLog(@"SearchVC:接收到数据更新通知");
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self refreshUI];
    });
}

-(void)refreshUI{
    self.sortedCSceneryArray=nil;
    self.sortedCSceneryArray=[[SceneryModel sharedModel].managedObjectContext executeFetchRequest:self.sceneryRequest error:NULL];
    self.title=[NSString stringWithFormat:@"从 %lu 个景点中搜索:",(unsigned long)[self.sortedCSceneryArray count]];
    
    IMQuickSearchFilter *sceneryFilter=[IMQuickSearchFilter filterWithSearchArray:self.sortedCSceneryArray keys:@[@"name"]];
    self.quickSearch = [[IMQuickSearch alloc] initWithFilters:@[sceneryFilter]];
    
    self.filteredResults = [self.quickSearch filteredObjectsWithValue:nil];
    [self.searchTableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSceneryModelRefreshedNotification object:nil];
    self.searchTextField.text=nil;
}


#pragma mark - Quick Search
- (void)startQuickSearch {
    // Asynchronously && BENCHMARK TEST
    
    NSLog(@"%@",self.searchTextField.text);
    [self.quickSearch asynchronouslyFilterObjectsWithValue:self.searchTextField.text completion:^(NSArray *filteredResults) {
        self.filteredResults = filteredResults;
        [self.searchTableView reloadData];
    }];
    
    // Synchronously
    //[self.quickSearch filteredObjectsWithValue:self.searchTextField.text];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return fNavBarHeigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Image_DetailTVCell *cell = [[Image_DetailTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
   
    // Set Content
    id contentObject = self.filteredResults[indexPath.row];
    
    if ([contentObject isKindOfClass:[CScenery class]]) {
        CScenery *cScenery=(CScenery *)contentObject;
        
        cell.name =[NSString stringWithFormat:@"%@ - %@",cScenery.name,cScenery.province.name];
        cell.detail=cScenery.detail;
        cell.isInFavourites=[cScenery.isInFavourites boolValue];
        
        NSArray *pictureArray=[cScenery.pictures allObjects];
        
        NSUInteger pictureCount=[pictureArray count];
        if (pictureCount) {
            //CPictuer *cp=pictureArray[arc4random()%(pictureCount-1)];
            CPictuer *cp=pictureArray[0];
            NSString *pictureName=cp.thumbnailName;
            
            NSString *filePath=[GM filePathInDocumentDirectory:pictureName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                cell.imagePath=filePath;
            }else{
                if (self.netWork) {
                    cell.imageURL=[[Qiniu sharedQN] downloadURLForFile:pictureName];
                }
            }
        }
        
    }else{
        NSLog(@"Error");
    }
    
    //cell.textLabel.text = title;
    //cell.detailTextLabel.text = subtitle;
    
    // Return Cell
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    CScenery *cScenery=self.filteredResults[indexPath.row];
    
    [self performSegueWithIdentifier:@"showPictureList" sender:cScenery];
    
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[CScenery class]]){
        CScenery *cScenery=(CScenery *)sender;
        if ([segue.identifier isEqualToString:@"showPictureList"]) {
            PictureListWaterFlowVC *plwfvc=segue.destinationViewController;
            plwfvc.cScenery=cScenery;
        }
    }
}

@end
