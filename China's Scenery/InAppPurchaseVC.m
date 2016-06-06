//
//  InAppPurchaseViewController.m
//  贷款计算器
//
//  Created by 张保国 on 15/7/19.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "InAppPurchaseVC.h"
#import <StoreKit/StoreKit.h>

#define ProductID_300 @"com.ZhangBaoGuo.ChinaScenery.300";
#define ProductID_700 @"com.ZhangBaoGuo.ChinaScenery.700";
#define ProductID_1200 @"com.ZhangBaoGuo.ChinaScenery.1200";
#define ProductID_1800 @"com.ZhangBaoGuo.ChinaScenery.1800";

@interface InAppPurchaseVC ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (strong,nonatomic) UITextView *textView;
@property (copy,nonatomic) NSString *infoString;
@end

@implementation InAppPurchaseVC

#pragma mark - User
-(void)leftButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)rightButtonPressed:(id)sender{
    self.textView.text=@"";
    [self startProductRequest];
}

-(void)setInfoString:(NSString *)infoString{
    _infoString=infoString;
    self.textView.text=[self.textView.text stringByAppendingString:infoString];
}

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"购买图币";
    
    [self initPurchaseUI];
    
    //self.rightButton.bounds=CGRectMake(0, 0, 160, 50);
    self.rightButton.enabled=NO;
    
    //监听结果
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
    //购买还是恢复
    switch (_transactionType) {
        case TransactionTypePurchase:
            [self.rightButton setTitle:NSLocalizedString(@"购买",@"") forState:UIControlStateNormal];
            [self startProductRequest];
            break;
        case TransactionTypeRestore:
            [self.rightButton setTitle:NSLocalizedString(@"正在恢复...",@"") forState:UIControlStateNormal];
            self.infoString=NSLocalizedString(@"-----向iTunes Store请求恢复产品-----\n-----请耐心等待-----\n",@"");
            
            [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
            break;
        default:
            break;
    }
}

-(void)initPurchaseUI{
    _textView=[[UITextView alloc]initForAutoLayout];
    [_textView.layer setBorderColor:[UIColor grayColor].CGColor];
    _textView.editable=NO;
    _textView.selectable=NO;
    _textView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_textView];
    [_textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(fNavBarHeigth, 0, 0, 0)];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

#pragma - Custom Methods

//发出产品请求
-(void)startProductRequest{
    if ([SKPaymentQueue canMakePayments]) {
        //允许程序内付费购买
        self.infoString=NSLocalizedString(@"-----向iTunes Store请求产品信息-----\n-----请耐心等待-----\n",@"");
        
        NSString *ProductID=nil;
        switch (self.productIndex) {
            case 0:
                ProductID=ProductID_300;
                break;
                
            case 1:
                ProductID=ProductID_700;
                break;
                
            case 2:
                ProductID=ProductID_1200;
                break;
                
            case 3:
                ProductID=ProductID_1800;
                break;
                
            default:
                break;
        }
        
        NSSet *productSet=[NSSet setWithObject:ProductID];
        //NSSet *productSet=[NSSet setWithObjects:ProductID,ProductID_CNY6,ProductID_CNY12,nil];
        SKProductsRequest *productRequest=[[SKProductsRequest alloc]initWithProductIdentifiers:productSet];
        productRequest.delegate=self;
        [productRequest start];
    }
    else{
        //NSLog(@"不允许程序内付费购买");
        self.infoString=NSLocalizedString(@"-----不允许程序内付费购买-----\n",@"");
        
    }

}

#pragma - Delegate
//代理方法：收到产品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    //NSLog(@"未识别的产品信息:%@",response.invalidProductIdentifiers);
    
    NSArray *products=response.products;
    self.infoString=NSLocalizedString(@"-----收到iTunes Store的反馈信息-----\n",@"");
    
    //NSLog(@"能识别的产品种类数: %lu\n",(unsigned long)[products count]);
                 
    if ([products count]>0) {
        SKProduct *product=products[0];
        SKPayment *payment=[SKPayment paymentWithProduct:product];
        
        //发起购买请求
        [[SKPaymentQueue defaultQueue]addPayment:payment];
        
        NSString *lst1=NSLocalizedString(@"产品名称", @"");
        NSString *lst2=NSLocalizedString(@"产品描述信息", @"");
        NSString *lst3=NSLocalizedString(@"产品价格", @"");
        
        self.infoString=[[NSString alloc]initWithFormat:@"\n-----%@:%@-----\n-----%@:%@-----\n-----%@:%@-----\n\n",lst1,product.localizedTitle,lst2,product.localizedDescription,lst3,product.price];
        
        self.infoString=NSLocalizedString(@"-----向iTunes Store发送交易请求-----\n",@"");
    }
    else{
        self.infoString=NSLocalizedString(@"-----iTunes Store没有相关产品信息-----\n",@"");
        
        [request cancel];
    }
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSString *lst1=NSLocalizedString(@"-----向iTunes Store请求信息失败-----", @"");
    NSString *lst2=NSLocalizedString(@"错误信息", @"");
    self.infoString=[[NSString alloc]initWithFormat:@"%@\n-----%@：%@-----\n",lst1,lst2,error.localizedDescription];
    
}

