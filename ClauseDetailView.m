//
//  ClauseDetailView.m
//  St.Petersburg
//
//  Created by 刘 吕琴 on 14-6-12.
//  Copyright (c) 2014年 Jiayi. All rights reserved.
//

#import "ClauseDetailView.h"
#define TITTLE_STR(tittle) [NSString stringWithFormat:@"<b>\n%@</b>",tittle]
#define TEXT_STR(text) [NSString stringWithFormat:@"<p indent=26>%@</p>",text]
@implementation ClauseDetailView
backButton
- (void)viewDidLoad{
    self.title = @"会员服务条款";
    NSArray *strArr =  @[@"1.俄罗斯旅游中文网会员服务条款的确认",
                         @"俄罗斯旅游中文网各项服务的所有权与运作权归广州家亿网络科技有限公司(以下简称“家亿”)所有。本会员服务条款具有法律约束力。 一旦您点选\"注册\"并通过注册程序，即表示您自愿接受本协议之所有条款，并已成为俄罗斯旅游中文网的注册会员。",
                         @"2.服务内容",
                         @"俄罗斯旅游中文网服务的具体内容由家亿提供并对其所提供之服务拥有最终解释权。",
                         @"3.会员帐号及密码",
                         @"您注册会员成功后，将得到一个帐号和密码。您应妥善保管该帐号及密码，并对以该帐号进行的所有活动及事件负法律责任。因黑客行为或会员保管疏忽致使帐号、密码被他人非法使用的，家亿不承担任何责任。如您发现任何非法使用会员帐号或安全漏洞的情况，请立即与俄罗斯旅游中文网管理员联系。",
                         @"4.会员权责",
                         @"-- 会员有权按照俄罗斯旅游中文网规定的程序和要求使用俄罗斯旅游中文网向会员提供的各项网络服务，如果会员对该服务有异议，可以与俄罗斯旅游中文网联系以便得到及时解决。",
                         @"-- 用户在申请使用俄罗斯旅游中文网会员服务时，必须向俄罗斯旅游中文网提供准确的个人资料，如个人资料有任何变动，必须及时更新。",
                         @"-- 会员须同意并接受俄罗斯旅游中文网通过电子邮件、手机短信、电话外呼等方式向会员发送促销或其他相关商业信息(如预定确认、信息变更、资讯、活动等)。",
                         @"-- 会员在俄罗斯旅游中文网的网页上发布信息或者利用俄罗斯旅游中文网的服务时必须符合国家的法律法规以及国际法的有关规定。",
                         @"-- 对于会员上传到俄罗斯旅游中文网网站上信息可公开获取区域(包括但不限于BBS、评论)的任何内容，会员同意授予家亿享有完全的、免费的、永久性的、不可撤销的、非独家的权利，以及再许可第三方的权利，以使用、复制、修改、改编、出版、翻译、据以创作衍生作品、传播、表演和展示此等内容(整体或部分)，和/或将此等内容编入当前已知的或以后开发的其他任何形式的作品、媒体或技术中。",
                         @"-- 会员承诺不会通过俄罗斯旅游中文网的信息发布平台(包括但不限于、BBS、评论)发布如下信息：",
                         @"(1) 反对宪法所确定的基本原则的;",
                         @"(2) 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的;",
                         @"(3) 损害国家荣誉和利益的;",
                         @"(4) 煽动民族仇恨、民族歧视，破坏民族团结的;",
                         @"(5) 破坏国家宗教政策，宣扬邪教和封建迷信的;",
                         @"(6) 散布谣言，扰乱社会秩序，破坏社会稳定的;",
                         @"(7) 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的;",
                         @"(8) 侮辱或者诽谤他人，侵害他人合法权益的;",
                         @"(9) 含有法律、行政法规禁止的其他内容的。",
                         @"-- 会员单独为其发布在俄罗斯旅游中文网上信息承担责任。会员若在俄罗斯旅游中文网散布和传播违法信息，网络会员服务的系统记录有可能作为会员违法之证据。",
                         @"-- 会员不得以任何方式干扰本站的服务。",
                         @"-- 如果会员违反上述规定，家亿有权要求其改正或直接采取一切必要措施(包括但不限于更改或删除会员发布的信息、中断或终止会员使用网络的权利等)。",
                         @"鉴于网络服务的特殊性，家亿保留随时修改或中断其部分或全部网络服务的权利，并无需通知会员或为此对会员及任何第三方负责。",
                         @"7.会员隐私保护",
                         @"家亿尊重会员的隐私权，不会公开或泄露任何有关会员的个人资料以及会员在使用网络服务时存储在俄罗斯旅游中文网的非公开内容，但以下情况除外：",
                         @"-- 本网站已经声明该部分内容将被公开，而用户在知道的情况下仍然提供信息;",
                         @"-- 国家的司法机关或政府相关部门依据法规要求获得该用户的相关信息;",
                         @"-- 用户的信息可以从其它的公开渠道获得(如：公共网吧内，用户没有注销界面，而导致信息外泄);",
                         @"-- 本网站谨慎地确认有必要公布用户的信息时(如该用户提供的信息误导浏览者或用户提供的信息含有欺诈性等)。",
                         @"8.中断或终止服务",
                         @"如发生下列任何一种情形，家亿有权随时中断或终止向会员提供本协议项下的网络服务，而无需对会员或任何第三方承担任何责任。",
                         @"-- 会员向家亿提供的个人资料不真实。",
                         @"-- 会员违反本协议的规则或不履行其所承担的义务。",
                         @"除此之外，会员可随时根据需要通知家亿终止向该会员提供服务，会员服务终止后，会员使用服务的权利同时终止。自会员服务终止之时起，俄罗斯旅游中文网不再对该会员承担任何责任或义务。",
                         @"9.知识产权",
                         @"-- 俄罗斯旅游中文网上的内容，包括但不限于文字、图形、图像、音乐、录像、标示、标识、广告、版面设计、专栏目录、链路、图表按钮、HTML编码、商标与及软件等其他材料均受著作权、商标法等相关法律的保护，并且也受适用于国际公约中有关著作权、商标权、专利权及财产所有权法律的保护。俄罗斯旅游中文网的内容归属俄罗斯旅游中文网或俄罗斯旅游中文网供应商或客户的专有财产。未经许可，不得擅自挪作他用，否则将追究法律责任。",
                         @"-- 为方便用户，俄罗斯旅游中文网内设有与其它网站或网页的链接，但俄罗斯旅游中文网并不对这些网站或网页进行维护，用户启用该网站或网页链接所产生的一切风险，概与俄罗斯旅游中文网无关。",
                         @"-- 俄罗斯旅游中文网上的部分内容来自互联网，部分内容由于不便校对版权或内容的真实性和准确性，所以可能暂时无法确认版权或内容的真实性和准确性，由此而引起的版权问题或其他问题，请致电或电邮俄罗斯旅游中文网。经核实后会立即予以删除或更改。",
                         @"10.免责声明",
                         @"-- 用户提供的信息仅代表其个人的立场与观点，与本网站的立场和观点无关。",
                         @"-- 本网站对用户或第三方的以下损失概不承担任何责任：",
                         @"A 用户提供的信息由于不正确、不完整、不及时而导致的用户自身的损失;",
                         @"B 用户因错误理解和使用、复制或传播本网站上的内容而造成的损失、损害或用户提供的信息涉及侵犯他人的版权、署名权等纠纷，纯属其个人行为，与本网站无关。",
                         @"C 用户通过本网站而获得的链接或通过链接获得的产品、服务或信息内容上的缺陷(如：内容的不完整、不及时等)与本网站概不相关，因本网站仅提供链接的渠道，而不负责对该网站或网页的维护。",
                         @"D 因互联网本身的原因而引起的问题(如：网站服务导致的执行失败、错误、计算机病毒或计算机的硬件问题等而导致的问题)与本网站无关。",
                         @"-- 本网站上提供的信息仅供用户参考。若用户或浏览者要使用，须进一步的调查与核实，否则引起的一切损失，本网站概不负责。",
                         @"-- 本网站上的部分内容(如：图片)来源于互联网，因互联网上的作品权利人身份不便确认，故可能有部分内容涉及版权问题。若经核实涉及版权问题，本网站将即时予以删除或更正。",
                         @"-- 本网站有权在本网站内使用用户在本网站上发表的信息(包括但不限于图片、游记等)。但用户在本网站上发表的信息若其它浏览者要转载，需经过本网站和该用户的许可，否则视为侵权。",
                         @"因用户违反本法律声明而引发的任何一切索赔、损害等等，本网站概不负责。",
                         @"11.法律",
                         @"家亿服务条款之效力、解释、执行均适用中华人民共和国法律。如发生争议，应提交至有管辖权之法院。"];
    NSMutableString *contentStr = [NSMutableString string];
    for (NSString *str in strArr) {
        if ([str rangeOfString:@"."].length==1)
        {
            [contentStr appendString:TITTLE_STR(str)];
        }else [contentStr appendString:TEXT_STR(str)];
    }
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sv.backgroundColor = BLACK_VIEW_COLOR;
    RTLabel *lab = [[RTLabel alloc]initWithFrame:CGRectMake(10, -10, 300, 0)];
    
    lab.lineSpacing = 10;
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = contentStr;
    lab.frame = CGRectMake(10, -10, 300, [lab optimumSize].height);
    [sv addSubview:lab];
    sv.contentSize = CGSizeMake(320, 30+lab.frame.size.height);
    [self.view addSubview:sv];
}
@end
