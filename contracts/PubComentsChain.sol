// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

// import "openzeppelin-solidity/contracts/token/ERC20/utils/SafeERC20.sol";
import "./ButtToken.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    /**
     * @dev gives square root of given x.
     */
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = ((add(x, 1)) / 2);
        y = x;
        while (z < y) {
            y = z;
            z = ((add((x / z), z)) / 2);
        }
    }

    /**
     * @dev gives square. multiplies x by x
     */
    function sq(uint256 x) internal pure returns (uint256) {
        return (mul(x, x));
    }

    /**
     * @dev x to the power of y
     */
    function pwr(uint256 x, uint256 y) internal pure returns (uint256) {
        if (x == 0) return (0);
        else if (y == 0) return (1);
        else {
            uint256 z = x;
            for (uint256 i = 1; i < y; i++) z = mul(z, x);
            return (z);
        }
    }
}

library Data {
    using SafeMath for uint256;

    struct Participant {
        //这个要看是否需要。

        // 玩家推荐收益
        uint256 ParticipantIncome;
        // 锁仓Token数
        uint256 lockToekn;
        // 已提现额度
        uint256 withdrawAmount;
        // 时间戳索引
        uint256 timeIndex;
        // 时间戳数组
        uint256[] timestampArr;
        //是否存在
        bool exist;
        //上级地址
        address superiorAddr; //这里所谓的上级地址及下面的下级地址实际上是拉新使用。
        //下级地址数组
        address[] subordinateArr;
        // 时间戳 => 份数
        mapping(uint256 => uint256) lockupMap; //下标是时间戳，表示这一段时间内
    }

    struct ParticipantActivityData {
        //首次加密评定数据，如果数据能够删除，那么用完后删除看是否能节约费用。但是struct体是没法删除的。
        bytes32 hashEvaScore;
        bytes32 hashForecastBoxOffice;
        uint256 evaScore; //影评数据   可改为U8
        uint256 forecastBoxOffice; //票房预测
        uint256 participantfee; //活动参与费用，主要会涉及多票的情况，
        uint256 participantRankScore; //不需要这么大的数据
        //奖励不需要
        uint256 tokenReward;
    }

    struct EvaActivity {
        //评定活动相关的数据

        //评定活动发起者
        address sponsor;
        //电影Id,根据规则定义。这个可以不需要，因为活动的映射下标就是根据filmId定义key值的
        // string filmId;

        //最终电影评分
        uint8 filmScore;
        uint8 darkHorseNum; //这个参数可以去掉，因为可以通过计算获得。
        //参与评定人数，这个只做显示，不做运算
        uint256 participateNum;
        //第二次提交评定的人数，之所以要这个参数，是因为第二次提交人数与第一次提交人数可能不一致，有的人耽误了或者不想提交了。这个只做运算
        //这个二次提交参数是非常重要的，如果参评者没有进行二次提交，那么就无法获得他的评定数据，最终无法参与后续奖励。
        uint256 participateAgainNum;
        //黑马指数

        //1表示评定状态（加密提交评定阶段）；2表示加密数据解密阶段（明文提交评定阶段） 3.等待阶段 4.表示活动彻底关闭阶段
        uint8 activityState;
        //发起者赞助金
        uint256 bonus;
        //下面的奖金池需要留一部分给下一步电影吗？
        //token奖金池
        uint256 tokenPoll;
        //以太奖金池,赞助只接收以太币
        uint256 ethPoll;
        //可能要考虑用浮点类型
        uint256 totalScore; //所有影评总分
        // uint averageScore; //影评平均分
        uint256 totalForecastBoxOffice; //总的票房预测，单位为千万，
        // uint averageForecastBoxOffice;//平均预测票房

        uint256 realFilmBoxOffice; //实际票房
        //地址 => 评分
        mapping(address => ParticipantActivityData) participantDataMap; //所有参与者评分映射。这里用mapping比较好，如果用数组，那么就会在有的函数调用中会出现查找消耗。
        address[] participantAddress; //用于获得mapping中的所有数据
        // // 地址 => 票房预测d
        // mapping(address => uint) forecastBoxOfficeMap; //所有参与者票房预测映射。

        // mapping(address => uint) partticipantFee;

        // 地址 => 参与者排名得分，排名只保存获奖者，
        // mapping(address => uint) partticipantRankScore;  //只计入需要奖励的人，并且奖励完后是可以不需要一直存储的，不够需按照情况而定

        //参与者排名，之所以不放到上面的参与者数据中是因为排名只需要前30%即可，这样可以节省一些数据
        mapping(address => uint256) partticipantRank; //这个数据也许可以不用

        //后续考虑一下是否追加一个对赌模块。拉新奖励机制看是否需要，及前后奖励的机制是否需要，如果需要直接补充应该可以，基本都是独立的。
        //对赌模块感觉意义不大就是，活动本身取消分数限制，实际上也是一种对赌。
    }
}

