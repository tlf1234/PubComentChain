// SPDX-License-Identifier: SimPL-2.0
pragma solidity >=0.4.24 <=0.9.0;
// import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";   //注意这个路径不需要node_modules,不然找不到
 import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol"; 
//编译该合约只能用低版本的，但是编译后是可以。这里还要看一下当下比较新的token合约相关的继承。
contract ButtToken is ERC20 {
    // string public name="ButterflyToken";
    // string public symbol="BUTT";
    // uint8 public decimals=2;
    uint public INITIAL_SUPPLY=100000000;
    address public owner;  //该token合约的拥有者，这里是创建该token合约的智能合约
    uint tokenTreasure;
    constructor(address account) ERC20("ButterflyToken","BTTE"){

        _mint(account, INITIAL_SUPPLY);  //可以不用这种铸造的方式，把所有币都直接给了传入的账号。目前让它全部都转给了智能合约
      //  _approve(address(this),address(this),INITIAL_SUPPLY);
        tokenTreasure=INITIAL_SUPPLY;
        // balances[msg.sender]=INITIAL_SUPPLY;
        // owner=msg.sender;
        owner=account;
    }

    //合约部署流程的话，应先部署影评合约，然后获得合约地址再部署这个Token合约，最后把这个合约的地址设置到影评合约中。
    //或者直接影评合约中创建
     /**
   * @dev 给指定地址token
   * @param to 地址
   * @param value token数量
   */
  function distrabuteToken(address  to, uint value) public {  //合约创建者用户给指定地址发token，并且这个函数让用户自己触发体现操作
    // 仅PubComensChain合约调用
    require(msg.sender == owner, "Insufficient permissions");
    require(tokenTreasure > 0, "the trasure is use up"); //之所以取totalSupply_这个变量，是因为这个变量有获取方法，能够读取它的值
    // 获取的token数量必须少于等于 剩余总量
    require(value <= tokenTreasure, "require remaining supply are larger than the tokens");
    //剩余总量 = 剩余总量 - 本次获取的token
    tokenTreasure = tokenTreasure-value;
   
    //这里放一个msg.sender 监控函数
    transfer(to,value);  //这里出了问题 。主要是发送消息时不是从owner发出的而是从合约部署账号发出的.这里的sender是合约。
  
    // balanceOf[to] = balanceOf[to].add(value);
    // emit Transfer(address(this), to, value); //给合约用户发送了Token
  }


}