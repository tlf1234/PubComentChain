// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

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

/**
    注意：该合约为电影评定合约，后面可以另定一个处理非电影评定以外的评定合约，基本和该合约差不多，只是舍去挖矿奖励相关部分。
 */

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

    //发布影评相关数据
    struct ReleaseEvaData {
        uint8 evaScore; //评论发布者给出的评分
        uint32 voteNum; //获得的投票数
        uint32 opposeNum; //反对数

        //收益可能不需要放到链上
    }

    struct EvaActivity {
        //评定活动相关的数据

        //评定活动发起者
        address sponsor;
        //电影Id,根据规则定义。这个可以不需要，因为活动的映射下标就是根据filmId定义key值的
        // string filmId;

        //最终电影评分,可能要考虑用浮点类型
        uint8 filmScore;
        //参与评定人数，这个只做显示，不做运算
        uint256 participateNum;
        //下面的奖金池需要留一部分给下一步电影吗？
        //本项目token奖金池
        uint256 tokenPoll;
        //以太奖金池,赞助只接收以太币
        uint256 ethPoll;
        //可能要考虑用浮点类型
        // uint256 activityEvaScore; //该活动最终评分
        //影评发布列表数据
        mapping(address => ReleaseEvaData) ReleaseEvaDataMap; //所有参与者评分映射。这里用mapping比较好，如果用数组，那么就会在有的函数调用中会出现查找消耗。
        mapping(address => uint256) sponsorMap; //记录一下赞助成员
        address[] voteMemberAddress; //参与投票的用户。
        uint48 endTime; //活动结束时间
        // //参与者排名，之所以不放到上面的参与者数据中是因为排名只需要前30%即可，这样可以节省一些数据
        // mapping(address => uint256) partticipantRank; //这个数据也许可以不用

        //后续考虑一下是否追加一个对赌模块。拉新奖励机制看是否需要，及前后奖励的机制是否需要，如果需要直接补充应该可以，基本都是独立的。
        //对赌模块感觉意义不大就是，活动本身取消分数限制，实际上也是一种对赌。
    }
}

