const marketplace = artifacts.require("Marketplace");

const TestProducts = {
	ProductOne : {
		name: "jacket",
		price : 15000000,
		quantity: 10
	},
	ProductTwo : {
		name: "gloves",
		price : 100000,
		quantity: 0
	},
};

contract('Marketplace test', async (accounts) => {
  it("should create product", async () => {
    let ins = await marketplace.deployed();
  
    var acc = accounts[0];
    
		let ProductOneId = await ins.newProduct(ProductOne.name, ProductOne.price, ProductOne.quantity, {from: acc});
		let createdProduct = await ins.getProduct.call(basicProductId);
		
		await assert(ProductOne.name == createdProduct[0], "names should correspond");
	  await assert(ProductOne.price == createdProduct[1], "prices should correspond");
	  await assert(ProductOne.quantity == createdProduct[2], "quantities should correspond");
	})
	
	it("should update product", async () => {
    let ins = await marketplace.deployed();
  
    var acc = accounts[0];
    
		let ProductOneId = await ins.newProduct(ProductOne.name, ProductOne.price, ProductOne.quantity, {from: acc});
		
		await ins.update(ProductOneId, 15, {from: acc});
		
		let product = await ins.getProduct.call(ProductOneId);
		await assert(product[2] == 15, "Product quantitty is not updated");
	})
	
	
})
