pragma solidity 0.4.19;
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
        
        Assert.equal(marketplace.products[newProductID].name, newProductName, "The corresponding name should be jacket");
        Assert.equal(marketplace.products[newProductID].price, newProductPrice, "The corresponding price should be 500000000");
        Assert.equal(marketplace.products[newProductID].quantity, newProductQuantity, "The corresponding quantity should be 10");
    }
    
    function testUpdatedProduct(){
        Marketplace marketplace = new Marketplace();
        
        string newProductName = "jacket"; 
        uint newProductPrice = 500000000; 
        uint newProductQuantity = 10;
        uint updatedQuantity = 20;
        bytes32 newProductID = marketplace.newProduct("jacket", 500000000, 10);
        
        marketplace.update(newProductID, updatedQuantity);
        
        Assert.equal(marketplace.products[newProductID].quantity, updatedQuantity, "The corresponding quantity should be 20");
    }
}

