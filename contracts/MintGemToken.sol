// 라이센스
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

// ERC721Enumerable : ERC721의 확장, utility 버전
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// remixd -s . --remix-ide https://remix.ethereum.org
// https://remix.ethereum.org/?#activate=klaytn-remix-plugin,fileManager
contract MintGemToken is ERC721Enumerable, Ownable{
  uint constant public MAX_TOKEN_COUNT = 10000;
  uint constant public TOKEN_RANK_LENGTH = 4;
  uint constant public TOKEN_TYPE_LENGTH = 4;

  string public metadataURI;

  // 10^18 peb = 1 Klay
  uint constant public GEM_TOKEN_PRICE = 1000000000000000000;
  // 1000000000000000000

  // string memory _metadataURI
  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender) {

  }

  struct GemTokenData{
    uint gemTokenRank;
    uint gemTokenType;
  }

  mapping(uint => GemTokenData) public gemTokenData;
  // uint를 입력하면 그것에 맞는 GemTokenData를 output한다.
  
  uint[TOKEN_RANK_LENGTH][TOKEN_TYPE_LENGTH] public gemTokenCount;

  // tokenURI는 이름을 틀리면 안 됨
  function tokenURI(uint _tokenId) override public view returns(string memory){ // string을 return 할 때 저장을 하려면 꼭 memory를 적어줘야함
    string memory gemTokenRank = Strings.toString(gemTokenData[_tokenId].gemTokenRank);
    string memory gemTokenType = Strings.toString(gemTokenData[_tokenId].gemTokenType);
    
    return string(abi.encodePacked(metadataURI, '/', gemTokenRank, '/', gemTokenType, '.json'));
  }

  function mintGemToken(uint amount) public payable{
    for (uint i=0;i<amount;i++){
      require(GEM_TOKEN_PRICE <= msg.value, "The fee amount is insufficient.");
      require(MAX_TOKEN_COUNT > amount, "You exceed the limited quantity.");

      uint tokenId = totalSupply() + 1;

      // GemTokenData memory randomTokenData = randomGenerator(msg.sender, tokenId);

      // gemTokenData[tokenId] = GemTokenData(randomTokenData.gemTokenRank, randomTokenData.gemTokenType);

      // gemTokenCount[randomTokenData.gemTokenRank - 1][randomTokenData.gemTokenType - 1] += 1;

      // payable(owner()).transfer(msg.value); // NFT 발행시 스마트 컨트랙트의 Owner에게 전송되는 수수료값 설정

      /* _mint 대신에 _safeMint로 변경 : 보안적으로 더욱 안전하게 Mint 가능 */
      _safeMint(msg.sender, tokenId); // mint 실행 메소드
    }
  }

  function getGemTokenCount() public view returns(uint[TOKEN_RANK_LENGTH][TOKEN_TYPE_LENGTH] memory){
    return gemTokenCount;
  }

  function getGemTokenRank(uint _tokenId) public view returns(uint){
    return gemTokenData[_tokenId].gemTokenRank;
  }

  function getGemTokenType(uint _tokenId) public view returns(uint) {
    return gemTokenData[_tokenId].gemTokenType;
  }

  function randomGenerator(address _msgSender, uint _tokenId) private view returns(GemTokenData memory) {
    uint randomNum = uint(keccak256(abi.encodePacked(blockhash(block.timestamp), _msgSender, _tokenId))) % 100;
    // blockhash(block.timestamp) : 사용자의 현재 시간을 불러옴

    GemTokenData memory randomTokenData;

    if (randomNum < 5) {
      if (randomNum == 1) {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum == 2) {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum == 3) {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 4;
        randomTokenData.gemTokenType = 4;
      }
    } else if (randomNum < 13) {
      if (randomNum < 7) {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum < 9) {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum < 11) {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 3;
        randomTokenData.gemTokenType = 4;
      }
    } else if (randomNum < 37) {
      if (randomNum < 19) {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum < 25) {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum < 31) {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 2;
        randomTokenData.gemTokenType = 4;
      }
    } else {
      if (randomNum < 52) {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 1;
      } else if (randomNum < 68) {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 2;
      } else if (randomNum < 84) {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 3;
      } else {
        randomTokenData.gemTokenRank = 1;
        randomTokenData.gemTokenType = 4;
      }
    }

    return randomTokenData;
  }
}