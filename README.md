# xuper-sdk-oc 3.4.0

&emsp;&emsp;
### 支持的平台
iOS 8.0 +

Macos 10.15 +

&emsp;&emsp;
### 使用许可

[Apache License, Version 2.0](https://github.com/oblivioned/xuper-sdk-oc/blob/master/LICENSE).

&emsp;&emsp;
### 支持[xuperchain](https://github.com/xuperchain/xuperunion)版本

[xuperunion 3.4](https://github.com/xuperchain/xuperunion/tree/v3.4)

&emsp;&emsp;
### 暂不支持的功能
* 暂不支持提名候选人、选举候选人，投票操作使用GRPCClient直接实现，
我会尽快增加增加对应的功能。

* 赞不支持合约部署

如果您有好的实现，欢迎提交PullRequest。

&emsp;&emsp;
### 写在前面的话
&emsp;&emsp;首先按照国际惯例感谢一下xuper官方团队，超哥，小X姐姐和各位群友，在开发sdk的过程中帮我解答问题，其次说回xuper-sdk-oc本身，它一定还有很多不完善的地方，希望在未来的使用中不断的迭代和完善。您可以拿来直接使用，也可以用于学习和交流。如果有bug或者无法支撑您的需求，可以提交[Issues](https://github.com/oblivioned/xuper-sdk-oc/issues)。

&emsp;&emsp;如果对于实现的地方觉得可以改进请疯狂的发起PullRequest，一起完善！

&emsp;&emsp;
### 如何使用

#### 使用pod集成
```
# Podfile中增加
pod 'xuper-sdk-oc', '~> 3.4.0'
# 推荐增加verbose参数，因为sdk中依赖的几个仓库体积比较大，如果看不到过程，可能会感觉"假死"
pod install --verbose
```
&emsp;&emsp;
#### 引用头文件
```objc
@import xuper-sdk-oc;
```

&emsp;&emsp;
### 几个简单的例子

xuper-sdk-oc的设计上对于接口API结构与./xchain-cli 中基本相同,以下是xchain-cli --help的内容，可以作为参考。

```
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

&emsp;&emsp;
#### 1.创建,恢复密钥对/AK/Address/Wallet
其实就是创建密钥对，xuper中称作AK，在别对区块链底层技术中有叫地址（address）也有叫Wallet的，总之就是创建密钥对
##### 1.1 创建普通密钥对
```objc
// 创建支持ECDSA(P-256)模式的加解密Client
// id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyECC];
id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyDefault];

id<XCryptoAccountProtocol> ak = [cryptoClient generateKey];

NSLog(@"Addresss:%@", ak.address );
NSLog(@"Pub:%@", ak.jsonPublicKey );
NSLog(@"Priv:%@", ak.jsonPrivateKey);
```
```
Addresss:itpwtGLR9ko3Rh4VFoqbEWVdHvwSs7pDe
Pub:{"Curvname":"P-256","X":68165677964514325870125990745156897539633966970217815303239761041255685899246,"Y":89245480898787511382335978682967990758465570090069860028182616055160065719111}
Priv:{"Curvname":"P-256","X":68165677964514325870125990745156897539633966970217815303239761041255685899246,"Y":89245480898787511382335978682967990758465570090069860028182616055160065719111,"D":50281905569726161736074660621623757997950714911941262538534457267617195972925}
```

##### 1.2 创建助记词密钥对
```objc
id<XCryptoClientProtocol> cryptoClient = [XCryptoFactory cryptoClientWithCryptoType:XCryptoTypeStringKeyDefault];

// BIP39MnemonicLanguage_ChineseSimplified = BIP39MnemonicLanguage_Default,
id<XBIP39AccountProtocol> bip39Ak = [cryptoClient createNewAccountWithMnemonicLanguage:BIP39MnemonicLanguage_Default
                                                                              strength:BIP39MnemonicStrength_Midden
                                                                              password:@"xuper-sdk-oc"
                                                                                 error:nil];

NSLog(@"Mnemonic:%@", [bip39Ak.mnemonics componentsJoinedByString:@" "] );
NSLog(@"Addresss:%@", bip39Ak.address );
NSLog(@"Pub:%@", bip39Ak.jsonPublicKey );
NSLog(@"Priv:%@", bip39Ak.jsonPrivateKey);
```
```
Mnemonic:登 层 擦 吃 抛 冻 曹 初 服 陶 梅 积 增 视 现 浓 干
Addresss:jYHPGkExRt4TFeFXqMYEN9tfhfw1RNRga
Pub:{"Curvname":"P-256","X":7245309779281456427877221801096722559282836887253870979251591933549961692098,"Y":12834644077505221727140941084443560514005635867193367722928699140168025944794}
Priv:{"Curvname":"P-256","X":7245309779281456427877221801096722559282836887253870979251591933549961692098,"Y":12834644077505221727140941084443560514005635867193367722928699140168025944794,"D":54001794831206505619034640352314316246429599983818517614396205473215599362461}
```

##### 1.3 恢复密钥对
```objc
// 使用私钥恢复
id<XCryptoAccountProtocol> ak = [cryptoClient retrieveAccountByPrivateKeyJsongString:@"{\"Curvname\":\"P-256\"..."];

// 使用助记词
id<XBIP39AccountProtocol> bip39Ak = [cryptoClient retrieveAccountByMnemonic:@"登 层 擦 吃 抛 冻 曹 初 服 陶 梅 积 增 视 现 浓 干"
                                                                   password:@"xuper-sdk-oc"
                                                                   language:BIP39MnemonicLanguage_Default];
```

&emsp;&emsp;
#### 2.查询余额

查询余额，因为不需要签名，只需要地址，直接传入地址即可获取。

```objective-c
// 创建XuperClient
XuperClient *client = [XuperClient newClientWithHost:@"127.0.0.1:37101" blockChainName:@"xuper"];

// 使用account中的balanceWithAddress:handle获取余额信息
[client.account balanceWithAddress:"YourAddress" handle:^(XBigInt * _Nullable n, NSError * _Nullable error) {
    if (!error) {
        NSLog(@"Balance:%@", n.decString);
    }
}];
```

&emsp;&emsp;
#### 3.转账

直接使用 account.transfer

```objective-c
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

&emsp;&emsp;
#### 4.合约调用
```
[client.wasm invokeWithAddress:YOURADDRESS
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
           authRequireKeypairs:@[Authrequire1,Authrequire2,....]
                      feeAsker:nil
                        handle:^(XHexString  _Nullable txhash, NSError * _Nullable error) {
                       ....
}];
```

&emsp;&emsp;
#### N.[更多例子](https://github.com/oblivioned/xuper-sdk-oc/tree/master/xuper-sdk-ocTests)请见工程中的单元测试.

&emsp;&emsp;
&emsp;&emsp;
### 直接使用GRPC

如果您足够了解xuper的各种规则和GRPC的接口，可以直接使用GRPC通讯，xuper-sdk-oc中提供了一个GRPC的接口如下,GRPC的接口与[官方文档](https://xuperchain.readthedocs.io/zh/latest/commands_reference.html)一致

```objective-c
// 创建XuperClient
XuperClient *client = [XuperClient newClientWithHost:@"127.0.0.1:37101" blockChainName:@"xuper"];


// 获取rpcclient
client.rpcClient ........
```

&emsp;&emsp;
&emsp;&emsp;
### FAQ
Q：1.已知合约交互的TXID，如何再次查询合约执行完成， ctx->ok("....")返回的内容？

A：目前根据官方的源码中来看暂时是没有提供对应的方法，虽然可以使用折中的方案在xuper-sdk-oc中实现，但并非官方方案，为了不引起功能上的误解，
在官方没有决定最终的存储方案前，xuper-sdk-oc也不支持根据TXID再次获取合约的执行结果。若官方确认了方案，会第一时间增加。

&emsp;&emsp;

Q：2.下载工程后单元测试为什么没能通过？

A：请修改测试使用的配置，替换为自己的节点，测试使用的密钥，TXID等。后在尝试运行。[源码位置](https://github.com/oblivioned/xuper-sdk-oc/blob/master/xuper-sdk-ocTests/TestCommon/TestCommon.m)

&emsp;&emsp;
&emsp;&emsp;
### 写在后面的话

最近工作比较忙，还有很多需要完善的地方，不管是文档，注释还是代码的质量问题，我先上传这个测试版本本意是想在大家的试用
和学习中发现更多的问题。欢迎提交[Issues](https://github.com/oblivioned/xuper-sdk-oc/issues)与PullRequest，我会尽量在第一时间回复。
