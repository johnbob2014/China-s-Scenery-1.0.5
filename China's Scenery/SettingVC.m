//
//  SettingVC.m
//  China's Scenery
//
//  Created by 张保国 on 16/1/10.
//  Copyright © 2016年 ZhangBaoGuo. All rights reserved.
//

#import "SettingVC.h"
#import "UIView+AutoLayout.h"
#import "RETableViewManager.h"
#import "GeneralMethod/GeneralMethod.h"
#import "InAppPurchaseVC.h"
#import "AboutVC.h"
#import "SceneryModel.h"
#import "WXApi.h"

const NSString *APP_DOWNLOAD_URL=@"https://itunes.apple.com/app/id1072387063";
const NSString *APP_INTRODUCTION_URL=@"http://7xpt9o.com1.z0.glb.clouddn.com/ChinaSceneryIntroduction.html";

@interface SettingVC ()<RETableViewManagerDelegate>

@property (strong,nonatomic) RETableViewManager *reTVManager;

@property (nonatomic,strong) UITableView *settingTableView;

@property (nonatomic,assign) int productIndex;

@property (nonatomic,strong) NSString *shareTitle;
@property (nonatomic,strong) NSString *shareDescription;

@end

@implementation SettingVC

#pragma mark - Getter & Setter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftButton.hidden=YES;
    self.rightButton.hidden=YES;
    
    self.shareTitle=NSLocalizedString(@"中国那么大，我要去看看", @"");
    self.shareDescription=NSLocalizedString(@"提供原创、超清、经典、唯美的景点图片，带你走进三山五岳、烟雨江南，陪你踏遍大江南北、万里河山。", @"");
    
    self.title=@"设置";
    
    //[self initSettingUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initSettingUI];
}

-(void)initSettingUI{
    UITableView *settingTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    settingTableView.translatesAutoresizingMaskIntoConstraints=NO;
    //settingTableView.delegate=self;
    //settingTableView.dataSource=self;
    
    [self.view addSubview:settingTableView];
    [settingTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.navigationBar];
    [settingTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [settingTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [settingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:fToolBarHeigth-20];
    
    self.settingTableView=settingTableView;
    
    //WeakSelf(weakSelf);
    
    self.reTVManager=[[RETableViewManager alloc]initWithTableView:self.settingTableView delegate:self];
    
    //选项
    RETableViewSection *optionSection=[RETableViewSection sectionWithHeaderTitle:@"选项"];
    //[optionSection setHeaderHeight:30];
    
    REBoolItem *useCellularDataItem=[REBoolItem itemWithTitle:NSLocalizedString(@"🌐 使用蜂窝移动数据", @"") value:[SceneryModel sharedModel].canUseCellularData switchValueChangeHandler:^(REBoolItem *item) {
        [SceneryModel sharedModel].canUseCellularData=item.value;
    }];
    REBoolItem *catchHDItem=[REBoolItem itemWithTitle:NSLocalizedString(@"🌈 缓存高清图", @"") value:YES switchValueChangeHandler:^(REBoolItem *item) {
        
    }];
    RETableViewItem *clearCatchItem=[RETableViewItem itemWithTitle:NSLocalizedString(@"❌ 清理缓存",@"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            item.title=NSLocalizedString(@"正在清理...", @"");
//            item.enabled=NO;
//        });
        
        [[SceneryModel sharedModel] asyncClearSavedImageWithCompletionBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
//                clearCatchItem.enabled=NO;
//                clearCatchItem.title=NSLocalizedString(@"清理完成!", @"");
                [GM showTipsLabelWithSize:CGSizeMake(120, 60) tips:@"清理完成!" removeAfterDelay:1.2];
            });
            
        }];
    }];
    [optionSection addItemsFromArray:@[useCellularDataItem,catchHDItem,clearCatchItem]];
    
    //购买
    NSInteger purchasedCoins=[[NSUserDefaults standardUserDefaults] integerForKey:@"purchasedCoins"];
