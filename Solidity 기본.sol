// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

contract Practice {
    uint256 public totalSupply = 10;
    string public name = "KlayLion";
    address public owner; // contract deployer
    mapping (uint256 => string) public tokenURIs;


    constructor () public{      #####이 트랜잭션을 만드는 Owner 맨처음에 생성함
        owner = msg.sender;
    }

    function get_TotalSupply() public view returns (uint256) {     ###total supply 에 100000000을 더해줌
        return totalSupply + 100000000;
    }
    function set_TotalSupply(uint256 newSupply) public {
        require(owner == msg.sender, 'Not owner');  ########트랜잭션 생성한 Owner만 이 함수를 실행 가능, 다른 주소로 로그인해서 실행 하려고하면 오류
        totalSupply= newSupply;
    }
    function setTokenUri(uint256 id, string memory uri) public{      ##### [5,"Hello"] 라는 형태로 토큰을 생성 id,uri 값
        tokenURIs[id] = uri;
    }
}
