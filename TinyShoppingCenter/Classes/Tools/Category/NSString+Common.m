//
//  NSString+Common.m
//  yingzi_iOS
//
//  Created by liyongwei on 15/7/31.
//  Copyright (c) 2015年 lyw. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

/**
 *  数字字符串加入逗号位数分隔
 */
+ (NSString *)countNumAndChangeformat:(NSString *)num
{
    NSString *firstStr = @"";
    NSString *lastStr = @"";
    if ([num containsString:@"."]) {
        NSArray *arr = [num componentsSeparatedByString:@"."];
        firstStr = [arr firstObject];
        lastStr = [arr lastObject];
    }else{
        firstStr = num;
    }
    
    int count = 0;
    long long int a = firstStr.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:firstStr];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    NSString *resStr = @"";
    if (![lastStr isEqualToString:@""]) {
        resStr = [NSString stringWithFormat:@"%@.%@",newstring,lastStr];
    }else{
        resStr = newstring;
    }
    return resStr;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size
                                        options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                     attributes:@{NSFontAttributeName: font}
                                        context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

//内连，使用情况较多下使用，

//static inline NSString * GetUUIDString()
//
//{
//    CFUUIDRef uuidObj = CFUUIDCreate(nil);
//
//    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
//
//    CFRelease(uuidObj);
//
//    return uuidString;
//
//}


// 获取uuid的类方法，建议新建NSString的分类使用，

//NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];//获取设备的udid
+ (NSString*) getUUIDString
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
}


// 获取字符串的长度    高度固定
+(CGFloat)countLength:(NSString*)text  withFont:(UIFont*) font{
    CGRect frame = CGRectMake(0, 0, 200, 200);
    CGRect newframe = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    CGFloat lenth = newframe.size.width;
    return lenth;
}
//字符串是否包某字符
+ (BOOL)string:(NSString*) stringg isContantStr:(NSString*)str
{
    //判断roadTitleLab.text 是否含有qingjoin
    if([stringg rangeOfString:str].location !=NSNotFound)//_roaldSearchText
    {
        return YES;
    }
    else
    {
        return NO;
    }

}
// 判断 是否是 email
+ (BOOL)isEmail:(NSString *)email
{
//    NSString *number= @"^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]{2}|net|NET|com|COM|gov|GOV|mil|MIL|org|ORG|edu|EDU|int|INT)$";
//    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
//    return [numberPre evaluateWithObject:email];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断 是否是 mobile
+ (BOOL)isMobile:(NSString *)mobile
{
    NSString *number = @"^((13[0-9])|(15[^4])|(16[0-9])|(18[0-9])|(19[0-9])|(17[0-8])|(14[5,7]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:mobile];
}

// 判断 是否是 座机号码
+ (BOOL)isLandlineTelephone:(NSString *)telephone
{
    
    //验证输入的固话中不带 "-"符号
//    NSString * strNum = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    
    //验证输入的固话中带 "-"符号
    
    NSString * strNum = @"^(0[0-9]{2,3}-)?([2-9][0-9]{6,7})+(-[0-9]{1,4})?$|(^(13[0-9]|15[0|3|6|7|8|9]|18[8|9])\\d{8}$)";
    NSPredicate *predicateNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strNum];
    return [predicateNumber evaluateWithObject:telephone];
}

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 判断 是否是 testCode
+ (BOOL)isPinCode:(NSString *)testCode
{
    NSString *number = @"^[0-9]{6}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:testCode];
}
+ (BOOL)isPassWord:(NSString *)passWord
{
    NSString *number = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:passWord];
}
// 验证价格是否格式正确
+ (BOOL)isCheckPrice:(NSString *)price
{
    if (price == nil || [price isEqualToString:@""]){
        return NO;
    }
    
    NSString *exp1 = @"^[1-9][0-9]{0,7}";
    NSString *exp2 = @"^[1-9][0-9]{0,7}[.][0-9]{1,2}";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp1];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp2];
    
    if ([predicate1 evaluateWithObject:price] || [predicate2 evaluateWithObject:price])
    {
        return YES;
    }
    
    return NO;
}

// 验证登录名是否由6-20位字母或数字组成
+ (BOOL)isCheckLoginUserName:(NSString *)userName
{
    if (userName == nil || [userName isEqualToString:@""]){
        return NO;
    }
    
    NSString *exp1 = @"^[A-Za-z0-9]{6,20}$";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp1];
    
    if ([predicate1 evaluateWithObject:userName])
    {
        return YES;
    }
    
    return NO;
}

// 验证搜索的用户名是否为字母与数字组成 不超过20位
+ (BOOL)isCheckSearchUserName:(NSString *)userName
{
    if (userName == nil || [userName isEqualToString:@""]){
        return NO;
    }
    
    NSString *exp1 = @"^[A-Za-z0-9]{1,20}$";
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exp1];
    
    if ([predicate1 evaluateWithObject:userName])
    {
        return YES;
    }
    return NO;
}


//换行
+ (NSString *)changeResponsibilityAndReqireMent:(NSString *)str
{
    NSString * resStr;
    BOOL isContaint = [NSString string:str isContantStr:@"<br/>"];
    if (isContaint) {
        resStr = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    }else{
        return str;
    }
    return resStr;
}

//只输入数字
+ (BOOL)validateNumber:(NSString *)number{
    
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:number];
}

/**检测是否合法的银行卡号*/
+ (BOOL)isCheckCardNo:(NSString*)cardNumber{
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
@end
