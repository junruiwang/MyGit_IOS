//
//  RegistViewController.h
//  JinJiangTravelPlus
//
//  Created by jerry on 12-12-18.
//  Copyright (c) 2012年 JinJiang. All rights reserved.
//

#import "JJViewController.h"
#import "RegistParser.h"
#import "LoginParser.h"
#import "UserInfo.h"
#define JJ_MEMBER_PROTOCOL @"\n\t\t\t会员条款与细则\n\n\t欢迎您成为“锦江礼享+”会员。加入“锦江礼享+”即表示您同意遵守以下条款和细则，因此，请仔细阅读并全面了解。有关“锦江礼享+”的最新条款和细则可浏览www.jinjiang.com, 亦可致电1010-1666向“锦江礼享+”客户服务中心查询。\n\n\t锦江礼享+”计划及“锦江旅行家”网站由上海锦江国际电子商务有限公司（以下简称锦江电商）实施管理和运营，所提供的服务将按照本条款与规则以及锦江电商发布的其他条款、规则、协议等执行。\n\n\t本计划通过发行“锦江礼享+”会员卡，会员可以享受线下消费积分、以及“锦江旅行家”网站提供的各种预订服务等。\n\n\t在您提交申请前请详细阅读、充分理解本条款与规则及其修改。用户申请成为“锦江礼享+”的会员，即表示用户同意与锦江电商达成协议并接受本条款与规则。如用户不同意本条款与规则的内容，请立即停止申请或注册\n\n\t锦江电商保留限制、延缓、中止或取消本计划的权利，并提前 90天以书面通知的形式通过在本公司网站公告方式告知当前所有会员和公众。\n\n\t1、会员的申请\n\n\t1.1 资格\n\t凡年龄符合其常住国家/地区法律允许参加常客计划年龄要求的个人均有资格提出申请。\n\n\t1.2 申请方式\n\t客户可以以下方式申请获得“锦江礼享+”会员资格：\n\t1.2.1 至锦江国际集团下属参与本计划的各家门店提出申请。我们将会在“锦江旅行家”网站公布参与本计划的门店的名单及具体的地址。\n\t1.2.2 登录“锦江旅行家”网站申请注册及付费。\n\t1.2.3 从2011年12月25日起，原锦江国际集团旗下的企业发行的锦江之星蓝鲸卡、锦尚卡、红枫卡、家园卡的会员，原执行的客户激励计划，将转入到锦江电商，并自动将其转为“锦江礼享＋”的会员。关于老卡升级的政策、有效期限等详情请见我们发出的通知及相应政策。\n\n\t2、取消资格\n\t2.1 锦江电商保留出于以下原因（但不仅限于以下原因）取消会员资格的权利：\n\t2.1.1 违反条款与规则；\n\t2.1.2 信息中存在虚假陈述，或对本计划有不当使用；\n\t2.1.3 会员特别待遇的使用违反法律、法规或者善良风俗；\n\t2.1.4 未支付消费费用；\n\t2.1.5 向参与该计划门店支付的支票由于资金不足被退回，或者由于任何原因该支票无效；\n\t2.1.6 涉及本计划任何内容的欺诈或滥用；\n\t2.1.7 对门店或锦江国际集团员工进行身体、言语或书面的攻击、伤害；\n\t2.1.8 以任何其它形式对本计划成员造成损害。\n\t2.2 所有上述会员资格取消条件由锦江电商单方全权决定。锦江电商可以不需对任何个人或第三方负责而随时中断服务。会员不服取消会员资格的，可以申诉一次。用户申诉的，锦江电商组织复查后的决定为终局决定。\n\t2.3 会员服务结束后，锦江电商将不再对会员承担任何义务，但可以继续保存用户的注册信息及使用锦江电商服务期间的交易信息。\n\t3、关于“锦江礼享＋”会员卡 会员在获得“锦江礼享＋”会员卡后，即可享受锦江国际集团下属参与本计划的各家门店的特殊服务和优惠。具体的优惠和服务可能有所变更，并且随门店和地理区域而不同。客户可免费加入“锦江礼享＋”礼计划成为经典卡会员（即将推出，敬请期待）或付费加入享计划成为享卡会员或悦享卡会员，并享受因门店和地区而异的各项优惠。\n\t3.1 会员卡 \n\t3.1.1 入会申请审核通过后，您将获得锦江电商核发的专属会员卡。\n\t3.1.2 已经在门店申请“锦江礼享＋”会员卡的会员，或由原锦江国际集团旗下企业发行会员卡转入的会员，可以登录“锦江旅行家”网站，按操作提示将激活会员账户，被激活的会员账户将可在“锦江旅行家”网站享受各种预订服务。\n\t3.1.3 在“锦江旅行家”网站直接注册的会员可直接享受网站提供的各种预订服务。用户在“锦江旅行家”网站注册成为会员，一旦成功消费，我们将向您寄出“锦江礼享＋”会员卡。\n\t3.1.4 会员卡为锦江国际集团之财产，会员享有依照本条款与规则规定的使用权，锦江国际集团有权撤销、中止该卡的效力或终止您的会籍。\n\t3.1.5 您的专属会员卡只供您本人使用，请勿转借或让与。若会员卡遗失或被窃，请立即通知锦江电商，由我们按相关规定和流程为您办理补卡手续。\n\t3.1.6 享受锦江电商及上海锦江国际集团旗下关联企业任何优惠或参与任何活动时，请您主动出示会员卡。\n\t3.1.7 请注意，您在消费旅行社的旅游产品时，只有通过现金、银行卡或锦江e卡通进行消费，才能享受会员卡相关的优惠政策，如其他代币券卡等不能再享受折扣优惠。\n\t3.2 会籍与礼遇 \n\t3.2.1 礼会员 以积分为手段，通过重复购买而赚取积分的一种会员形式，会员可根据等级享受不同的积分礼遇。\n\t3.2.2 享会员 \n\t1）享卡：支付人民币158元即可成为享卡会员，有效期2年。会籍到期前3个月开始可以续费，续费应支付人民币20元，有效期从原有有效期基础上延期2年。到期后的任意时间仍可续费，续费应支付人民币20元，有效期自续费当天算起2年。\n\t2）悦享卡：支付人民币1858元即可成为悦享会员，有效期1年。会籍到期前3个月内可以续费，续费应支付人民币1388元，有效期从原有有效期基础上延期1年。若是享卡会员只需支付人民币1699元即可升级成为悦享会员。当悦享会籍过期后，客户的悦享会员级别降为享卡会员，有效期2年。享卡会籍过期后，可以先续费享卡（支付人民币20元），再付费升级成悦享卡（支付人民币1699元）。\n\t3）无限享卡：由常客中心从悦享会员中择优邀请成为无限享卡会员，有效期1年，并可享受对应的会员礼遇。当无限享卡会籍过期后，客户的无限享会员级别降为享卡会员，有效期2年。\n\t4）锦江电商有权每年度对以上价款及相应的待遇和有效期进行审核和调整，如有变更，将提前至少30天在官方网站公告，且调整将不影响已经按照现有规则获得相应卡的会员的待遇享受到有效期满。请会员经常登录并留意官方网站相关内容。\n\t3.2.3 权益使用说明 如欲了解更详细的权益使用说明，请参阅我们的会员指南 \n\t4、会员的管理\n\t4.1 会员在使用锦江电商提供的服务时，必须符合中国有关法规的规定。\n\t4.2 会员保证，不以任何形式干扰锦江电商及“锦江旅行家”提供的服务。\n\t4.3 会员保证，遵守锦江电商发布的所有条款、规则和程序。\n\t4.4 根据相关法律规定，会员不得在锦江电商及“锦江旅行家”网页上或者利用锦江及“锦江旅行家”的服务制作、复制、发布、传播以下信息：\n\t4.4.1 反对宪法所确定的基本原则的；\n\t4.4.2 危害国家安全、泄露国家秘密、颠覆国家政权、破坏国家统一的；\n\t4.4.3 损害国家荣誉和利益的；\n\t4.4.4 煽动民族仇恨、民族歧视、破坏民族团结的；\n\t4.4.5 破坏国家宗教政策、宣扬邪教和封建迷信的；\n\t4.4.6 散步谣言、扰乱社会秩序、破坏社会稳定的；\n\t4.4.7 散步淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n\t4.4.8 侮辱或者诽谤他人、侵害他人合法权益的；\n\t4.4.9 含有法律、行政法规禁止的其他内容的。\n\t4.5 会员保证，不利用锦江电商及“锦江旅行家”网页从事以下活动：\n\t4.5.1 未经允许，进入计算机信息网络或使用计算机信息网络资源；\n\t4.5.2 未经允许，对计算机信息网络功能进行删除、修改或者增加；\n\t4.5.3 未经允许，对进入计算机信息网络中存储、处理或者传输的数据和应用程序进行删除、修改或者增加；\n\t4.5.4 故意制作、传播计算机病毒等破坏性程序\n\t4.6.7 其他危害计算机信息网络安全的行为。\n\t4.6 如锦江电商发现会员实施上述内容，锦江电商可以采取立即停止会员账户、停止为会员提供服务、保存有关记录、向有关国家机关报告等措施，而不承担任何责任。\n\t5、会员的账号、密码和安全性\n\t5.1 会员在注册时应提供真实的个人信息，并在该信息变更时及时到网站中更新，在“锦江礼享＋”注册时可能会要求用户提供身份证等认证信息，我们将根据隐私权政策妥善的保管用户个人信息，用户因信息不准确及更新不及时而导致的任何损失均由用户自行承担。\n\t5.2 会员请妥善保管自己的账号和密码。我们建议会员不应设置生日等易于被盗用的信息作为密码，并定时更换密码。如果会员未保管好自己的账号和密码而对会员自己、锦江电商或第三方造成的损害，用户将承担全部责任。\n\t5.3 会员账户中的所有活动和事件均视为会员的活动，会员应对其承担全部责任。如会员发现任何账号被非法使用及产生安全漏洞的情况，请及时通知锦江电商，以便我们采取措施。\n\t6、商旅信息服务\n\t6.1 会员可以登录“锦江旅行家”网站享受商旅信息服务，预订机票、酒店、旅游、租车等锦江国际集团旗下企业提供的服务。\n\t6.2 会员使用预订服务，根据网站的设置提交订单后，只有经过锦江电商的审核确认，订单方能成立。用户在支付完成后并经过锦江电商或相应服务提供者的确认，合同或者预约合同方生效，锦江旅行家网站相关业务条款另有约定的，从其约定。\n\t6.3 根据中华人民共和国国家或者某些地方相关法律法规的规定，某些类型的服务须签订书面合同，因此某些服务的提供应以签订纸质书面合同为基础，此种情况下的权利义务以双方签订的纸质书面合同为准。\n\t6.4 若发生系统错误，价格等信息录入错误，网络堵塞等页面显示信息与真实情况不符的，构成《中华人民共和国合同法》第54条所称的“重大误解”，锦江电商或相关服务提供商经通知会员，可以撤销相关订单，终止提供相应服务。锦江电商或相关服务商深知任何此类事件若非妥善处理可能影响企业品牌声誉，因此承诺依照诚实信用原则谨慎行使上述权利。会员亦同意，在发生此等情况时予以理解，支持和配合，不提出异议或者索赔。\n\t6.5 在发生上述6.4所述价格等信息录入错误时，会员同意，锦江电商和/或相关服务提供商可以通知用户单方解除合同，且无需承担违约责任或者继续履行。用户已经付款的，所付款项将按照原渠道退回。为保障消费者合法权益，锦江电商应将上述解除合同的理由通知当地消费者权益保护机构，接受监督。\n\t7、关于支付\n\t7.1 会员可选择您持有的支持电话支付的银行卡进行支付，电话支付请按系统语音提示操作，我们的客服人员不会要求您提供银行卡号与密码，请注意防范电话支付的相关风险。\n\t7.2 锦江电商将接受有资质的网络银行及非金融支付机构支付平台提供的支付服务，会员应通过前述方式完成网上支付行为，为降低在线支付的相关风险，建议会员采取将本网站收藏、避免在公共场合进行支付等措施，确保安全。\n\t7.3 会员须保证，使用或绑定的银行卡等支付凭证应当是本人所有。否则，一切相关风险均由会员自行承担\n\t8、隐私保护 \n\t8.1 锦江电商重视客户隐私，依据国家法律规定对个人信息进行保护，我们特此提醒会员注意，在申请会员资格或长期享受会员优惠礼遇的过程中，为了使锦江电商能够按此计划履行各项义务，接受并且明确授权会员在入会时或行使奖励计划会员资格过程中所提供的个人信息：\n\t8.1.1 由锦江电商、锦江国际集团下属机构、附属机构或特许经销代理以及“锦江礼享＋ ”服务中心等进行数据控制和管理；\n\t8.1.2 可以在全球范围内传送给此计划下隶属锦江国际集团的任何第三方，或者代表本公司处理会员的个人信息的第三方，或者受相关法律要求、或在公司重组、合并或收购的情况下，出于会员记录管理、宾客服务、广告、市场营销和通信目的使用这些信息。出于营销目的，我们或这些机构可能会通过邮寄、传真、电话或电子邮件与会员联系。另外，我们提供一项额外的增值服务， 由我们的合作公司向会员发送会员感兴趣或有价值的产品或服务信息，因此我们会向这些公司提供“锦江礼享＋”会员的联系方式。如果会员不想加入这些第三方的联系和/或邮件列表，请向我们提出申请，要求资料从发送表中删除。\n\t8.2 如欲了解更详细的隐私条款与规则，请参阅我们的隐私权政策。\n\t9、拒绝提供担保和免责声明\n\t9.1 通过“锦江礼享＋”会员卡预订的各种服务产品其服务及相应的权利义务均由各相关服务提供商负责，具体服务内容将按照用户与实际服务提供商所签订或订立的书面合同或其他方式的约定履行，锦江电商并不承担责任，如用户在服务使用过程中产生纠纷，锦江电商可以尽力协助用户与相关服务提供商进行沟通，若协商不能解决的，用户可以依法向消费者权益保护协会投诉或通过法律途径直接向真正的服务提供商寻求救济。\n\t9.2 对于在通信、客户请求和运输中出现的信息丢失情况，或因证书不完整、非法、延误、遗失或被窃而导致的损失，锦江电商概不负责。\n\t9.3 锦江电商明确表示按照“现状”提供服务，不提供任何形式的担保，不论是明示的或默示的。锦江电商不担保所提供的服务能满足用户的要求，也不担保服务不会受中断，对服务的及时性、安全性、真实性、出错都不做担保。锦江电商不担保信息能否准确、及时、顺利地传送。用户理解并接受通过锦江电商及“锦江旅行家”的任何信息资料取决于用户自己，并由其承担系统受损、资料丢失以及其他任何风险。\n\t9.4 因使用“锦江礼享＋”会员卡产生的任何优惠属于锦江电商及锦江国际集团旗下关联企业回馈客户、激励消费的单方行为，其不产生、构成或赋予会员对上海锦江国际电子商务有限公司享有任何法律上的或合同上的权利。\n\t10、其他\n\t10.1 投诉：锦江电商只接受在使用“锦江礼享＋”会员卡及服务预订相关的投诉，就会员预订的具体服务质量产生的问题请向具体的服务提供商投诉或由锦江电商代为转达。\n\t10.2 真实性验证：会员同意锦江电商通过其预留的邮件、手机发送邮件、短信，以验证交易的真实性，在我们发出验证信息后，48小时后未收到会员疑问或反馈，锦江电商将视为用户没有提出异议，具体业务条款中另有约定的除外。\n\t11、条款的更改及完整性\n\t11.1 根据业务需要，锦江电商保留随时更新本条款与规则的权利，您可随时访问“锦江旅行家”网站以查阅最新版本的条款与规则。\n\t11.2 锦江电商保留随时更改、限制、修改或取消全部或部分计划条款与附则积分（包括一次符合奖赏标准的住宿对应的积分数）、优惠项目、参与条件、奖励和奖励级别的权利，即便这些更改可能会影响已赚取的积分或奖励的价值。变更后的条款与附则对每位会员均具有约束力。\n\t11.3 锦江电商及在“锦江旅行家”发布及将来发布的有关服务的其他预订条款、积分政策、协议等，为本条款与规则的一部分，具有同等法律效力。\n\t11.4 本条款与规则的任何条款的部分或全部无效者，不影响其它条款的效力。\n\t11.5 本条款与规则的所有标题仅仅是为了醒目及阅读方便，并无实际含义，不应作为解释条款与规则及相关条款的依据。\n\t12、法律适用及管辖\n\t12.1 本条款与规则的效力、解释、变更、执行与争议解决均适用中华人民共和国法律及相关规定，如无相关法律及相关规定的，则参照通用国际商业惯例和/或行业惯例。\n\t12.2 若会员和锦江电商之间因本条款与规则发生任何纠纷或争议，首先应友好协商解决，协商不成的，会员同意将纠纷或争议提交锦江电商所在地即上海市有管辖权的人民法院管辖。\n\n24小时客户服务热线：1010-1666\n\n我们的服务建议邮箱：service@jinjiang.com";

@interface RegistViewController : JJViewController

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, weak) IBOutlet UITextField* userNameField;
@property (nonatomic, weak) IBOutlet UITextField* passwordField;
@property (nonatomic, weak) IBOutlet UITextField* confirmField;
@property (nonatomic, strong) UIView* modeView;
@property (nonatomic, strong) UIView* regulaView;
@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UserInfo* userInfo;
@property (nonatomic, strong) RegistParser* registParser;
@property (nonatomic, strong) LoginParser* loginParser;

- (IBAction)resignEditing:(id)sender;
- (IBAction)registButtonClick;


@end