//    id coins=[[NSUserDefaults standardUserDefaults] objectForKey:@"purchasedCoins"];
//    if (coins) {
//        purchasedCoins=(NSInteger)coins;
//    }else{
//        purchasedCoins=20;
//    }
    NSString *headerTitle=[NSString stringWithFormat:@"购买图币(现有图币:%ld) 图币可用于下载高清大图",(long)purchasedCoins];

    RETableViewSection *purchaseSection=[RETableViewSection sectionWithHeaderTitle:headerTitle];
    [purchaseSection setHeaderHeight:20];
    [purchaseSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"🌠 300图币,6元(0.020元/图币)",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        self.productIndex=0;
        [self performSegueWithIdentifier:@"showInAppPurchase" sender:self];
    }]];
    [purchaseSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"🌋 700图币,12元(0.017元/图币)",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        self.productIndex=1;
        [self performSegueWithIdentifier:@"showInAppPurchase" sender:self];
    }]];
    [purchaseSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"🗻 1200图币,18元(0.015元/图币)",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        self.productIndex=2;
        [self performSegueWithIdentifier:@"showInAppPurchase" sender:self];
        //[weakSelf sendToWXscene:WXSceneTimeline];
    }]];
    [purchaseSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"🌌 1800图币,25元(0.013元/图币)",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        self.productIndex=3;
        [self performSegueWithIdentifier:@"showInAppPurchase" sender:self];
    }]];
    
    //分享
    RETableViewSection *shareSection=[RETableViewSection sectionWithHeaderTitle:NSLocalizedString(@"分享", @"")];
    [shareSection setHeaderHeight:20];
    [shareSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"🍀 微信朋友圈",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        //NSLog(@"ok");
        [self sendToWXscene:WXSceneTimeline];
    }]];
    [shareSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"💠 微信好友",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        [self sendToWXscene:WXSceneSession];
    }]];
    /*
    [shareSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"✉️ 短信",@"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        //[weakSelf sendSMS];
    }]];
    */
    
    //其他
    RETableViewSection *aboutSection=[RETableViewSection sectionWithHeaderTitle:NSLocalizedString(@"其他", @"")];
    [aboutSection setHeaderHeight:20];
    [aboutSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"💖 给个好评", @"") accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[APP_DOWNLOAD_URL copy]]];
    }]];
    
    [aboutSection addItem:[RETableViewItem itemWithTitle:NSLocalizedString(@"🎉 关于", @"") accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        [self performSegueWithIdentifier:@"showAbout" sender:self];
    }]];

    [self.reTVManager addSectionsFromArray:@[optionSection,purchaseSection,shareSection,aboutSection]];
}


#pragma mark - WeChat
-(void)sendToWXscene:(enum WXScene)scene{
    if([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
        //NSLog(@"Session or Timeline");
        WXWebpageObject *webpageObject=[WXWebpageObject alloc];
        webpageObject.webpageUrl=[APP_INTRODUCTION_URL copy];
        
        //UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]];
        UIImage *sourceImage=[UIImage imageNamed:@"China's Scenery-150*150.jpg"];
        //NSLog(@"%0.f",sourceImage.size.width);
        //UIImage *thumbImage = [GM thumbImageFromImage:sourceImage limitSize:CGSizeMake(150, 150)];
        NSData *imageData=UIImageJPEGRepresentation(sourceImage, 0.5);// UIImageJPEGRepresentation(sourceImage);
        
        WXMediaMessage *mediaMessage=[WXMediaMessage alloc];
        mediaMessage.title=self.shareTitle;
        mediaMessage.description=self.shareDescription;
        mediaMessage.mediaObject=webpageObject;
        mediaMessage.thumbData=imageData;
        //NSLog(@"%@",mediaMessage);
        
        SendMessageToWXReq *req=[SendMessageToWXReq new];
        req.message=mediaMessage;
        req.bText=NO;
        req.scene=scene;
        //NSLog(@"%@",req);
        BOOL succeeded=[WXApi sendReq:req];
        NSLog(@"%d",succeeded);
    }else{
        NSLog(@"微信被禁用");
    }
    //纯文本消息
    //    if([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]){
    //        NSLog(@"Timeline");
    //        SendMessageToWXReq *req=[SendMessageToWXReq new];
    //        req.text=@"玩转贷款";
    //        req.bText=YES;
    //        req.scene=WXSceneTimeline;
    //        [WXApi sendReq:req];
    //    }
    //
    
}

#pragma mark - WeChat Delegate
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        NSLog(@"%@:\n%@",strTitle,strMsg);
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInAppPurchase"]) {
        InAppPurchaseVC *inVC=segue.destinationViewController;
        inVC.productIndex=self.productIndex;
        inVC.transactionType=TransactionTypePurchase;
    }else if ([segue.identifier isEqualToString:@"showAbout"]){
        AboutVC *aboutVC=segue.destinationViewController;
        aboutVC.title=@"关于";
    }
}


@end