contract PubComentsChain {
    using SafeMath for uint256;
    // 技术地址
    address public techAddr; //实际上是项目方地址

    //技术地址拿的总额度
    uint256 public totalTechAmount;

    // token地址
    // address public tokenAddr;
    //注意如果需要对所有mapping进行遍历，可以通过设计一个包含key值数组的结构体的方法实现，这个网上已有相应代码。

    // 电影ID => 评定活动数据
    mapping(string => Data.EvaActivity) public FilmEvaActivity; //Sting 对应的是电影Id,这个Id根据标准设计。

    //地址=>参评者数据。
    mapping(address => Data.Participant) public participantMap;

    //用户拥有的未提现token.之所以要这个是为了用户积累到一定数目的token后再进行体现，减少网络费用。这个变量可以放到participantMap中，如果需要participantMap变量的话
    mapping(address => uint256) public participantOwnerTokenMap;

    uint256 filmBeEvaNum;

    // using ButtToken for ERC20;

    //  //对于争夺发起方失败后转账，solidity觉得会有问题，要让用户自己回退。主要是防止合约自动进行转出操作，保证资金的安全
    //   //活动发起者可以取回的之前的出价
    //   mapping(address => uint) sponsorReturns;   //不需要这个。这里是防止恶意合约会调用，但是这里已经做了删选

    //相关事件：1、合约发起事件 2.活动结束事件 3。发起者变更事件 4.评定参与事件 。具体需要什么事件，要看前端是否需要获得相关信息，尤其是需要相关数据进行处理的操作。

    /**
     * @dev 合约初始化
     * @param _techAddr 项目方地址
     */
    constructor(address _techAddr) {
        //高版本不需要public
        techAddr = _techAddr;

        //token应该是可以单独一份合约，这样token可以放到交易所中进行交易
        // 获取token合约的字节码
        //这里不要用这中方法来进行token的方法调用，只需通过在需要用到token方法的地方传入token地址即可。
        //   bytes memory bytecode = type(ButtToken).creationCode;
        //   bytes32 addrSalt = keccak256(abi.encodePacked(msg.sender));
        //   address _tokenAddr;
        //   // 内联汇编 创建token合约
        //   assembly {
        //       _tokenAddr := create2(0, add(bytecode, 32), mload(bytecode), addrSalt)
        //   }
        //   tokenAddr = _tokenAddr;

        //  }

        // //获得众评合约中创建的Token合约
        // function getTokenAddress() public view returns (address){
        //   return tokenAddr;
    }

    /**
     * 合约接收eth的匿名函数
     */
    //这个函数也许用不到，因为基本前端都是从对应函数中触发转账的。
    //payable 是否值适用于以太？？？？？
    receive() external payable {
        //向合约发送ETH，并且发送者这个地址不能是合约地址，也就是只能是账户地址，直接转账。
        uint256 _eth = msg.value;
        bool flag = isContract(msg.sender);
        // 如果不是合约地址
        if (!flag) {
            // 如果转入了eth
            if (_eth > 0) {
                // 参加评定活动
                // scratchWithEthDistribution(msg.sender, address(0x0), _eth); //这里的ETH直接从发送端到目的地址已经连接起来了，中间没有中断的地方，所以不会有问题。
            } else {
                //*如果传入的以太为0，表示要测回以太币
                // 撤回坐庄资金
                // recallEthCore(msg.sender, 0);
            }
        }
    }

    // 函数中加payable表示是我们可以给他转币
    // 进行纯转账时，会触发回退函数。当合约收到以太但没有数据，回退函数就会执行，这是回退函数需要加上payable。
    fallback() external payable {}

    //直接获得本合约的所以以太币
    // function getETH() external {
    //     msg.sender.transfer(address(this).balance);
    // }

    /**
     * @dev 判断地址是否为合约地址
     * @param _addr 需判断的地址
     *
     */
    function isContract(address _addr) private view returns (bool result) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        result = size > 0;
    }

    //参评者用户注册，如果需要这个功能，其作用主要是拉新奖励。

    //之所以这个转账可以定位到对应的token是因为前端会指定该token的合约。
    /**
     * @dev 发起评定活动。
     * @param filmId 电影ID
     */
    function createEvaActivityWithToken(
        string memory filmId,
        address _tokenAddr,
        uint256 value
    ) external {
        //注意在智能合约中如果函数添加payable，那么就会在生成封装类时会自动把value这个参数加入到入参中。
        require(isContract(msg.sender) == false, "Not a normal user");
        require(value > 10, "Create contract fee is enough"); //创建合约费用不够
        //还要加一个防止重复创建的操作。
        // require(IERC20(_tokenAddr).balance[_tokenAddr]> 10, "Create contract fee is enough");  //先注释一下，测试函数功能
        // ButtToken(_tokenAddr).transfer(address(this), value); //转账token的方法
        TutorialToken(_tokenAddr).transfer(address(this), value);
        //看是否需要注册
        // FilmEvaActivity[filmId].tokenPoll+=value;
        //下面的有问题。
        // SafeMath.add(FilmEvaActivity[filmId].tokenPoll,value);
        FilmEvaActivity[filmId].tokenPoll = FilmEvaActivity[filmId]
            .tokenPoll
            .add(value);
        // address  sponsorAddress=msg.sender;
        // address payable sponsorAddress2=address( uint160(sponsorAddress));
        // FilmEvaActivity[filmId].sponsor=address( uint160(sponsorAddress));
        FilmEvaActivity[filmId].sponsor = msg.sender;

        //token的bonus是否需要？？
        //这里可能需要判别一下当前是否已经有owner及bonus了
        // FilmEvaActivity[filmId].bonus=_eth;
        FilmEvaActivity[filmId].activityState = 1; //评定进行状态
        //还需要记录一下结束时间。包括评定二次提交时间。
    }

    function createEvaActivityBonusEth(string memory filmId) external payable {
        //活动发起者可以参考这个函数
        require(isContract(msg.sender) == false, "Not a normal user");
        require(msg.value > 0, "Eth bonus is 0");
        // uint _eth = msg.value;  //考虑只用token还是以太币。注意这里通过msg来获得值，实际也可以通过入参获得，但是msg是永不会出错的值，它是直接从合约消息中直接获得的。
        payable(address(this)).transfer(msg.value); //真实转账操作

        FilmEvaActivity[filmId].ethPoll = FilmEvaActivity[filmId].ethPoll.add(
            msg.value
        );

        //这里可能需要判别一下当前是否已经有owner及bonus了
        FilmEvaActivity[filmId].bonus = msg.value;

        // //注册用户
        // register(msg.sender, _superiorAddr);  //之所以需要这个是因为这个可以直接发起，当庄时必须要是注册用户。
        // //计算用户获得份额 = eth / 一份的价格
        // uint _share = _eth.mul(10 ** 4).div(sharePrice);
        // //更新用户的总份额
        // playerMap[msg.sender].share = playerMap[msg.sender].share.add(_share);
        // //更新用户的坐庄金额
        // playerMap[msg.sender].sitAmount = playerMap[msg.sender].sitAmount.add(_eth);
        // //更新总份额
        // totalShare = totalShare.add(_share);
        // //更新庄家资金池
        // scratchPool = scratchPool.add(_eth);
        //锁仓
        // ethLockup(msg.sender, _eth, _share, lockPeriod);
    }

    //这个状态是根据时间段来调用设置的，由外界根据相应条件触发。
    function setActivityState(string memory filmId, uint8 activityState)
        external
    {
        //注意切换到状态2时必须保证参与人数达到最小值1000以上，不然活动失败，返还所有参与人的费用。
        FilmEvaActivity[filmId].activityState = activityState; //先进行简单的直接修改。
    }

    /**
     * @dev 争夺发起者，创建合约及争夺时都可以调用这个函数
     * @param filmId 电影Id
     */
    function sponsorFight(string memory filmId) external payable {
        //注意bonus需要统一一下到底是用什么币或者多种币
        //禁止合约调用
        require(isContract(msg.sender) == false, "Not a normal user");
        //活动时间。
        // 如果拍卖已结束，撤销函数的调用。
        require(
            FilmEvaActivity[filmId].activityState != 4, //这个阶段其实可以持续到电影下映阶段
            "Activity already ended."
        );
        // 调用撤回资金的核心方法
        // uint _ethBonus=msg.value;
        require(
            msg.value > FilmEvaActivity[filmId].bonus,
            "your bonus is less"
        );
        if (FilmEvaActivity[filmId].bonus != 0) {
            // 返还出价时，简单地直接调用 highestBidder.send(highestBid) 函数，
            // 是有安全风险的，因为它有可能执行一个非信任合约。
            // 更为安全的做法是让接收方自己提取金钱。
            // sponsorReturns[FilmEvaActivity[filmId].sponsor] += FilmEvaActivity[filmId].bonus; //活动的发起者退回到原先发起者的转户资金处
            // FilmEvaActivity[filmId].sponsor.transfer(FilmEvaActivity[filmId].bonus);  //直接发送
            FilmEvaActivity[filmId].bonus = msg.value;
            FilmEvaActivity[filmId].ethPoll -= FilmEvaActivity[filmId].bonus; //奖金池先减去原来bonus
        }
        payable(msg.sender).transfer(msg.value); //真实转账操作
        FilmEvaActivity[filmId].bonus = msg.value;
        //奖金池改变
        FilmEvaActivity[filmId].ethPoll += msg.value; //奖金池再加上新的bonus
        FilmEvaActivity[filmId].sponsor = msg.sender;
    }

    //首次提交加密评定
    function participateActivityWithBlind(
        string memory filmId,
        address _tokenAddr,
        bytes32 _hashScore,
        bytes32 _hashBoxOffice,
        uint256 feeValue
    ) external payable {
        require(
            FilmEvaActivity[filmId].activityState == 1,
            "activity can not part in"
        );
        require(isContract(msg.sender) == false, "Not a normal user"); //这个条件可以用一个moditify
        require(feeValue > 1, "your bonus is less"); //暂定参与票价为1token
        //引用变量
        // Data.ParticipantActivityData storage participantData = FilmEvaActivity[
        //     filmId
        // ].participantDataMap[msg.sender];
        // FilmEvaActivity[filmId].participantAddress.push(msg.sender); //记录所有地址数据
        // // ButtToken(_tokenAddr).transfer(address(this), feeValue); //token实际转账

        // ERC20(_tokenAddr).transfer(address(this), feeValue);

        // participantData.hashEvaScore = _hashScore;
        // participantData.hashForecastBoxOffice = _hashBoxOffice;
        // participantData.participantfee = feeValue; //这个费用是扣除转账费用后的参加评定的费用
        // //下面数据必须在提交加密数据时就赋值，这些值需要较早的显示。
        // FilmEvaActivity[filmId].participateNum++;
        // //资金池需要修改
        // FilmEvaActivity[filmId].tokenPoll += feeValue;
    }

    //第二次提交明文评定 。为了让用户体验更好，用户可以托管自己的评定到中心化后台，也可以自己在规定时间二次提交（加密数据一起都可以托管过来，）
    function participateActivityWithReveal(
        string memory filmId,
        uint256 score,
        uint256 forecastBoxOffice
    ) external {
        //检验活动是否在进行
        require(
            FilmEvaActivity[filmId].activityState == 2,
            "activity is not in reveal state"
        );
        require(isContract(msg.sender) == false, "Not a normal user"); //这个条件可以用一个moditify
        //注意这里还要实现加密加密校验!!!!!!!!!

        //引用变量
        Data.ParticipantActivityData storage participantData = FilmEvaActivity[
            filmId
        ].participantDataMap[msg.sender];
        participantData.evaScore = score;
        participantData.forecastBoxOffice = forecastBoxOffice;

        //直接把总评分进行累加。 注意下面的溢出！！！！！！！！！
        FilmEvaActivity[filmId].totalScore += score;
        FilmEvaActivity[filmId].totalForecastBoxOffice += forecastBoxOffice;
        FilmEvaActivity[filmId].participateAgainNum++;

        //加一个事件监听结果
    }

    /**
    评定阶段结束。
   */
    function EvaActivityEnd(string memory filmId) external {
        //这里做一个时间判断，保证安全。
        // require（block.timestamp>=FilmEvaActivity[filmId].endTime,"Evaluate activity has not reach the end time"）;
        //活动必须处在revual阶段才可以进行结束
        require(
            FilmEvaActivity[filmId].activityState != 2,
            "Evaluate state has already end."
        );
        FilmEvaActivity[filmId].activityState = 3;
        //触发评分计算函数。
        calculateFilmScore(filmId);
        filmBeEvaNum++; //一次评定完成，统计已经评定电影次数。
    }

    uint256 calcuateFactor = 100; //浮点计算放大因子，也就是说只保留两位小数。最终在最终值中除以100即可。

    //票房折合函数，实现票房折合为票房分,这个需要根据票房的实际数据确定函数，目前暂定一个线性函数
    function boxoffice2Score(uint256 BoxOffice) internal returns (uint256) {
        //注意传入的票房单位为：千万
        uint256 boxOfficeScore = 0;
        if (BoxOffice <= 100) {
            boxOfficeScore = BoxOffice / 25 + 3;
        } else if ((BoxOffice > 100) && (BoxOffice <= 600)) {
            // boxOfficeScore=3*BoxOffice/500 + 32/5;   //浮点型没法算，后面解决
        } else {
            boxOfficeScore = 10;
        }
        return boxOfficeScore;
    }

    //商业电影及文艺电影的权重，这个权重要根据影视库库数据获得才更可靠
    uint256 comFilmWeight;
    uint256 litFilmEight;

    //影评计算函数
    function calculateFilmScore(string memory filmId) internal {
        require(
            FilmEvaActivity[filmId].totalScore != 0 &&
                FilmEvaActivity[filmId].totalForecastBoxOffice != 0,
            "totalScore err"
        );

        //计算平均分,需要实现浮点数据，数据类型后面具体解决
        uint256 averageScore = FilmEvaActivity[filmId].totalScore /
            FilmEvaActivity[filmId].participateAgainNum;
        uint256 averageForecastBoxOffice = FilmEvaActivity[filmId]
            .totalForecastBoxOffice /
            FilmEvaActivity[filmId].participateAgainNum;

        //计算最终影评分，当前采用线性函数进行关联两个因子
        uint256 boxOfficeScore = boxoffice2Score(averageForecastBoxOffice);

        //根据平均主观评分和折算的票房预测分折算为最终的影评评分。
        //由于涉及到浮点数，且这部分为独立函数，后面找到最优浮点数计算方法后补充即可。
        // if(){

        // }

        //  FilmEvaActivity[filmId].filmScore=
    }

    //这个函数的触发有两种方案：一个是中心化触发，一个是去中心化触发。
    //电影下映或者达到最长时间时触发实际票房上传
    function setFilmRealBoxOffice(string memory filmId, uint256 realBoxOffice)
        private
    {
        require(
            FilmEvaActivity[filmId].activityState == 3,
            "this state can not set realboxoffice"
        );
        FilmEvaActivity[filmId].realFilmBoxOffice = realBoxOffice;

        //调用参评者排名得分函数
        calculateRankScore(filmId);

        //调用计算排名函数

        //获得挖矿奖励
        getTokenReward(filmId);

        //根据获奖名单排名分发所有奖励

        //活动策底结束
    }

    //下述权重化为整型，解决浮点问题
    uint256 subWeight = 4; //主观评分权重
    uint256 objWeight = 2; //客观票房预测权重
    uint256 subAndObjWeight = 4; //主客观权重
    uint256 AvFactory = 500; //放大因子

    //实现奖励算法
    function calculateRankScore(string memory filmId) private {
        uint256 scoreCoefficient;
        uint256 boxOfficeCoefficient;
        uint256 subAndObjCoefficient;
        uint256 averageScore = FilmEvaActivity[filmId].totalScore /
            FilmEvaActivity[filmId].participateAgainNum;
        uint256 averageForecastBoxOffice = FilmEvaActivity[filmId]
            .totalForecastBoxOffice /
            FilmEvaActivity[filmId].participateAgainNum;
        uint256 realFilmBoxOfficeScore = boxoffice2Score(
            FilmEvaActivity[filmId].realFilmBoxOffice
        ); //把实际票房转换为票房分

        //这里分数暂时有最简单的线性除法计算各个因子的得分值。
        for (
            uint256 i = 0;
            i < FilmEvaActivity[filmId].participantAddress.length;
            i++
        ) {
            //变量引用
            Data.ParticipantActivityData
                storage participantData = FilmEvaActivity[filmId]
                    .participantDataMap[
                        FilmEvaActivity[filmId].participantAddress[i]
                    ];
            if (
                (participantData.evaScore != 0) &&
                (participantData.forecastBoxOffice != 0)
            ) {
                uint256 participantScore = participantData.evaScore;
                uint256 participantBoxOffice = participantData
                    .forecastBoxOffice;
                uint256 forecastBoxOfficeScore = boxoffice2Score(
                    participantBoxOffice
                );
                uint256 averageScoreBoxOffice = (participantScore +
                    forecastBoxOfficeScore) / 2;

                if (participantScore < averageScore) {
                    scoreCoefficient =
                        (subWeight *
                            AvFactory *
                            (averageScore - participantScore)) /
                        averageScore;
                } else {
                    scoreCoefficient =
                        (subWeight *
                            AvFactory *
                            (participantScore - averageScore)) /
                        averageScore;
                }
                if (participantBoxOffice < averageForecastBoxOffice) {
                    boxOfficeCoefficient =
                        (objWeight *
                            AvFactory *
                            (averageForecastBoxOffice - participantBoxOffice)) /
                        averageForecastBoxOffice;
                } else {
                    boxOfficeCoefficient =
                        (objWeight *
                            AvFactory *
                            (participantBoxOffice - averageForecastBoxOffice)) /
                        averageForecastBoxOffice;
                }
                //主客观误差，先按照最简单的方法实现
                if (averageScoreBoxOffice < realFilmBoxOfficeScore) {
                    subAndObjCoefficient =
                        (realFilmBoxOfficeScore - averageScoreBoxOffice) /
                        realFilmBoxOfficeScore;
                } else {
                    subAndObjCoefficient =
                        (averageScoreBoxOffice - realFilmBoxOfficeScore) /
                        realFilmBoxOfficeScore;
                }
                participantData.participantRankScore =
                    scoreCoefficient +
                    boxOfficeCoefficient +
                    subAndObjCoefficient;
            }
        }
    }

    //排序这个如果采用传统排序方法这个比较消耗资源，需要慎重考虑一下方案
    function calculateRank() internal {}

    //根据下述算法实现排序。
    // function top() public view returns (uint[] memory topIds)//pai xu
    // {
    //     topIds = new uint[](10);
    //     for(uint appId=1;appId<apps.length;appId++){
    //       //
    //       uint topLast = appId<topIds.length?appId:topIds.length-1;
    //       if(appId>=topIds.length &&   apps[appId].totalStar<=apps[topIds[topLast]].totalStar){//如果appid超过了topids数组的长度并且该appid对应的app总评分大于toplds数组最后一个元素所有的总评分就结束本次循环
    //           continue;
    //       }
    //       //交换排序
    //       topIds[topLast] = appId;
    //       for(uint i=topLast;i>0;i--){
    //           if(apps[topIds[i]].totalStar>apps[topIds[i-1]].totalStar){
    //               uint tempAppId = topIds[i];
    //               topIds[i] = topIds[i-1];
    //               topIds[i-1] = tempAppId;
    //           }
    //           else{
    //               continue;
    //           }
    //       }
    //     }
    // }

    uint8 constant reduceNumConstant = 200; //每200部电影减半一次
    uint256 constant startTokenNum = 45000000; //9千万进行挖矿，一千万进行预挖
    uint256 constant participantsMin = 1000;
    uint256 constant averageBoxOfficInBase = 50; //影视库中的均值票房5亿

    //根据最终影评、实际票房及参与人数计算token挖矿收益并放入到奖金池中。
    function getTokenReward(string memory filmId) private returns (uint256) {
        uint8 filmScore = FilmEvaActivity[filmId].filmScore;
        uint256 filmBoxOffice = FilmEvaActivity[filmId].realFilmBoxOffice;
        uint256 participants = FilmEvaActivity[filmId].participateNum;
        uint256 reduceNum = filmBeEvaNum / reduceNumConstant;
        //根据减半情况，计算本次影评能够挖到矿的总额。
        // uint countNum=reduceNum<<1; // 2^reduceNum
        uint256 averageToken = SafeMath.div(startTokenNum, 2**reduceNum);

        //影响因子的乘机
        uint256 tokenCalcuateNum = SafeMath.div(participants, participantsMin) *
            SafeMath.div(filmBoxOffice, averageBoxOfficInBase) *
            SafeMath.div(filmScore, 5);
        //按照对数对tokenCalcuateNum计算数值
        uint256 logCalculateNum;
        if (tokenCalcuateNum >= 2**128) {
            tokenCalcuateNum >>= 128;
            logCalculateNum += 128;
        }
        if (tokenCalcuateNum >= 2**64) {
            tokenCalcuateNum >>= 64;
            logCalculateNum += 64;
        }
        if (tokenCalcuateNum >= 2**32) {
            tokenCalcuateNum >>= 32;
            logCalculateNum += 32;
        }
        if (tokenCalcuateNum >= 2**16) {
            tokenCalcuateNum >>= 16;
            logCalculateNum += 16;
        }
        if (tokenCalcuateNum >= 2**8) {
            tokenCalcuateNum >>= 8;
            logCalculateNum += 8;
        }
        if (tokenCalcuateNum >= 2**4) {
            tokenCalcuateNum >>= 4;
            logCalculateNum += 4;
        }
        if (tokenCalcuateNum >= 2**2) {
            tokenCalcuateNum >>= 2;
            logCalculateNum += 2;
        }
        if (tokenCalcuateNum >= 2**1) {
            /*x>>=1;*/
            logCalculateNum += 1;
        }

        uint256 tokenReward = averageToken + averageToken * logCalculateNum;
        FilmEvaActivity[filmId].tokenPoll += tokenReward;
    }

    /**
    奖励分配
   */
    //调用Token合约进行挖矿奖励分配。
    function distrabiteToken() internal {
        //根据奖励分配挖矿奖励
        //根据奖励分发tokenReward
    }

    //用户自己触发获得奖励。该函数触发涉及转账是需要消耗
    function getReward(address _tokenAddr, address to) external {
        require(
            participantOwnerTokenMap[to] > 0,
            "this account has not reward in this activity"
        );
        // ButtToken(_tokenAddr).distrabuteToken(to, participantOwnerTokenMap[to]);
        ERC20(_tokenAddr).transfer(to, participantOwnerTokenMap[to]);
    }

    // 获取对应活动的数据，主要是全局数据，参与人、评定数据等，放到一起一次性获得。
    function getParticipantNum(string memory filmId)
        public
        view
        returns (uint256)
    {
        return FilmEvaActivity[filmId].participateNum;
    }

    function getTokenPoll(string memory filmId) public view returns (uint256) {
        return FilmEvaActivity[filmId].tokenPoll;
    }

    function getEvaActivityData(string memory filmId)
        external
        view
        returns (
            address sponsor,
            uint8 filmScore,
            uint8 darkHorseNum,
            uint256 participateNum,
            uint256 participateAgainNum,
            uint8 activityState,
            uint256 bonus,
            uint256 tokenPoll,
            uint256 ethPoll,
            uint256 totalScore,
            uint256 totalForecastBoxOffice,
            uint256 realFilmBoxOffice
        )
    {
        Data.EvaActivity storage EvaActivityData = FilmEvaActivity[filmId];
        return (
            EvaActivityData.sponsor,
            EvaActivityData.filmScore,
            EvaActivityData.darkHorseNum,
            EvaActivityData.participateNum,
            EvaActivityData.participateAgainNum,
            EvaActivityData.activityState,
            EvaActivityData.bonus,
            EvaActivityData.tokenPoll,
            EvaActivityData.ethPoll,
            EvaActivityData.totalScore,
            EvaActivityData.totalForecastBoxOffice,
            EvaActivityData.realFilmBoxOffice
        );
    }

    function getParticipantActivityData(string memory filmId, address acount)
        external
        view
        returns (
            bytes32 hashEvaScore,
            bytes32 hashForecastBoxOffice,
            uint256 evaScore,
            uint256 forecastBoxOffice,
            uint256 participantfee,
            uint256 participantRankScore,
            uint256 tokenReward
        )
    {
        Data.ParticipantActivityData
            storage participantActivityData = FilmEvaActivity[filmId]
                .participantDataMap[acount];
        return (
            participantActivityData.hashEvaScore,
            participantActivityData.hashForecastBoxOffice,
            participantActivityData.evaScore,
            participantActivityData.forecastBoxOffice,
            participantActivityData.participantfee,
            participantActivityData.participantRankScore,
            participantActivityData.tokenReward
        );
    }
}
