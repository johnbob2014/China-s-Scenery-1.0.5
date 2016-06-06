//
//  FavouriteVC.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/10.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "FavouriteVC.h"
#import "CSCoreDataConfig.h"
#import "Image&DetailTVCell.h"
#import "PictureListWaterFlowVC.h"
#import "SceneryModel.h"

@interface FavouriteVC ()<UITableViewDataSource, UITableViewDelegate>
@property (assign,nonatomic) BOOL netWork;
@property (nonatomic,strong) NSArray *favouriteCSceneryArray;
@property (strong, nonatomic) UITableView *favouriteTableView;
@end

@implementation FavouriteVC
#pragma mark - Getter
-(NSArray *)favouriteCSceneryArray{
    NSFetchRequest *req=[NSFetchRequest fetchRequestWithEntityName:@"CScenery"];
    req.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"isInFavourites",[NSNumber numberWithBool:YES]];
    req.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    NSArray *matches=[[SceneryModel sharedModel].managedObjectContext executeFetchRequest:req error:NULL];
    return matches;
}

#pragma mark - int
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.leftButton.hidden=YES;
    self.rightButton.hidden=YES;
    
    
}

#pragma mark - UITableView reloadData 方法不管用，只能这样强制刷新，实在是不明原因
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title=[NSString stringWithFormat:@"我的收藏(%lu 个景点)",(unsigned long)[self.favouriteCSceneryArray count]];
    [self initFavouriteUI];
    
    self.netWork=[[SceneryModel sharedModel] checkNetWork];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.favouriteCSceneryArray=nil;
    self.favouriteTableView=nil;
}

-(void)initFavouriteUI{
    //favouriteTableView
    UITableView *favouriteTableView=[[UITableView alloc]initForAutoLayout];
    [favouriteTableView registerClass:[Image_DetailTVCell class] forCellReuseIdentifier:@"CellId"];
    favouriteTableView.delegate=self;
    favouriteTableView.dataSource=self;
    
    [self.view addSubview:favouriteTableView];
    [favouriteTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navigationBar];
    [favouriteTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [favouriteTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [favouriteTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:fToolBarHeigth];

}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favouriteCSceneryArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return fNavBarHeigth;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Image_DetailTVCell *cell = [[Image_DetailTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    
    CScenery *cScenery = self.favouriteCSceneryArray[indexPath.row];
    
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

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    CScenery *cScenery=self.favouriteCSceneryArray[indexPath.row];
    
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
