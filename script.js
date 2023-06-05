$.noConflict();
(function (jQuery) {
	jQuery.Shop = function (element) {
		this.jQueryelement = jQuery(element);
		this.init();
	};

	jQuery.Shop.prototype = {
		init: function () {
			//Свойства
			this.cartPrefix = "Furniture-"; //Префикс
			this.cartName = this.cartPrefix + "cart"; //имя корзины
			this.total = this.cartPrefix + "total"; //текущий ключ корзины
			this.storage = sessionStorage; //

			this.jQueryformAddToCart = this.jQueryelement.find("form.add-to-cart"); //добавить товар
			this.jQueryformCart = this.jQueryelement.find("#shopping-cart"); //корзина
			this.jQuerycheckoutCart = this.jQueryelement.find("#checkout-cart"); //оформление
			this.jQuerycheckoutOrderForm = this.jQueryelement.find("#checkout-order-form"); //инфа о клиенте

			this.jQuerysubTotal = this.jQueryelement.find("#stotal"); //изменение
			this.jQueryshoppingCartActions = this.jQueryelement.find("#shopping-cart-actions"); //ссылка корзины
			this.jQueryupdateCartBtn = this.jQueryshoppingCartActions.find("#update-cart"); //кнопка обновить
			this.jQueryemptyCartBtn = this.jQueryshoppingCartActions.find("#empty-cart"); //очистить
			this.jQueryuserDetails = this.jQueryelement.find("#user-details-content"); //инфа о клеинте

			this.currency = "&#x20b4;"; //Код гривны
			this.currencyString = "₴"; //

			//Вызов методов
			this.createCart();
			this.handleAddToCartForm();
			this.handleCheckoutOrderForm();
			this.emptyCart();
			this.updateCart();
			this.displayCart();
			this.deleteProduct();
			this.displayUserDetails();
		},

		//Створення кошику в пам'яті
		createCart: function () {
			if (this.storage.getItem(this.cartName) == null) {
				var cart = {};
				cart.items = [];
				this.storage.setItem(this.cartName, this._toJSONString(cart));
				this.storage.setItem(this.total, "0");
			}
		},

		//Відображення інформації про клієнта
		displayUserDetails: function () {
			if (this.jQueryuserDetails.length) {
				if (this.storage.getItem("shipping-name") == null) {
					var name = this.storage.getItem("billing-name");
					var login = this.storage.getItem("billing-login");
					var html = "<div class='detail'>";
					html += "<h2>Billing and Shipping</h2>";
					html += "<ul>";
					html += "<li>" + name + "</li>";
					html += "<li>" + login + "</li>";
					html += "</ul></div>";
					this.jQueryuserDetails[0].innerHTML = html;
				}
			}
		},

		//Видалення виробу з кошику
		deleteProduct: function () {
			var self = this;
			if (self.jQueryformCart.length) {
				var cart = this._toJSONObject(this.storage.getItem(this.cartName));
				var items = cart.items;
				jQuery(document).on("click", ".pdelete a", function (e) {
					e.preventDefault();
					var productName = jQuery(this).data("product");
					var newItems = [];
					for (var i = 0; i < items.length; ++i) {
						var item = items[i];
						var product = item.product;
						if (product == productName) {
							items.splice(i, 1);
						}
					}
					newItems = items;
					var updatedCart = {};
					updatedCart.items = newItems;
					var updatedTotal = 0;
					var totalQty = 0;
					if (newItems.length == 0) {
						updatedTotal = 0;
						totalQty = 0;
					} else {
						for (var j = 0; j < newItems.length; ++j) {
							var prod = newItems[j];
							var sub = prod.price * prod.qty;
							updatedTotal += sub;
							totalQty += prod.qty;
						}
					}
					self.storage.setItem(self.total, self._convertNumber(updatedTotal));
					self.storage.setItem(self.cartName, self._toJSONString(updatedCart));
					jQuery(this).parents("tr").remove();
					self.jQuerysubTotal[0].innerHTML = self.currency + " " + self.storage.getItem(self.total);
				});
			}
		},

		//Відображення кошику
		displayCart: function () {
			if (this.jQueryformCart.length) {
				var cart = this._toJSONObject(this.storage.getItem(this.cartName));
				var items = cart.items;
				var jQuerytableCart = this.jQueryformCart.find(".shopping-cart");
				var jQuerytableCartBody = jQuerytableCart.find("tbody");
				if (items.length == 0) {
					jQuerytableCartBody.html("");
				} else {
					for (var i = 0; i < items.length; ++i) {
						var item = items[i];
						var product = item.product;
						var price = item.price + " " + this.currency;
						var qty = item.qty;
						var html = "<tr><td class='pname'>" + product + "</td>" + "<td class='pqty'><input type='text' value='" + qty + "' class='qty'/></td>";
						html += "<td class='pprice'>" + price + "</td><td class='pdelete'><a href='' data-product='" + product + "'>&times;</a></td></tr>";
						jQuerytableCartBody.html(jQuerytableCartBody.html() + html);
					}
				}
				if (items.length == 0) {
					this.jQuerysubTotal[0].innerHTML = 0.00 + " " + this.currency;
				} else {
					var total = this.storage.getItem(this.total);
					this.jQuerysubTotal[0].innerHTML = total + " " + this.currency;
				}
			} else if (this.jQuerycheckoutCart.length) {
				var checkoutCart = this._toJSONObject(this.storage.getItem(this.cartName));
				var cartItems = checkoutCart.items;
				var jQuerycartBody = this.jQuerycheckoutCart.find("tbody");
				if (cartItems.length > 0) {
					for (var j = 0; j < cartItems.length; ++j) {
						var cartItem = cartItems[j];
						var cartProduct = cartItem.product;
						var cartPrice = cartItem.price + " " + this.currency;
						var cartQty = cartItem.qty;
						var cartHTML = "<tr><td class='pname'>" + cartProduct + "</td>" + "<td class='pqty'>" + cartQty + "</td>" + "<td class='pprice'>" + cartPrice + "</td></tr>";
						jQuerycartBody.html(jQuerycartBody.html() + cartHTML);
					}
				} else {
					jQuerycartBody.html("");
				}
				if (cartItems.length > 0) {
					var cartTotal = this.storage.getItem(this.total);
					var cartShipping = this.storage.getItem(this.shippingRates);
					var subTot = this._convertString(cartTotal) + this._convertString(cartShipping);
					this.jQuerysubTotal[0].innerHTML = this._convertNumber(subTot) + " " + this.currency;
					this.jQueryshipping[0].innerHTML = cartShipping + " " + this.currency;
				} else {
					this.jQuerysubTotal[0].innerHTML = 0.00 + " " + this.currency;
					this.jQueryshipping[0].innerHTML = 0.00 + " " + this.currency;
				}
			}
		},

		//Очистка кошику
		emptyCart: function () {
			var self = this;
			if (self.jQueryemptyCartBtn.length) {
				self.jQueryemptyCartBtn.on("click", function () {
					self._emptyCart();
				});
			}
		},

		//Оновлення кошику
		updateCart: function () {
			var self = this;
			if (self.jQueryupdateCartBtn.length) {
				self.jQueryupdateCartBtn.on("click", function () {
					var jQueryrows = self.jQueryformCart.find("tbody tr");
					var cart = self.storage.getItem(self.cartName);
					var total = self.storage.getItem(self.total);
					var updatedTotal = 0;
					var totalQty = 0;
					var updatedCart = {};
					updatedCart.items = [];
					jQueryrows.each(function () {
						var jQueryrow = jQuery(this);
						var pname = jQuery.trim(jQueryrow.find(".pname").text());
						var pqty = self._convertString(jQueryrow.find(".pqty > .qty").val());
						var pprice = self._convertString(self._extractPrice(jQueryrow.find(".pprice")));
						var cartObj = {
							product: pname,
							price: pprice,
							qty: pqty
						};
						updatedCart.items.push(cartObj);
						var subTotal = pqty * pprice;
						updatedTotal += subTotal;
						totalQty += pqty;
					});
					self.storage.setItem(self.total, self._convertNumber(updatedTotal));
					self.storage.setItem(self.cartName, self._toJSONString(updatedCart));
				});
			}
		},

		//Додавання виробів у кошик
		handleAddToCartForm: function () {
			var self = this;
			self.jQueryformAddToCart.each(function () {
				var jQueryform = jQuery(this);
				var jQueryproduct = jQueryform.parent();
				var price = self._convertString(jQueryproduct.data("price"));
				var name = jQueryproduct.data("name");

				jQueryform.on("submit", function () {
					var qty = self._convertString(jQueryform.find(".qty").val());
					var subTotal = qty * price;
					var total = self._convertString(self.storage.getItem(self.total));
					var sTotal = total + subTotal;
					self.storage.setItem(self.total, sTotal);
					self._addToCart({
						product: name,
						price: price,
						qty: qty
					});
				});
			});
		},

		//Обработка формы оформления заказа
		handleCheckoutOrderForm: function () {
			var self = this;
		},

		//Очистка хранилища сеанса
		_emptyCart: function () {
			this.storage.clear();
		},

		// Форматування числа по знаках після коми
		_formatNumber: function (num, places) {
			var rounded = Math.round(num * Math.pow(10, places)) / Math.pow(10, places);
			return rounded.toFixed(places);
		},

		//Извлечение цены из строки
		_extractPrice: function (element) {
			var self = this;
			var text = element.text();
			var price = text.replace(self.currencyString, "").replace(" ", "");
			return price;
		},

		//Конвертація строки цифр в число
		_convertString: function (numStr) {
			var num;
			if (/^[-+]?[0-9]+\.[0-9]+jQuery/.test(numStr)) {
				num = parseFloat(numStr);
			} else if (/^\d+jQuery/.test(numStr)) {
				num = parseInt(numStr, 10);
			} else {
				num = Number(numStr);
			}
			if (!isNaN(num)) {
				return num;
			} else {
				console.warn(numStr + " cannot be converted into a number");
				return false;
			}
		},

		//Конвертація числа в строку
		_convertNumber: function (n) {
			var str = n.toString();
			return str;
		},

		//Конвертація JSON строки в JS об'єкт
		_toJSONObject: function (str) {
			var obj = JSON.parse(str);
			return obj;
		},

		//Конвертація JS об'єкта в JSON строку
		_toJSONString: function (obj) {
			var str = JSON.stringify(obj);
			return str;
		},

		//Додати об'єкт в кошик як JSON строку
		_addToCart: function (values) {
			var cart = this.storage.getItem(this.cartName);
			var cartObject = this._toJSONObject(cart);
			var cartCopy = cartObject;
			var items = cartCopy.items;
			items.push(values);
			this.storage.setItem(this.cartName, this._toJSONString(cartCopy));
		},

		//Збереження введеної користувачем інформації на формі оформлення
		_saveFormData: function (form) {
			var self = this;
			var jQueryvisibleSet = form.find("fieldset:visible");
			jQueryvisibleSet.each(function () {
				var jQueryset = jQuery(this);
				if (jQueryset.is("#fieldset-billing")) {
					var name = jQuery("#name", jQueryset).val();
					var login = jQuery("#login", jQueryset).val();
					self.storage.setItem("billing-name", name);
					self.storage.setItem("billing-login", login);
				}
			});
		}
	};

	jQuery(function () {
		var shop = new jQuery.Shop("#site");
	});

})(jQuery);
