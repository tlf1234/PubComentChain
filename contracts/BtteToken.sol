// SPDX-License-Identifier: SimPL-2.0
pragma solidity >=0.4.22 <0.9.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol"; 

///library：MathUtil
///input: _x：真数
///output: log_2(x)
library MathUtil {
  function ceilLog2(uint _x) pure internal returns(uint) {
    require(_x > 0);

    uint x = _x;
    uint y = (((x & (x - 1)) == 0) ? 0 : 1);
    uint j = 128;
    uint k = 0;

    k = (((x & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0xFFFFFFFFFFFFFFFF0000000000000000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0xFFFFFFFF00000000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x00000000FFFF0000) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x000000000000FF00) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x00000000000000F0) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x000000000000000C) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    k = (((x & 0x0000000000000002) == 0) ? 0 : j);
    y += k;
    x >>= k;
    j >>= 1;

    return y;
  }
}

/// @title ERC20代币发放 & 挖矿奖励的发放相关
/// @author Javed Lee
contract BtteToken is ERC20 {

    event debugLOG(uint, string);

    //发行总量1亿
    uint private INITIAL_SUPPLY=100000000;

    //创建调用者address
    address private owner;  

    //当前币总量
    uint private totalToken;

    //获得奖励的最小活动参与人数
    uint immutable minParticipants = 100;

    //当前阶段挖矿发放代币总额度
    uint private stageToken = 100000000;

    //当前阶段挖矿基础奖励
    uint private baseTokens;

    //挖矿累计次数
    uint private mintTimes;

    //挖矿奖励减半判断参数
    uint private templateParam;

    //评定活动ID
    uint private activityId;

    //挖矿奖励评定参数
    struct ActivityParams{
        uint participants;
        uint tickets;
        uint averageTickets;
        uint8 peopleScore;
        uint8 chainScore;
    }
    //活动Id => 活动参数(方便查询)
    mapping(uint => ActivityParams) activityTable;

    constructor(address account) ERC20("ButterflyToken", "BTTE") {

        _mint(account, INITIAL_SUPPLY); 

        totalToken = INITIAL_SUPPLY;

        owner = account;
    }

    ///@dev 查询已发放奖励的众评活动的评定详情
    ///@param _activityId： 待查询活动的Id
    ///@return ActivityParams: 活动详细参数结构体 
    function activityQuery(uint _activityId) public view returns(ActivityParams memory) {
        return activityTable[_activityId];
    }

    ///@dev 输入指定评定活动参数后，根据奖励算法，完成奖励的发放
    ///@notice 电影评定活动结束后调用此函数发放奖励
    ///@param _participants：接收奖金的地址
    ///@param _tickets：接收奖金的地址
    ///@param _averageTickets：接收奖金的地址
    ///@param _peopleScore：接收奖金的地址
    ///@param _chainScore：接收奖金的地址
    ///@param _to：接收奖金的地址
    function distribute
    (
        uint _participants,
        uint _tickets,
        uint _averageTickets,
        uint8 _peopleScore,
        uint8 _chainScore,
        address _to
    )
        public
    {
        //此次挖矿所能分得的奖金
        uint newBonus;
        //挖矿次数+1
        mintTimes++;
        templateParam++;

        _updateBonus();
        baseTokens = stageToken / 200;

        newBonus = _calculateCore(_participants, _tickets, _averageTickets, _peopleScore, _chainScore, baseTokens);
        _distributeToken(_to, newBonus);
        
        emit debugLOG(activityId-1, "==>Tokens has been issued");
    }

    ///@dev 检查是否需要更新挖矿收益额度
    ///@notice 更新挖矿奖励总额
    function _updateBonus() internal {

        //每200次挖矿收益减半
        if((templateParam / 200) != 0) {
          templateParam = 0;
          stageToken = stageToken / 2;
        }
    }

    ///@dev 给指定地址token
    ///@param _to address地址
    ///@param _value token数量
    function _distributeToken(address _to, uint _value) internal { 

        //挖矿10000次挖完
        require(mintTimes <= 10000, "Mining reward payment has ended"); 
        //之所以取totalSupply_这个变量，是因为这个变量有获取方法，能够读取它的值
        require(totalToken > 0, "Insufficient tokens"); 
        //获取的token数量必须少于等于 剩余总量
        require(_value <= totalToken, "Transfer amount exceeds the maximum amount of tokens");
        //剩余总量 = 剩余总量 - 本次获取的token
        totalToken = totalToken - _value;
        //这里放一个msg.sender 监控函数
        transfer(_to, _value);  

   }

    ///@dev 挖矿收益分配计算
    function _calculateCore(
        uint _participants,
        uint _tickets,
        uint _averageTickets,
        uint8 _peopleScore,
        uint8 _chainScore,
        uint _baseTokens
    ) 
        internal 
        returns(uint)
    {
        uint countedBonus;
        ActivityParams memory activityParams = ActivityParams({
            participants : _participants,
            tickets : _tickets,
            averageTickets : _averageTickets,
            peopleScore : _peopleScore,
            chainScore : _chainScore
        });
        activityTable[activityId++] = activityParams;
        require(activityParams.participants >= minParticipants, "The number of participants in the activity is too small to be rewarded");

        //挖矿奖励计算
        countedBonus = _baseTokens + _baseTokens * MathUtil.ceilLog2(
            (activityParams.participants/minParticipants) * (activityParams.tickets/activityParams.averageTickets) * (activityParams.peopleScore/activityParams.chainScore)
        );
        //单个活动奖励上限为2倍基础奖励
        if(countedBonus > 2*_baseTokens) countedBonus = 2*_baseTokens;

        return countedBonus;
    }
}


