//
//  XTransactionOpt+Transfer.m
//  xuper-sdk-oc-iOS
//
//  Created by apple on 2019/12/6.
//  Copyright © 2019 Martin.Ren. All rights reserved.
//

#import "XTransactionOpt+Transfer.h"

@implementation XTransactionOpt(Transfer)

+ (instancetype _Nonnull) optTransferWithFrom:(XAddress _Nonnull)from
                                           to:(XAddress _Nonnull)toAddr
                                       amount:(XBigInt * _Nonnull)amount
                                      remarks:(NSString * _Nullable)remarks
                                 forzenHeight:(int64_t)forzenHeight {
    
    XTransactionOpt *opt = [[XTransactionOpt alloc] init];
    
    opt.from = from;
    opt.to = @[
        [XTranctionToAccountData toAccountDataWithAddress:toAddr amount:amount forzenHeight:forzenHeight],
    ];
    
    opt.desc = [XTransactionDesc descWithString:remarks];
    opt.desc.authRequires = @[from];

    /// 对应当个转账来说，如果xuper有实现1对多的转账而且可以分别制定在多少高度之前不生效的话，那么相当于说，output需要每一个指定frozenHeight，
    /// 那么对于事务本身而言也有一个frozenHeight，此处暂时为1对1对转账，所以可以这样赋值
    opt.frozenHeight = forzenHeight;
    
    return opt;
}

@end
