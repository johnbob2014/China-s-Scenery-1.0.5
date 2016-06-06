//
//  InAppPurchaseViewController.h
//  贷款计算器
//
//  Created by 张保国 on 15/7/19.
//  Copyright (c) 2015年 ZhangBaoGuo. All rights reserved.
//

#import "NavigationBarVC.h"

/*! @brief 交易类型:购买 或 恢复
 *
 */
enum TransactionType {
    TransactionTypePurchase  = 0,        /**< 购买    */
    TransactionTypeRestore = 1,        /**< 恢复      */
};

@interface InAppPurchaseVC : NavigationBarVC
@property (assign,nonatomic) int productIndex;
@property (assign,nonatomic) enum TransactionType transactionType;
@end
