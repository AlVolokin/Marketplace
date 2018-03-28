const Marketplace = artifacts.require("Marketplace");

const Products = {
	productOne : {
		name: "productOne",
		price : 100000,
		quantity: 12
	},
	productTwo : {
		name: "productTwo",
		price : 10,
		quantity: 10
	}
};

contract("Marketplace", async (accounts) => {
	let marketplace;

	beforeEach(async () => {
		marketplace = await Marketplace.new(accounts[0]);
	})

	it("Check owner after deploy", async () => {
		let owner = await marketplace.owner.call();
		assert(owner == accounts[0]);
	})

  it("should create product", async () => {
		let newProductId = await marketplace.newProduct.call(Products.productOne.name, Products.productOne.price, Products.productOne.quantity, {from : accounts[0]});
		let createdProduct = await marketplace.getProduct.call(newProductId);
		await assert(Products.productOne.name == createdProduct[0], "both names should be equal");
	  await assert(Products.productOne.price == createdProduct[1], "both prices should be equal");
	  await assert(Products.productOne.quantity == createdProduct[2], "both quantities should be equal");
	})

  it("should return all product IDs", async () => {
		let newProductOne = await marketplace.newProduct.call(Products.productOne.name, Products.productOne.price, Products.productOne.quantity, {from : accounts[0]});
		let newProductTwo = await marketplace.newProduct.call(Products.productTwo.name, Products.productTwo.price, Products.productTwo.quantity, {from : accounts[0]});

		let ids = await marketplace.getProducts.call();
		assert(ids.length == 2, "Total number of ids should be two");
		assert(ids[0] == newProductOne, "Product Ids should correspond");
		assert(ids[1] == newProductTwo, "Product Ids should correspond");
	})

	it("should update the quantity of the product", async () => {
	  let newProductId = await marketplace.newProduct.call(Products.productOne.name, Products.productOne.price, Products.productOne.quantity, {from : accounts[0]});
		await marketplace.update.call(newProductId, 5, {from : accounts[0]});

		assert(marketplace.products[newProductId].quantity == 5, "The new quantity should be 5");
	})

	it("should buy a product", async () => {
		let newProductId = await marketplace.newProduct.call(Products.productOne.name, Products.productOne.price, Products.productOne.quantity, {from : accounts[0]});
		let buyTx= await marketplace.buy.call(newproductId, 5, {value : Products.productOne.price * 5});

		let product = await marketplace.getProduct.call(newProductId);
		assert(product[2] == 5, "The quantitie should be 5 after the purchase");
	})

  it("should buy a product and update its price", async () => {
		let newProductId = await marketplace.newProduct.call(Products.productOne.name, Products.productOne.price, Products.productOne.quantity, {from : accounts[0]});
		let buyTx= await marketplace.buy.call(newproductId, 5, {value : Products.productOne.price * 5});

		let product = await marketplace.getProduct.call(newProductId);
		assert(product[1] == 200000, "The new price should be 200000, doubled from the default one");
	})

  it("should calculate the price of a certain product", async () => {
		let newProductId = await marketplace.newProduct.call(Products.productOne.name, Products.productOne.price, Products.productOne.quantity, {from : accounts[0]});
		let price = await marketplace.getPrice.call(newProductId, 40);
		assert(price == Products.productOne.price * 40, "The calculated price was not correct");
	})

})
