# xuper-sdk-oc [开发阶段！！！]

# 安装必要的依赖软件

# 如何运行

1.编译openssl
`
cd /xuper-sdk-oc/libs/openssl && ./build-libssl.sh
`

2.下载依赖
`
pos install
`

3.打开pod生成的 xuper-sdk-oc.xcworkspace 工程

4.注释代码 Annotations.pbobjc.m:18  //#import "google/protobuf/Descriptor.pbobjc.h"


4.运行测试