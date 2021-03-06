pragma solidity 0.4.21;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
/**
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract Marketplace is Ownable{
    using SafeMath for uint;
    
    event NewProductAdded(bytes32 ID, string name, uint price, uint quantity);
    event ProductUpdate(bytes32 ID, uint updatedStock);
    event Purchase(bytes32 ID, uint quantity, uint price);
    
    struct Product {
        string name;
        uint price;
        uint initialPrice;//Needed for the Dynamic pricing functionality
        uint quantity;
    }
    
    bytes32[] productIDs;
    mapping(bytes32 => Product) products;
    
    function buy(bytes32 ID, uint _quantity) public payable {
        require(products[ID].quantity >= _quantity);
        require(products[ID].price.mul(_quantity) <= msg.value);
        
        products[ID].quantity = products[ID].quantity.sub(msg.value.div(products[ID].price));
        _updatePrice(ID);
        
        emit Purchase(ID, _quantity, msg.value);
    }
    
    function update(bytes32 ID, uint _newQuantity) public onlyOwner {
        require(ID != 0);
        products[ID].quantity = _newQuantity;
        _updatePrice(ID);
        
        emit ProductUpdate(ID, _newQuantity);
    }
    
    //creates a new product and returns its ID
    function newProduct(string _name, uint _price, uint _quantity) public onlyOwner returns(bytes32) {
        bytes memory tempEmptyStringTest = bytes(_name);
        require(tempEmptyStringTest.length != 0);
        bytes32 ID = keccak256(_name, now);
        products[ID] = Product({name: _name, price: _price, initialPrice: _price, quantity: _quantity});
        productIDs.push(ID);
        _updatePrice(ID);//The price, set by the owner upon creation, is the initial (base) one; depending on the given quantity the current price is calculated
        return ID;
        
        emit NewProductAdded(ID, _name, _price, _quantity);
    }
    
    function getProduct(bytes32 ID) public view returns(string name, uint price, uint quantity) {
        require(ID != 0);
        return(products[ID].name, products[ID].price, products[ID].quantity);
    }
    
    function getProducts() public view returns(bytes32[]) {
        return productIDs;
    }
    
    function getPrice(bytes32 ID, uint _quantity) public view returns (uint) {
        require(ID != 0);
        return products[ID].price.mul(_quantity);
    }
    
    function withdraw() public onlyOwner {
        owner.transfer(this.balance);
    }
    //Dynamic pricing functionality 
    function _updatePrice(bytes32 ID) internal returns (uint) {
        require(ID != 0);
        if(products[ID].quantity <= 7 &&  products[ID].quantity >= 4){
            products[ID].price = products[ID].price.mul(2);
        } else if(products[ID].quantity < 4){
            products[ID].price = products[ID].price.mul(3);
        } else{
            products[ID].price = products[ID].initialPrice;
        }
        
        return products[ID].price;
    }

}

