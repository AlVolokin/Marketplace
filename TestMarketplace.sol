import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Marketplace.sol";

contract TestMarketplace {
    
    function testNewProductAdded(){
        Marketplace marketplace = new Marketplace();
        
        string newProductName = "jacket"; 
        uint newProductPrice = 500000000; 
        uint newProductQuantity = 10;
        bytes32 newProductID = marketplace.newProduct("jacket", 500000000, 10);
        
        Assert.equal(marketplace.getProduct.products[newProductID].name, newProductName, "The corresponding name should be jacket");
        Assert.equal(marketplace.getProduct.products[newProductID].price, newProductPrice, "The corresponding price should be 500000000");
        Assert.equal(marketplace.getProduct.products[newProductID].quantity, newProductQuantity, "The corresponding quantity should be 10");
    }
}