-(void)requestDidFinish:(SKRequest *)request{
    self.infoString=NSLocalizedString(@"-----iTunes Store反馈信息结束-----\n",@"");
}

//代理方法：收到交易结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    //交易结果<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
    //监听购买结果
    //[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.infoString=NSLocalizedString(@"-----收到iTunes Store反馈的交易结果-----\n",@"");
    
    //NSLog(@"交易数量:%lu",(unsigned long)[transactions count]);
    if (_transactionType==TransactionTypeRestore&&[transactions count]==0) {
        self.infoString=NSLocalizedString(@"-----您没有可供恢复的项目！-----\n",@"");
        
    }
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                //交易完成,调用自定义方法，提供相应内容、记录交易记录等
                NSLog(@"SKPaymentTransactionStatePurchased");
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"SKPaymentTransactionStateRestored");
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:{
                NSLog(@"SKPaymentTransactionStateFailed");
                
                NSString *lst1=NSLocalizedString(@"-----交易失败，请重新尝试-----", @"");
                NSString *lst2=NSLocalizedString(@"错误信息", @"");
                self.infoString=[[NSString alloc]initWithFormat:@"%@\n-----%@：%@-----\n\n",lst1,lst2,[self showTransactionErrorCode:transaction]];
                [self.rightButton setTitle:NSLocalizedString(@"重试",@"") forState:UIControlStateNormal];
                self.rightButton.enabled=YES;
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
            }
            default:
                break;
        }
    }

}

//交易成功，未用户提供相关功能
-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    //禁用重新尝试按钮
    self.rightButton.enabled=NO;
    
    //提供相关功能
    NSInteger purchasedCoins = 0;
    switch (self.productIndex) {
        case 0:
            purchasedCoins=300;
            break;
        case 1:
            purchasedCoins=700;
            break;
        case 2:
            purchasedCoins=1200;
            break;
        case 3:
            purchasedCoins=1800;
            break;
        default:
            break;
    }
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger oldCoins=[defaults integerForKey:@"purchasedCoins"];
    if (oldCoins) {
        purchasedCoins+=oldCoins;
    }
    [defaults setInteger:purchasedCoins forKey:@"purchasedCoins"];
    [defaults synchronize];

    
    //显示提示信息
    NSString *typeString=[NSString new];
    
    switch (_transactionType) {
        case TransactionTypePurchase:
            typeString=NSLocalizedString(@"购买",@"");
            [self.rightButton setTitle:NSLocalizedString(@"成功",@"") forState:UIControlStateNormal];
            break;
        case TransactionTypeRestore:
            typeString=NSLocalizedString(@"恢复",@"");
            [self.rightButton setTitle:NSLocalizedString(@"成功",@"") forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    NSLog(@"处理成功:%@",transaction.payment.productIdentifier);
    self.infoString=[[NSString alloc]initWithFormat:NSLocalizedString(@"-----%@成功，请返回使用!-----\n",@""),typeString];
    
    
    //关闭成功的交易
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}


-(NSString *)showTransactionErrorCode:(SKPaymentTransaction *)transaction{
    NSString *code=[NSString new];
    switch (transaction.error.code) {
        case SKErrorPaymentCancelled:
            code=NSLocalizedString(@"用户取消",@"");
            break;
        case SKErrorPaymentNotAllowed:
            code=NSLocalizedString(@"用户不允许购买",@"");
            break;
        case SKErrorPaymentInvalid:
            code=NSLocalizedString(@"参数未识别",@"");
            break;
        case SKErrorStoreProductNotAvailable:
            code=NSLocalizedString(@"没有相关产品信息",@"");
            break;
        case SKErrorClientInvalid:
            code=NSLocalizedString(@"客户端禁止购买",@"");
            break;
        case SKErrorUnknown:
            code=NSLocalizedString(@"未知错误",@"");
            break;
            
        default:
            break;
    }
    return code;
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
    //NSLog(@"paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads");
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    //NSLog(@"paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions");
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    //NSLog(@"paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue");
    
    self.infoString=NSLocalizedString(@"-----iTunes Store恢复结束-----",@"");
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error");
    
    NSString *lst1=NSLocalizedString(@"-----iTunes Store恢复失败，请重新尝试-----", @"");
    NSString *lst2=NSLocalizedString(@"错误信息", @"");
    self.infoString=[[NSString alloc]initWithFormat:@"%@\n-----%@：%@-----\n",lst1,lst2,error.localizedDescription];
    
}

@end
