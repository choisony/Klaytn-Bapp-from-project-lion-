// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

contract NFTSimple {
    string public name = "KlayLion";
    string public symbol = "KL";   //원화같은 단위

    mapping (uint256 => string) public tokenURIs;  //10번 토큰 uri - "pretty"   Universal resource identifier 단순 글자다 라고 이해
    mapping (uint256 => address) public tokenOwner; //10번 토큰 소유자 - "0xA0221fe8591607D4794bB122ef547a8273b7DEFC"
    
    // 소유한 토큰 리스트
    mapping(address => uint256[]) private _ownedTokens; //0xA0221fe8591607D4794bB122ef547a8273b7DEFC - 10,11,12번 토큰 소유중

    // mint(tokenId,uri,owner)  발행(토큰id, 토큰 uri, 소유자)
    // transferFrom(from,to,tokenId) Owner가 바뀌는것임(from -> to)
    

    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public returns (bool){
        //to에게 tokenId(일련번호)를 발행하겠다.
        // 적힐 글자는 tokenURI
        tokenOwner[tokenId] = to; 
        tokenURIs[tokenId] = tokenURI;

        // add token to the list
        _ownedTokens[to].push(tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public{
        require(from == msg.sender, "from != msg.sender");
        require(from == tokenOwner[tokenId], "you're not the owner of the token");
        // 전송했을때 원래갖고있던 주소에서는 빼고, 
        _removeTokenFromList(from, tokenId);
        _ownedTokens[to].push(tokenId);
        // 새로  받은 주소에는 push해줌
        // 토큰의 소유주 바꿔줌
        tokenOwner[tokenId] = to;
    }

    function _removeTokenFromList(address from, uint256 tokenId) private {
        // [10, 15, 19, 20]  에서 19번을 삭제하고싶다면
        // [10, 15, 20, 19] 
        // [10, 15, 20] 이렇게 되는 로직
        uint256 lastTokenIndex = _ownedTokens[from].length-1;
        for (uint256 i=0;i<_ownedTokens[from].length;i++){
            if (tokenId == _ownedTokens[from][i]){
                // swap last token with deleting toke
                _ownedTokens[from][i] = _ownedTokens[from][lastTokenIndex];
                _ownedTokens[from][lastTokenIndex] = tokenId;
                break;
            }
        }
        _ownedTokens[from].length--;
    }

    function ownedTokens(address owner) public view returns (uint256[] memory){
        return _ownedTokens[owner];
    }

    function setTokenUri(uint256 id, string memory uri) public{
        tokenURIs[id] = uri;
    }
}


contract NFTMarket {
    function buyNFT(uint256 tokenId, address NFTAddress, address to) public returns (bool) {
        NFTSimple(NFTAddress).safeTransferFrom(address(this),to,tokenId);
        return true;
    }
}
