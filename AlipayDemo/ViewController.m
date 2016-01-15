//
//  ViewController.m
//  AlipayDemo
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView */
@property(nonatomic,weak) UITableView  *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupTableView];
    NSLog(@"----------didSelectRowAtIndexPath------------%@",@"didSelectRowAtIndexPath");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

// 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"PaySelectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text=@"支付宝";
        cell.detailTextLabel.text=@"测试0.01元";
    }
    
    return cell;
}

// 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self payForAlipay];
}

#pragma mark   ==============支付宝 产生随机订单号==============

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)payForAlipay
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //Product *product = [self.productList objectAtIndex:indexPath.row];
    NSString *productName = @"支付宝测试商品"; //商品标题
    NSString *productDescription = @"支付宝测试商品描述"; //商品描述
    NSString *amount = @"0.01"; //商品价格
    NSString *notifyURL = @"http://www.xxx.com"; //回调URL
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088811956033819"; // 这是支付宝文档里的测试账号
    NSString *seller = @"xinyuxingbangxinxi@163.com"; // 这是支付宝文档里的测试账号
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJ3U/F+CuYUTwIlefRyWcwNvecIx756fbYFKp3Ymfy3MNdzccPc7Kk62RKCpVTgshHGVx0UUpRGzSV1y6M17teOTY/1KVSxhB6wvlOkTxF9SYiXWyr6ioHyl1etxjnQOtL0zqA3ID1vjOzMZZXM0+QE8dnc3rXoOSE7xOvkIb+RJAgMBAAECgYAdE0Rer+1PN6FLbQ2tO4X6hwmuHZbf6My6ea8508OwAyOVCUMCOHMFxwwDcM5TJ9hKOGZaMoBqL1X/khCS8gxCkwVEsIqr0/A4b2wBcJqtYXYx9onhUDjpfc/DjJ/DJx0VDDuEpeM5++djBTDxEjzDmEgK27trfPwm7cNbJjxPJQJBANb6bBpmUnml22bUu4jMeVAQZekg+ho3tMr8aa/np0CK8Jdq9je/HBhPXkVMGDhXlX4hAOYGI6wF2vrmz7ExRdMCQQC78v+lCXRtmsMzJQzE6tZAVG8ErFYpfm+23Ebn+36w8E+VNT+8wquoCD8tXsBssvBwdT6ZRqmEeEV77mdZ18/zAkBvcl1OhlMlW1VVht09uvr9BbM/W2gs5UolnRtRJN+w9xZo+PtxxPJUq/isJhm8Q7NtMsDbfr1JdbOjNLrhGjEfAkEArFeroeskjuit+7UKm3r3ka+ayX851vywdc5RWqGbz6XcY+abFnyvqPo+7FyJOGNw5L4t86D/CpC6rmSy8ohZjwJBALiHGihuWHU8Xw9Qz5l6nWzN2w/vQa9Brm3XOkVLfoirPdOx0oo6OU7wwdgBMz+86+QLMAwx+ZooIHpGiZ0mWR8=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[amount doubleValue]]; //商品价格
    order.notifyURL =  notifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkPaydemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        NSLog(@"%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            // 这里填写需要回调的页面，比如，跳转到支付成功页面。
            //            BSPayResultViewController *payState = [[BSPayResultViewController alloc] init];
            //            payState.title =[resultDic[@"resultStatus"] isEqualToString:@"9000"]?@"支付成功": @"支付失败";
            //            payState.orderId = self.paymentModel.order_id;
            //            payState.amount = self.paymentModel.order_amount;
            //            payState.payType = @"支付宝支付";
            //            payState.failure = resultDic[@"memo"];
            //            [self.navigationController pushViewController:payState animated:NO];
        }];
    }
    
}


@end
