# xuper-sdk-oc 0.0.1-beta

## 为了质量保证，请暂时勿使用在自己的产品中

目前为先行测试版本[v0.0.1](https://github.com/oblivioned/xuper-sdk-oc/tree/v0.0.1)  
本次预先发布主要是为了验证pod的集成过程，后续会编写一个demo.

## License

[Apache License, Version 2.0](https://github.com/oblivioned/xuper-sdk-oc/blob/master/LICENSE).

### 支持的平台

iOS 8.0 +  
Macos 10.9 +

### 支持[xuperchain](https://github.com/xuperchain/xuperunion)版本

[xuperunion 3.4](https://github.com/xuperchain/xuperunion/tree/v3.4)

### 如何使用

#### 使用pod集成

```shell
# Podfile中增加
pod 'xuper-sdk-oc', '~> 0.0.1'
# 推荐增加verbose参数，因为sdk中依赖的几个仓库体积比较大，如果看不到过程，可能会感觉"假死"
pod install --verbose
```

#### 引用头文件

```objc
#import <xuper-sdk-oc/xuper-sdk-oc.h>
@import xuper-sdk-oc;
```

### 几个简单的例子

xuper-sdk-oc的设计上对于接口API结构与./xchain-cli 中基本相同,以下是xchain-cli --help的内容，可以作为参考

```shell
  account     Operate an account or address: balance|new|newkeys|split.
  acl         Operate an access control list(ACL): query.
  block       Operate a block: [OPTIONS].
  createChain Operate a blockchain: [OPTIONS].
  genModDesc  Generate modified blockchain data desc: [OPTIONS].
  help        Help about any command
  multisig    Operate a command with multisign: check|gen|send|sign|get.
  native      [Deprecated] Operate a native contract: activate|deactivate|deploy|invoke|query|status.
  netURL      Operate a netURL: gen|get|preview.
  status      Operate a command to get status of current xchain server
  tdpos       Operate a command with tdpos, query-candidates|query-checkResult|query-nominate-records|query-nominee-record|query-vote-records|query-voted-records|status
  transfer    Operate transfer trasaction, transfer tokens between accounts or aks
  tx          Operate tx command, query
  vote        Operate vote command
  wasm        Operate a command with wasm, deploy|invoke|query
```

#### 1. 查询余额

查询余额，因为不需要签名，只需要地址，直接传入地址即可获取。  

```objc
// 创建XuperClient
XuperClient *client = [XuperClient newClientWithHost:@"127.0.0.1:37101" blockChainName:@"xuper"];

// 使用account中的balanceWithAddress:handle获取余额信息
[client.account balanceWithAddress:"YourAddress" handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
    if (!error) {
        NSLog(@"Balance:%@", n.decString);
    }
}];
```

#### 2. 转账方法一 (与 ./xchain-cli tansfer --to=... --amount=... --fee=... 类似)

直接使用 account.transfer  

```objc
// 1.使用已有的密钥创建ak对象(请自行贴入内容)
XECDSAPrivKey *accountPk = [XECDSAPrivKey fromExportedDictionary:@{
    @"Curvname":@"P-256",
    @"X":@"74695617477160058757747208220371236800000000000000000000000000000000000000000",
    @"Y":@"51348715319124770392993866417088542400000000000000000000000000000000000000000",
    @"D":@"29079635126530934056640915735344231900000000000000000000000000000000000000000"
}];

XECDSAAccount *ak = [XECDSAAccount fromPrivateKey:accountPk];

// 2.使用SDK提供的API进行转账
XBigInt *amount = [[XBigInt alloc] initWithDecString:@"10"];

[client.transfer transferWithFrom:ak.address
                               to:@"eqMvtH1MQSejd4nzxDy21W1GW12cocrPF"
                           amount:amount
                           remarks:@"这是一个转账备注"
                      forzenHeight:0
                     initorKeypair:account
               authRequireKeypairs:@[account]
                            handle:^(XHexString  _Nullable txhash, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"TXID:%@", txhash);
        }
}];
```

#### 3. 转账方法二，使用TransactionOpt,XTransactionBuilder组装交易，Opt的类型较多可见源码 [XTransaction](https://github.com/oblivioned/xuper-sdk-oc/tree/master/xuper-sdk-oc/XTransaction)的相关实现

```objc
// 1.创建转账使用的Opt对象，这里xuper-sdk-oc提供了一个便捷的创建方法
XTransactionOpt *opt = [XTransactionOpt optTransferWithFrom:ak.address
                                                         to:@"eqMvtH1MQSejd4nzxDy21W1GW12cocrPF"
                                                     amount:amount
                                                    remarks:remarks
                                                forzenHeight:forzenHeight];

// 2.使用Opt对象、签名使用的密钥对，直接生成一个带签名的交易并且发送,此处需要注意block的嵌套使用.
[XTransactionBuilder trsanctionWithClient:self.clientRef
                                       option:opt
                               ignoreFeeCheck:NO
                                initorKeypair:initorKeypair
                          authRequireKeypairs:authRequireKeypairs
                                       handle:^(Transaction * _Nullable tx, NSError * _Nullable error) {

        if ( error ) {
            return handle(nil, error);
        }

        TxStatus *tx_status = TxStatus.message;
        tx_status.header = TxStatus.getRandomHeader;
        tx_status.bcname = self.blockChainName;
        tx_status.status = TransactionStatus_Unconfirm;
        tx_status.tx = tx;
        tx_status.txid = tx.txid;

        [client postTxWithRequest:tx_status handler:^(CommonReply * _Nullable response, NSError * _Nullable error) {
            ....
        }];

    }];
```

#### 4. 合约调用

```objc
[clientinvokeWithAddress:YOURADDRESS
            authRequires:@[@"AuthRequire1", @"AuthRequire2",...]
            contractName:@"ERC20"
              methodName:@"transfer"
                            args:@{
                                @"from"    : @"Martin",
                                @"to"      : @"Bob",
                                @"token"   : @"10"
                            }
             forzenHeight:0
            initorKeypair:INITOR
      authRequireKeypairs:@[T.initor]
                 feeAsker:nil
                   handle:^(XHexString  _Nullable txhash, NSError * _Nullable error) {
                       ....
}];
```

#### 5. [更多例子](https://github.com/oblivioned/xuper-sdk-oc/tree/master/xuper-sdk-ocTests)请见工程中的单元测试

### 直接使用GRPC

如果您足够了解xuper的各种规则和GRPC的接口，可以直接使用GRPC通讯，xuper-sdk-oc中提供了一个GRPC的接口如下,GRPC的接口与[官方文档](https://xuperchain.readthedocs.io/zh/latest/commands_reference.html)一致

```objc
// 创建XuperClient
XuperClient *client = [XuperClient newClientWithHost:@"127.0.0.1:37101" blockChainName:@"xuper"];


// 获取rpcclient
client.rpcClient ........
```

### 写在后面的话

最近工作比较忙，还有很多需要完善的地方，不管是文档，注释还是代码的质量问题，我先上传这个测试版本本意是想在大家的试用和学习中发现更多的问题。欢迎提交[Issues](https://github.com/oblivioned/xuper-sdk-oc/issues)与pullrequest，我会尽量在第一时间回复。