contract PubComentsChain {
    //活动创建成功事件
    event createActivitySucess(
        string filmId,
        address activityCreater,
        uint256 activityEndTime,
        uint256 value
    );

    //提供赞助
    event activitySponSucess(string filmId, address sponsor, uint256 value);

    //发布影评
    event releaseCommentSucess(
        string filmId,
        address releaseMember,
        uint256 evaScore,
        uint256 value
    );

    //参与投票
    event partInVoteSucess(
        string filmId,
        address partInMember,
        address targetReleaser,
        uint256 value
    );

    using SafeMath for uint256;

    address mTokenAddress; //改地址为项目方发布的token地址，目前设定该合约中涉及的收费运作token只有本项目方token。
    // 合约创建者地址
    address public contract_creator; //项目方合约地址

    uint256 createActivityFee = 10; //活动创建手续费 10 token
    uint256 releaseCommentFee = 2; //影评发布手续费 2 token
    uint256 partInVoteFee = 1; //投票手续费 1 token

    //技术地址拿的总额度
    uint256 public totalTechAmount;

    // token地址
    // address public tokenAddr;
    //注意如果需要对所有mapping进行遍历，可以通过设计一个包含key值数组的结构体的方法实现，这个网上已有相应代码。

    // 活动ID => 评定活动数据
    mapping(string => Data.EvaActivity) public evaActivityMap; //Sting 对应的是电影Id,这个Id根据标准设计。

    //用户拥有的未提现token.之所以要这个是为了用户积累到一定数目的token后再进行体现，减少网络费用。
    mapping(address => uint256) public participantOwnerTokenMap;

    uint256 filmBeEvaNum;

    modifier creatorOnly() {
        require(msg.sender == contract_creator, "Contract Creator Only");
        _;
    }

    /**
     * @dev 合约初始化
     */
    constructor(address tokenAddress) {
        //高版本不需要public
        contract_creator = msg.sender;
        mTokenAddress = tokenAddress;
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
    }

    /**
     * 合约接收eth的匿名函数
     */
    //这个函数也许用不到，因为基本前端都是从对应函数中触发转账的。
    //payable 是否值适用于以太？？？？？ 是的
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

    //注意这个创建活动的过程可能需要合约创建者账号判定，防止合约被其它合约调用出现攻击
    function createEvaActivityWithToken(
        string memory filmId,
        uint256 activityEndTime
    ) external {
        //注意在智能合约中如果函数添加payable，那么就会在生成封装类时会自动把value这个参数加入到入参中。
        require(isContract(msg.sender) == false, "Not a normal user");
        require(
            TutorialToken(msg.sender).balanceOf(msg.sender) > createActivityFee, //暂定活动发起费用为10 token
            "Create activity fee is not enough"
        ); //创建合约费用不够

        //检测活动结束时间是否合法。

        //看是否需要注册
        evaActivityMap[filmId].sponsor = msg.sender;
        evaActivityMap[filmId].tokenPoll += createActivityFee;
        evaActivityMap[filmId].endTime = uint48(activityEndTime);
        transfer_token(msg.sender, address(this), createActivityFee); //转账手续费
        // TutorialToken(msg.sender).transfer(address(this), createActivityFee); //转账手续费
        emit createActivitySucess(
            filmId,
            msg.sender,
            activityEndTime,
            createActivityFee
        );
    }

    //以token赞助活动
    function supportActivityWithToken(
        string memory filmId,
        address sponsor,
        uint256 value
    ) external {
        require(isContract(msg.sender) == false, "Not a normal user");
        require(
            TutorialToken(sponsor).balanceOf(sponsor) > value, //暂定活动发起费用为10 token
            "count balance is not enough"
        );
        require(
            evaActivityMap[filmId].endTime < block.timestamp,
            "avtivity has end"
        );

        evaActivityMap[filmId].sponsorMap[sponsor] = value;
        evaActivityMap[filmId].tokenPoll += value;
        transfer_token(msg.sender, address(this), value); //转账手续费
        // TutorialToken(sponsor).transfer(address(this), value); //转账手续费
        emit activitySponSucess(filmId, sponsor, value);
    }

    //以ETH赞助活动
    function supportActivityWithToken(string memory filmId, uint256 value)
        external
        payable
    {
        require(isContract(msg.sender) == false, "Not a normal user");
        require(
            TutorialToken(msg.sender).balanceOf(msg.sender) > value, //暂定活动发起费用为10 token
            "count balance is not enough"
        );
        require(
            evaActivityMap[filmId].endTime < block.timestamp,
            "avtivity has end"
        );

        evaActivityMap[filmId].sponsorMap[msg.sender] = value;
        evaActivityMap[filmId].tokenPoll += value;

        payable(msg.sender).transfer(value); //转账以太赞助费

        emit activitySponSucess(filmId, msg.sender, value);
    }

    //发布评论文章
    function releaseComment(
        string memory filmId,
        uint256 evaScore,
        uint256 value
    ) external {
        require(isContract(msg.sender) == false, "Not a normal user");
        require(
            TutorialToken(msg.sender).balanceOf(msg.sender) > value,
            "count balance is not enough"
        );
        require(
            evaActivityMap[filmId].endTime < block.timestamp,
            "avtivity has end"
        );
        //同一个账户不能重复发布，这个检验应该可以放到客户端，后面进一步考虑一下。

        //放入影评分
        evaActivityMap[filmId].ReleaseEvaDataMap[msg.sender].evaScore = uint8(
            evaScore
        );
        evaActivityMap[filmId].tokenPoll += value;
        transfer_token(msg.sender, address(this), releaseCommentFee); //转账手续费
        // TutorialToken(msg.sender).transfer(address(this), releaseCommentFee); //转账手续费
        emit releaseCommentSucess(filmId, msg.sender, evaScore, value);
    }

    function partInVote(string memory filmId, address targetReleaser) external {
        require(isContract(msg.sender) == false, "Not a normal user");
        require(
            TutorialToken(msg.sender).balanceOf(msg.sender) > partInVoteFee,
            "count balance is not enough"
        );
        require(
            evaActivityMap[filmId].endTime < block.timestamp,
            "avtivity has end"
        );
        //同一个账只有一票，这个检验应该可以放到客户端，后面进一步考虑一下。

        evaActivityMap[filmId].participateNum++; //这个可要可不要，暂时先保留
        evaActivityMap[filmId].tokenPoll += partInVoteFee;
        evaActivityMap[filmId].voteMemberAddress.push(targetReleaser);
        evaActivityMap[filmId].ReleaseEvaDataMap[targetReleaser].voteNum++;

        transfer_token(msg.sender, address(this), partInVoteFee); //转账手续费

        emit partInVoteSucess(
            filmId,
            msg.sender,
            targetReleaser,
            partInVoteFee
        );
    }

    /**
     * sender_address     sender address
     * recipient_address  recipient address
     * amount             transfer amount
     * transfer_token() transfers a given amount of ERC20 from the sender address to the recipient address
     **/

    function transfer_token(
        address sender_address,
        address recipient_address,
        uint256 amount
    ) internal {
        require(
            TutorialToken(mTokenAddress).balanceOf(sender_address) >= amount,
            "Balance not enough"
        );
        TutorialToken(mTokenAddress).transfer(recipient_address, amount);
    }

    //可以对经常投票的账户做一个记录进行优化奖励。

    /*查询函数*/
    //根据电影Id查询活动基本信息
    function getActivivityBasicInfo(string memory filmId)
        external
        view
        returns (
            string memory filmid,
            address sponsor,
            uint8 filmScore,
            uint256 participateNum,
            uint256 tokenPoll,
            uint256 ethPoll,
            uint48 endTime
        )
    {
        Data.EvaActivity storage evaActivityInfo = evaActivityMap[filmId];

        return (
            filmId,
            evaActivityInfo.sponsor,
            evaActivityInfo.filmScore,
            evaActivityInfo.participateNum,
            evaActivityInfo.tokenPoll,
            evaActivityInfo.ethPoll,
            evaActivityInfo.endTime
        );
    }

    //查询对应活动的成员列表
}
