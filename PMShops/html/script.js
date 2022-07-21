let FuelMaximum = 0;
let isOrder = false;
var PriceFinal = 0;
var CompanyMoneyFuelWise = 0;
let Name = undefined;
let storage = false;
let first = false;
let second = false;
let shop = false;
var id;
$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == 'shop') {
            $('#wrapper').show();
            $("#Shop").addClass("disabledNav");
            $('.shop').show();
            $('.shop .container').html('');
            var length = event.data.result.length;
            for (var i = 0; i < length; i++) {
                if (event.data.result[i].count > 0) {
                    $('.shop .container').append(
                        `<div class = "image" id = ${event.data.result[i].item} label = ${event.data.result[i].label} count = ${event.data.result[i].count} price = ${event.data.result[i].price} style="position:relative">
					    <img src="${event.data.result[i].src}" alt="img/box.png"/>
					    <h3 class = "h4" style="position:relative">${event.data.result[i].label}</h3>
					    <h4 class = "h4" style="position:relative">$${event.data.result[i].price}</h4>
					    <h5 class = "h4" style="position:relative">In stock: ${event.data.result[i].count}x</h5>
				        </div>`
                    );
                }
            }
            $.post("http://PMShops/Owner", JSON.stringify({}), function(cb) {
                if (cb == true) {
                    $(".navigation").show()
                } else {
                    $(".navigation").hide()
                }
            })

            $.post("http://PMShops/GasStationNearby", JSON.stringify({}), function(cb) {
                if (cb == true) {
                    $('#Fuel').show()
                } else {
                    $("#Fuel").hide()
                }
            })

            var CartCount;

            $('.image').on('click', function() {
                $('.navigation').hide();
                $("#cart").load(location.href + " #cart");

                $('.carticon').show();

                CartCount = CartCount + 1;
                var item = $(this).attr('id');
                var label = $(this).attr('label');
                var count = $(this).attr('count');
                var price = $(this).attr('price');

                $("#" + item).hide();


                $.post('http://PMShops/putcart', JSON.stringify({ item: item, price: price, label: label, count: count, id: id }), function(cb) {

                    $('#cart').html('');
                    var length = cb.length;
                    for (var i = 0; i < length; i++) {

                        $('#cart').append(
                            `<div class = "cartitem" label = ${cb[i].label} count = ${cb[i].count} price = ${cb[i].price}>
						<h6>${cb[i].label}</h4>
						<h6>$${cb[i].price} per item</h4>
						<h6>In stock: ${cb[i].count}</h4>
						<input type="text" id = ${cb[i].item} price = ${cb[i].price} count = ${cb[i].count} class = "textareas" placeholder = "How many?"></textarea>
						</div>`
                        );
                    };

                    $('#cart').append(
                        `
						<button class = "buttonPurchase" id = "buybutton">Purchase</button>
						<button class="fas fa-angle-double-left" id = "back" aria-hidden="true"></button>
						`
                    );
                });
            });

            $('.carticon').on('click', function() {
                $('#cart').show();
                $('#wrapper').hide();
                $('.shop').hide();
                $('.storage').hide();
                $('.carticon').hide();
            });

            $("#Shop").on("click", function() {
                $("#Storage").removeClass("disabledNav");
                $("#Boss").removeClass("disabledNav");
                $("#Order").removeClass("disabledNav");
                $("#Fuel").removeClass("disabledNav");
                $("#MyOrders").removeClass("disabledNav");
                $(this).addClass("disabledNav");
                $(".boss").hide();
                $('.order').hide();
                $(".order").html('');
                $(".storage").hide();
                $(".MyOrders").hide();
                $('.fuel').hide();
                $('.shop').show();
                $('.shop .container').html('');
                $.post("http://PMShops/GetItemsFromShop", JSON.stringify({}), function(cb) {
                    var length = cb.length
                    for (var i = 0; i < length; i++) {
                        if (cb[i].count > 0) {
                            $('.shop .container').append(
                                `<div class = "image" id = ${cb[i].item} label = ${cb[i].label} count = ${cb[i].count} price = ${cb[i].price} style="position:relative">
                                <img src="${cb[i].src}" alt="img/box.png"/>
                                <h3 class = "h4" style="position:relative">${cb[i].label}</h3>
                                <h4 class = "h4" style="position:relative">$${cb[i].price}</h4>
                                <h5 class = "h4" style="position:relative">In stock: ${cb[i].count}x</h5>
                                </div>`
                            );
                        }
                    }
                    var CartCount;

                    $('.image').on('click', function() {
                        $('.navigation').hide();
                        $("#cart").load(location.href + " #cart");

                        $('.carticon').show();

                        CartCount = CartCount + 1;
                        var item = $(this).attr('id');
                        var label = $(this).attr('label');
                        var count = $(this).attr('count');
                        var price = $(this).attr('price');

                        $("#" + item).hide();


                        $.post('http://PMShops/putcart', JSON.stringify({ item: item, price: price, label: label, count: count, id: id }), function(cb) {

                            $('#cart').html('');
                            var length = cb.length;
                            for (var i = 0; i < length; i++) {

                                $('#cart').append(
                                    `<div class = "cartitem" label = ${cb[i].label} count = ${cb[i].count} price = ${cb[i].price}>
                            <h6>${cb[i].label}</h4>
                            <h6>$${cb[i].price} per item</h4>
                            <h6>In stock: ${cb[i].count}</h4>
                            <input type="text" id = ${cb[i].item} price = ${cb[i].price} count = ${cb[i].count} class = "textareas" placeholder = "How many?"></textarea>
                            </div>`
                                );
                            };

                            $('#cart').append(
                                `
                                <button class = "buttonPurchase" id = "buybutton">Purchase</button>
                                <button class="fas fa-angle-double-left" id = "back" aria-hidden="true"></button>
                                `
                            );
                        });
                    });
                })
            })

            $('#Fuel').on('click', function() {
                $("#Storage").removeClass("disabledNav");
                $("#Shop").removeClass("disabledNav");
                $("#Order").removeClass("disabledNav");
                $("#Boss").removeClass("disabledNav");
                $("#MyOrders").removeClass("disabledNav");
                $(this).addClass("disabledNav");
                $(".image").hide();
                $(".boss").hide();
                $(".order").hide();
                $('.fuel').hide();
                $(".storage").hide();
                $(".MyOrders").hide();
                $('.shop').hide();
                $('.fuel').html('');
                AppendFuel();
                $.post('http://PMShops/CompanyMoney', JSON.stringify({}), function(cb) {
                    CompanyMoneyFuelWise = cb;
                })

                $.post('http://PMShops/CurrentPrice', JSON.stringify({}), function(cb) {
                    $('.Price').html('Current Price: ' + cb + '$/L');
                })

                $.post("http://PMShops/FuelInLiters", JSON.stringify({}), function(cb) {
                    $('.FuelInLiters').html('Fuel: ' + cb + 'L');
                })

                $.post("http://PMShops/MaxFuelOrder", JSON.stringify({}), function(cb) {
                    FuelMaximum = cb
                    $('.MaxFuel').html('Maximum order: ' + cb + 'L');
                })

                $.post("http://PMShops/PriceFuel", JSON.stringify({}), function(cb) {
                    $('.PriceFuel').html('Refill cost per liter of fuel ' + cb + '$');
                })
                $(".fuel").show();
                $.post('http://PMShops/Fuel', JSON.stringify({}), function(cb) {
                    $('.thermometer').thermometer({
                        percent: cb,
                        speed: 'slow',
                        orientation: "vertical"
                    });
                    $('.FuelAnim .fuelPercent').html(cb + '%')
                });
                $('#confirm').on('click', function() {
                    $(".msg").text('Price sucesfully changed!');
                    AlertNotif();
                    let PriceValue = $("#OrderFuelInput").val()
                    if (PriceValue == 0) {
                        PriceValue = 1
                    }
                    $("#OrderFuelInput").val('')

                    $.post('http://PMShops/Price', JSON.stringify({
                        price: PriceValue
                    }), function(cb) {
                        $('.Price').html('Current Price: ' + cb + '$/L');
                    })
                })
                $('#FuelPickup').one('click', function() {

                    if ($("#OrderFuelInput").val() > FuelMaximum) {
                        $("#OrderFuelInput").val(FuelMaximum)
                    }
                    let OrderedFuel = $("#OrderFuelInput").val()
                    $("#OrderFuelInput").val('')

                    $.post('http://PMShops/escape', JSON.stringify({}));
                    location.reload(true);
                    $("#wrapper").hide()
                    $('.shop').hide();
                    $('#cart').hide();

                    $.post('http://PMShops/FuelPickup', JSON.stringify({
                        OrderedFuel: OrderedFuel,
                        CompanyMoney: CompanyMoneyFuelWise
                    }))

                })
            });

            $("body").on("click", "#refreshcart", function() {
                $.post('http://PMShops/escape', JSON.stringify({}));
                location.reload(true);
                $('#wrapper').hide();
                $('.shop').hide();
                $('#cart').hide();
                $.post('http://PMShops/refresh', JSON.stringify({}));
            });

            $("body").on("click", "#back", function() {
                $('#cart').hide();
                $('#wrapper').show();
                $('.shop').show();
                $('.carticon').show();
            });

            $("body").on("click", "#buybutton", function() {
                var value = document.getElementsByClassName("textareas");
                PriceFinal = 0;
                var length = value.length;
                for (i = 0; i < length; i++) {
                    var PricePerItem = $('#' + value[i].id).attr("price")
                    PriceFinal = PriceFinal + value[i].value * PricePerItem;
                }
                AlertMenuAppend(PriceFinal)

                $('#wrapper').hide();
                $('.shop').hide();
                $('#cart').hide();
                $("#alert").show();
                $("#AlertYes,#AlertNo").click(function() {
                    if (this.id == "AlertYes") {
                        var length = value.length;
                        for (i = 0; i < length; i++) {
                            var isNumber = isNaN(value[i].value) === false;
                            var count = $('#' + value[i].id).attr('count');

                            if (parseInt(count) >= parseInt(value[i].value) && parseInt(value[i].value) != 0 && isNumber) {

                                $.post('http://PMShops/escape', JSON.stringify({}));

                                location.reload(true);
                                $.post('http://PMShops/buy', JSON.stringify({ Count: value[i].value, Item: value[i].id }));
                            }
                        }
                    }
                    $.post('http://PMShops/escape', JSON.stringify({}));
                    location.reload(true);
                    $.post('http://PMShops/emptycart', JSON.stringify({}));
                    $.post('http://PMShops/emptycartOrder', JSON.stringify({}));
                    $.post('http://PMShops/emptyConfirmedList', JSON.stringify({}));
                })
            });


            $('#Boss').on('click', function() {
                $("#Storage").removeClass("disabledNav");
                $("#Shop").removeClass("disabledNav");
                $("#Order").removeClass("disabledNav");
                $("#Fuel").removeClass("disabledNav");
                $("#MyOrders").removeClass("disabledNav");
                $(this).addClass("disabledNav");
                $(".image").hide();
                $(".fuel").hide();
                $(".order").hide();
                $('.shop').hide();
                $(".MyOrders").hide();
                $('.storage').hide();
                $(".boss").html('');
                $('.boss').show();
                $.post("http://PMShops/CompanyName", JSON.stringify({}), function(cb) {
                    $('.CompanyName').html(cb);
                })
                $('.boss').append(
                    `
                    <div class="CompanyName"></div>
                    <div class="CompanyMoney">
                    
                    </div>
                    <div class="container">

                    </div>
                    <div class="ItemsContainerMain">
                        <div class="ItemsContainer">
                        
                        </div>
                        <button id="Confirm" class="ConfirmChangesButton">Change Price</button>
                    </div>
                    <div id="openNav" class="fas fa-angle-double-left" onclick="openNav()">
                    
                    </div>
                    <div id="delSidenav" class="YeetusDeletus">
                        <a href="javascript:void(0)" class="fas fa-angle-double-right" id="closebtn" onclick="closeNav()"></a>
                        <button class="sellCompany" id="Sell"><strong>Sell Company</strong></button>
                    </div>
                    <script>
                        function openNav() {
                            document.getElementById("delSidenav").style.width = "100%";
                        }
        
                        function closeNav() {
                            document.getElementById("delSidenav").style.width = "0";
                        }
                    </script>
                    `
                )
                let once = false;
                $('.boss .container').append(
                    `
                    <div class="Money">
                        <input id="Money" type="number" name="namername" placeholder="$" onfocus="this.placeholder = ''" onblur="this.placeholder = '$'" required>
                        <button id="PutMoney">Deposit</button>
                        <button id="TakeMoney">Withdraw</button>
                    </div>
                    <div class="Name">
                        <input id="Name" type="text" name="namername" placeholder="Shop Name" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Business Name'" required>
                        <button id="ChangeName">Change Name</button>
                    </div>
                    `
                )
                $.post("http://PMShops/CompanyMoney", JSON.stringify({}), function(cb) {
                    $('.CompanyMoney').html('Balance: ' + cb + '$');
                    CompanyMoneyBoss = cb
                })
                $.post('http://PMShops/ShopItems', JSON.stringify({}), function(cb) {
                    var length = cb.length;
                    for (var i = 0; i < length; i++) {
                        if (cb[i].count > 0) {
                            $('.boss .ItemsContainer').append(
                                `
                                <div class="ShopBossBox">
                                    <label class="label">${cb[i].label}</label>
                                    <label class="count">Price: ${cb[i].price}$</label>
                                    <input id=${cb[i].label} type="number" Name = ${cb[i].item} Price = ${cb[i].price}  class="ShopItem" placeholder="Price" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Price'">
                                </div>
                            `
                            )
                        }
                    }

                })

                $('#PutMoney, #TakeMoney, #ChangeName, #Sell, #Confirm').click(function() {
                    if (this.id == 'PutMoney') {
                        $("#PutMoney,#TakeMoney,#ChangeName,#Confirm, .navigation").addClass("disabled");
                        if ($("#Money").val() == 0 || $("#Money").val() < 0) {
                            $("#Money").val('')
                            $("#Money").val('1')
                        }
                        let PriceValue = $("#Money").val()

                        $('.Finished').show();
                        setTimeout(
                            function() {
                                $("#Boss").click();
                                $('.Finished').hide();
                                $(".navigation").removeClass("disabled");
                            },
                            1500);

                        $("#Money").val('')

                        $.post('http://PMShops/Buttons', JSON.stringify({
                            Pressed: true,
                            Amount: PriceValue
                        }))
                        $(".msg").text('Transaction completed sucesfully!');
                        AlertNotif();
                    } else if (this.id == "TakeMoney") {
                        $("#PutMoney,#TakeMoney,#ChangeName,#Confirm, .navigation").addClass("disabled");
                        if ($("#Money").val() == 0 || $("#Money").val() < 0) {
                            $("#Money").val('')
                            $("#Money").val('1')
                        }
                        let PriceValue = $("#Money").val()

                        $("#Money").val('')
                        if (PriceValue <= CompanyMoneyBoss) {
                            $('.Finished').show();
                            setTimeout(
                                function() {
                                    $("#Boss").click();
                                    $('.Finished').hide();
                                    $(".navigation").removeClass("disabled");
                                },
                                1500);
                            $.post('http://PMShops/Buttons', JSON.stringify({
                                Pressed2: true,
                                Amount: PriceValue
                            }))
                            $(".msg").text('Transaction completed sucesfully!');
                            AlertNotif();
                        } else {
                            $(".msg").text('Not enough money in company!');
                            AlertNotif();
                        }
                    } else if (this.id == "ChangeName") {
                        $("#PutMoney,#TakeMoney,#ChangeName,#Confirm").addClass("disabled");
                        if ($("#Name").val()) {
                            Name = $("#Name").val();
                        }
                        if (Name == undefined) {
                            Name = "Shop";
                        }
                        $.post('http://PMShops/Buttons', JSON.stringify({
                            Pressed3: true,
                            Name: Name
                        }))
                        $('.CompanyName').html(Name);
                        Name = $("#Name").val('');
                        $(".msg").text('Name changed sucesfully!');
                        AlertNotif();
                        setTimeout(function() {
                            $("#PutMoney,#TakeMoney,#ChangeName,#Confirm").removeClass("disabled");
                        }, 300)
                    } else if (this.id == "Sell") {
                        $.post('http://PMShops/Buttons', JSON.stringify({
                            Pressed4: true,
                        }))
                        $.post('http://PMShops/escape', JSON.stringify({}));
                        location.reload(true);
                        $('#wrapper').hide();
                        $('.shop').hide();
                        $('.order').hide();
                        $('.storage').hide();
                        $('#deliverywrapper').hide();
                        $('#cart').hide();
                    } else if (this.id == "Confirm") {
                        $("#PutMoney,#TakeMoney,#ChangeName,#Confirm").addClass("disabled");
                        $(".ShopBossBox").find("input[type='number']").each(function() {
                            if (this.value > 0) {
                                once = true;
                                $.post("http://PMShops/ChangePriceItems", JSON.stringify({
                                    Name: $(this).attr("Name"),
                                    NewPrice: this.value
                                }))
                            }
                        })
                        if (once === true) {
                            $('.Finished').show();
                            setTimeout(
                                function() {
                                    $("#Boss").click();
                                    $('.Finished').hide();
                                },
                                1500);
                        } else {
                            $(this).removeClass("disabled");
                            $('#PutMoney,#TakeMoney,#ChangeName,#Confirm,#openNav,.navigation').removeClass("disabled");
                        }
                    }
                });
            });
            $('#Order').on('click', function() {
                $("#Storage").removeClass("disabledNav");
                $("#Shop").removeClass("disabledNav");
                $("#Boss").removeClass("disabledNav");
                $("#Fuel").removeClass("disabledNav");
                $("#MyOrders").removeClass("disabledNav");
                $(this).addClass("disabledNav");
                $(".image").hide();
                $(".fuel").hide();
                $(".boss").hide();
                $('.shop').hide();
                $('.storage').hide();
                $(".MyOrders").hide();
                $(".order").show();
                $('.order').html(`
                <div class="container">

                </div>
                `);
                $.post('http://PMShops/OrderMenu', JSON.stringify({
                    Ordering: true
                }), function(OrderItemsList) {
                    var length = OrderItemsList.length;
                    for (var i = 0; i < length; i++) {
                        if (OrderItemsList[i].Image == undefined) {
                            OrderItemsList[i].Image = `img/box.png`;
                        } else {
                            OrderItemsList[i].Image = OrderItemsList[i].Image.src;
                        };
                        if ($('.order .container').find(`#${OrderItemsList[i].name}`).length === 0) {
                            $('.order .container').append(
                                `<div class = "MenuItem" id = ${OrderItemsList[i].name} label = ${OrderItemsList[i].label}  price = ${OrderItemsList[i].price} style="position:relative">
                                <img style="max-width:100px;max-height:100px;" src="${OrderItemsList[i].Image}"/>
                                    <h3 class = "h4" style="position:relative">${OrderItemsList[i].label}</h3>
                                    <h4 class = "h4" style="position:relative">$${OrderItemsList[i].price}</h4>
                                </div>`
                            );
                        }
                    };
                    var CartCount = 0;

                    $('.MenuItem').on('click', function() {
                        $('.navigation').hide();
                        $("#cart").load(location.href + " #cart");

                        $('.carticon').show();

                        CartCount = CartCount + 1;
                        var item = $(this).attr('id');
                        var label = $(this).attr('label');
                        var price = $(this).attr('price');
                        $("#" + item).hide();

                        $.post('http://PMShops/OrderItemsCart', JSON.stringify({ item: item, price: price, label: label, id: id }), function(cb) {
                            $('#cart').html('');
                            var length = cb.length;
                            for (var i = 0; i < length; i++) {
                                $('#cart').append(
                                    `<div class = "cartitem" label = ${cb[i].label}  price = ${cb[i].price}>
						                <h6>${cb[i].label}</h4>
						                <h6>$${cb[i].price} per item</h4>
						                <input type="number" step="1" id = ${cb[i].item} price="${cb[i].price}" label="${cb[i].label}" class = "textareas" placeholder = "How many?"></textarea>
						             </div>`
                                );
                            };
                            $('#cart').append(
                                `        
						        <button class = "buttonP" id = "PickUp">Pick Up</button>
                                <button class = "buttonD" id = "Delivery">Delivery</button>
						        <button class="fas fa-angle-double-left" id = "back" aria-hidden="true"></button>
						        `
                            );
                        });
                    });
                })
            });
            $("body").on("click", "#PickUp", function() {
                isOrder = false
                var value = document.getElementsByClassName("textareas");
                var length = value.length;
                for (i = 0; i < length; i++) {

                    var isNumber = isNaN(value[i].value) === false;
                    if (value[i].value == 0) {
                        value[i].value = 1;
                    }
                    if (parseInt(value[i].value) != 0 && isNumber) {

                        var price = $('#' + value[i].id).attr('price');
                        let label = $('#' + value[i].id).attr('label');
                        $('#wrapper').hide();
                        $('.shop').hide();
                        $('#cart').hide();
                        $.post('http://PMShops/PickUp', JSON.stringify({ Count: value[i].value, Item: value[i].id, Price: value[i].value * price, Label: label }));
                    } else {
                        $.post('http://PMShops/notify', JSON.stringify({ msg: "~r~Invalid Ammount!" }));
                    }
                }
                $.post('http://PMShops/GetPriceFinal', JSON.stringify({}), function(cb) {
                    PriceFinal = cb
                    AlertMenuAppend(PriceFinal);
                    AlertShowMenu(PriceFinal, isOrder);
                })
                PriceFinal = 0
            });
            $("body").on("click", "#Delivery", function() {
                isOrder = true
                var value = document.getElementsByClassName("textareas");
                var length = value.length;
                for (i = 0; i < length; i++) {

                    var isNumber = isNaN(value[i].value) === false;
                    if (value[i].value == 0) {
                        value[i].value = 1;
                    }
                    if (parseInt(value[i].value) != 0 && isNumber) {

                        var price = $('#' + value[i].id).attr('price');
                        let label = $('#' + value[i].id).attr('label');
                        $('#wrapper').hide();
                        $('.shop').hide();
                        $('#cart').hide();
                        $.post('http://PMShops/Delivery', JSON.stringify({ Count: value[i].value, Item: value[i].id, Price: value[i].value * price, Label: label }));
                    } else {
                        $.post('http://PMShops/notify', JSON.stringify({ msg: "~r~Invalid Ammount!" }));
                    }
                }
                $.post('http://PMShops/GetPriceFinal', JSON.stringify({}), function(cb) {
                    PriceFinal = cb
                    AlertMenuAppend(PriceFinal);
                    AlertShowMenu(PriceFinal, isOrder);
                })
                PriceFinal = 0
            });
            $("#Storage").on('click', function() {
                let HasItemsShop = false;
                let HasItemsStorage = false;
                $("#Boss").removeClass("disabledNav");
                $("#Shop").removeClass("disabledNav");
                $("#Order").removeClass("disabledNav");
                $("#Fuel").removeClass("disabledNav");
                $("#MyOrders").removeClass("disabledNav");
                $(this).addClass("disabledNav");
                $(".image").hide();
                $(".fuel").hide();
                $(".boss").hide();
                $('.shop').hide();
                $('.order').hide();
                $(".MyOrders").hide();
                $(".storage").show();
                $('.storage').html('');
                $('.storage').append(
                    `<div class="Title">Transfer Items</div>
                     <div class="ShopStorage">
                     <div class="TitleShop">Shop:</div>
                     <div class="ShopContainer"></div>
                     </div>
                     <button id = "Transfer" class="TransferItems">Transfer</button>
                     <div class="Storage">
                     <div class="TitleStorage">Storage:</div>
                     <div class="StorageContainer"></div>
                     </div>
                    `
                );
                $.post('http://PMShops/StorageItems', JSON.stringify({}), function(cb) {
                    var length = cb.length;
                    for (var i = 0; i < length; i++) {
                        if (cb[i].count > 0) {
                            HasItemsStorage = true;
                            $('.Storage .StorageContainer').append(
                                `
                                <div class = "StorageBox">
                                    <label class="label">${cb[i].label}</label>
                                    <label class="count">x${cb[i].count}</label>
                                    <input id=${i} type="number" Label = ${cb[i].label} Name = ${cb[i].item} Count = ${cb[i].count} class="StorageItem" placeholder="Amount" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Amount'">
                                </div>
                            `
                            )
                        }
                    }
                })
                $.post('http://PMShops/ShopItems', JSON.stringify({}), function(cb) {
                    var length = cb.length;
                    for (var i = 0; i < length; i++) {
                        if (cb[i].count > 0) {
                            HasItemsShop = true;
                            $('.ShopStorage .ShopContainer').append(
                                `
                                <div class="ShopBox">
                                    <label class="label">${cb[i].label}</label>
                                    <label class="count">x${cb[i].count}</label>
                                    <input id=${cb[i].label} type="number" Name = ${cb[i].item} Count = ${cb[i].count}  class="ShopItem" placeholder="Amount" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Amount'">
                                </div>
                            `
                            )
                        }
                    }
                })
                $("#Transfer").addClass("disabled");
                setTimeout(
                    function() {
                        if (HasItemsShop || HasItemsStorage) {
                            $("#Transfer").removeClass("disabled")
                        }
                    },
                    500);

                $('#Transfer').click(function() {
                    $(this).addClass("disabled");
                    $('.navigation').addClass("disabled");
                    let once = false;
                    let StorageToShopAsWell = false;
                    $(".StorageBox").find("input[type='number']").each(function() {
                        if (this.value > 0) {
                            once = true;
                            StorageToShopAsWell = true;
                            $.post("http://PMShops/StorageToShop", JSON.stringify({
                                Label: $(this).attr("Label"),
                                Item: $(this).attr("Name"),
                                Count: $(this).attr("Count"),
                                AmountMoved: this.value
                            }))
                        }
                    });
                    if (StorageToShopAsWell == true) {
                        setTimeout(
                            function() {
                                $(".ShopBox").find("input[type='number']").each(function() {
                                    if (this.value > 0) {
                                        once = true;
                                        $.post("http://PMShops/ShopToStorage", JSON.stringify({
                                            Item: $(this).attr("Name"),
                                            Count: $(this).attr("Count"),
                                            AmountMoved: this.value
                                        }))
                                    }
                                })
                            },
                            500);
                        StorageToShopAsWell = false;
                    } else {
                        $(".ShopBox").find("input[type='number']").each(function() {
                            if (this.value > 0) {
                                once = true;
                                $.post("http://PMShops/ShopToStorage", JSON.stringify({
                                    Item: $(this).attr("Name"),
                                    Count: $(this).attr("Count"),
                                    AmountMoved: this.value
                                }))
                            }
                        })
                    }
                    if (once === true) {
                        $('.Finished').show();
                        setTimeout(
                            function() {
                                $("#Storage").click();
                                $('.Finished').hide();
                                $(".navigation").removeClass("disabled");
                            },
                            1500);
                    } else {
                        $(this).removeClass("disabled");
                        $('#PutMoney,#TakeMoney,#ChangeName,#Confirm,#openNav,.navigation').removeClass("disabled");
                    }
                })
            })
            $("#MyOrders").on("click", function() {
                $("#Boss").removeClass("disabledNav");
                $("#Shop").removeClass("disabledNav");
                $("#Order").removeClass("disabledNav");
                $("#Fuel").removeClass("disabledNav");
                $("#Storage").removeClass("disabledNav");
                $(this).addClass("disabledNav");
                $(".image").hide();
                $(".fuel").hide();
                $(".boss").hide();
                $('.shop').hide();
                $('.order').hide();
                $('.storage').hide();
                $(".MyOrders").show();
                $('.MyOrders').html('');
                $(".MyOrders").append(`
                <div class="OrdersTitle">Orders</div>
                <div class="container">

                </div>
                `)
                $.post("http://PMShops/DeliveryActive", JSON.stringify({}), function(cb) {
                    if (cb != null) {
                        var length = cb.length
                        for (var i = 0; i < length; i++) {
                            const date = new Date(cb[i].Date);
                            let Text = "";
                            if (cb[i].active == true) {
                                Text = "Order handed off to driver"
                            } else if (cb[i].active == false) {
                                Text = "Order placed"
                            } else if (cb[i].active == undefined || cb[i].active == null) {
                                Text = "Product Delivered"
                            }
                            $(".MyOrders .container").append(`
                            <div class="OrderBox">
                                <div class="OrderBoxTitle">Order:${cb[i].ID}<a id="ViewMore" class="ViewMore" OrderId="${cb[i].ID}" DateStarted="${date.toLocaleDateString("en-US")}" TimeStarted="${cb[i].Time}" active="${cb[i].active}" price = "${parseInt(cb[i].Value) + parseInt(cb[i].DriverCut)}" DateFinished = "${cb[i].DateFinished}" TimeFinished =${cb[i].TimeFinished} Items = ${cb[i].Items}>View More</a></div><br>
                                <div class="OrderDate">Placed on: ${date.toLocaleDateString("en-US")}, ${cb[i].Time} | Total: ${parseInt(cb[i].Value) + parseInt(cb[i].DriverCut)}$</div>
                                <div class="Status">Status: ${Text}</div>
                            </div>
                            `)
                        }
                    } else {
                        first = true
                    }
                })
                $.post("http://PMShops/DeliveryHistory", JSON.stringify({}), function(cb) {
                    if (cb != null) {
                        var length = cb.length
                        for (var i = 0; i < length; i++) {
                            const date = new Date(cb[i].Date);
                            let Text = "";
                            if (cb[i].active == true) {
                                Text = "Order handed off to driver"
                            } else if (cb[i].active == false) {
                                Text = "Order placed"
                            } else if (cb[i].active == null || cb[i].active == undefined) {
                                Text = "Product Delivered"
                            }
                            $(".MyOrders .container").append(`
                                    <div class="OrderBox">
                                        <div class="OrderBoxTitle">Order:${cb[i].ID}<a id="ViewMore" class="ViewMore" OrderId="${cb[i].ID}" DateStarted="${date.toLocaleDateString("en-US")}" TimeStarted="${cb[i].Time}" active=${cb[i].active} price = "${parseInt(cb[i].Value) + parseInt(cb[i].DriverCut)}" DateFinished = "${cb[i].DateFinished}" TimeFinished =${cb[i].TimeFinished} Items = ${cb[i].Items}>View More</a></div><br>
                                        <div class="OrderDate">Placed on: ${date.toLocaleDateString("en-US")}, ${cb[i].Time} | Total: ${parseInt(cb[i].Value) + parseInt(cb[i].DriverCut)}$</div>
                                        <div class="Status">Status: ${Text}</div>
                                    </div>
                                    `)
                        }
                    } else {
                        second = true
                        CheckForOrders()
                    }
                })
            })
            $("body").on("click", "#ViewMore", function() {
                var TimeStarted = $(this).attr('TimeStarted');
                var DateStarted = $(this).attr('DateStarted');
                const DateFinished = new Date(parseInt($(this).attr('DateFinished')));
                var TimeFinished = $(this).attr('TimeFinished');
                var price = $(this).attr('price');
                var active = $(this).attr('active');
                var OrderId = $(this).attr('OrderId');
                var items = jQuery.parseJSON($(this).attr('Items'));
                $('.MyOrders').html('');
                $(".MyOrders").append(
                    `
                        <div class="ContainerForInfo">
                            <div class="TitleOrderId">Order nr.${OrderId}</div>
                            <div class="ContainerForBasicInfo">
                                <div class="PlacedOn">Placed on:<span class="TextInsideDiv1">${DateStarted}, ${TimeStarted}</span></div>
                                <div class="Total">Total:<span class="TextInsideDiv2">${price}$</span></div>
                            </div>
                            <div class="ContainerForAdvancedInfo">
                            <div class="FirstPart">
                            <span class="ConfirmedIcon"><i style="color:#1eb0f6" class="fas fa-clipboard-check"  aria-hidden="true"></i><br><div class="TextUnderIcon">Order confirmed</div></span>
                            <span class="DeliveryStartedIcon"><i class="fas fa-shipping-fast"  aria-hidden="true"></i><br><div class="TextUnderIcon">Driver picked up order</div></span>
                            <span class="DeliveryFinishedIcon"><i class="fas fa-box"  aria-hidden="true"></i><br><div class="TextUnderIcon">Products delivered</div></span>
                            <div class="delivery-progress-bar-wrapper">
                                <div class="delivery-progress-bar" style="width: 100%;"></div>
                            </div>
                            </div>
                            <div class="SecondPart">
                                <div class="TitleItemsOrder">Ordered Items</div>
                                    <div class="AllItemsHere"></div>
                                    <div class="DeliveredOnIfFinished"></div>
                            </div>
                            </div>
                        </div>

                        `
                )
                $.post("http://PMShops/GetImages", JSON.stringify({ Items: items }), function(cb) {
                    var items = jQuery.parseJSON(cb)
                    for (var i in items) {
                        $('.AllItemsHere').append(
                            `
                                <div class="ItemContainer">
                                    <span class="TitleItem">${items[i].label}</span>
                                    <span class="CountItem">${items[i].count}</span>
                                    <span class="Img"><img src="${items[i].img}" alt="img/box.png"/></span>
                                </div>
                                `
                        )
                    }
                })
                if (TimeFinished != 'undefined') {
                    $('.delivery-progress-bar').css({ 'width': '100%' })
                    $('.DeliveryFinishedIcon i').css({ 'color': '#1eb0f6' })
                    $('.DeliveryStartedIcon i').css({ 'color': '#1eb0f6' })
                    $('.DeliveredOnIfFinished').append(`
                        <div class="FinishedTime">Delivered On: ${DateFinished.toLocaleDateString("en-US")}, ${TimeFinished}</div>
                    `)
                } else if (active == "false") {
                    $('.delivery-progress-bar').css({ 'width': '0%' })
                    $('.DeliveredOnIfFinished').append(`
                        <button class="CancelOrder" ID = ${OrderId}>Cancel Order</button>
                    `)
                } else {
                    $('.delivery-progress-bar').css({ 'width': '50%' })
                    $('.DeliveryStartedIcon i').css({ 'color': '#1eb0f6' })
                    $('.DeliveredOnIfFinished').append(`
                    <div class="FinishedTime">Delivery: In Progress...</div>
                `)
                }
            });
            $('body').on('click', '.CancelOrder', function() {
                var ID = $(this).attr("ID")
                $.post("http://PMShops/CancelOrder", JSON.stringify({ ID: ID }))
                location.reload(true);
                $.post('http://PMShops/escape', JSON.stringify({}));
                $.post('http://PMShops/emptycart', JSON.stringify({}));
                $.post('http://PMShops/emptycartOrder', JSON.stringify({}));
                $.post('http://PMShops/emptyConfirmedList', JSON.stringify({}));
                $('#wrapper').hide();
                $('.shop').hide();
                $('.order').hide();
                $('.storage').hide();
                $('#deliverywrapper').hide();
                $('#cart').hide();
                PriceFinal = 0
            })
        } else if (event.data.type == "delivery") {
            $('#deliverywrapper').show()
            $('#deliverywrapper').html('')
            for (var i = 0; i < event.data.result.length; i++) {
                $('#deliverywrapper').append(
                    `
                        <div class="DeliveryBox">
                            <p class="DeliveryText">Business: ${event.data.result[i].name} ordered items for ${event.data.result[i].Value}$</p>
                            <label class="DeliveryText">Job Payout: ${event.data.result[i].DriverCut}$</label>
                            <button class="DeliveryButton" id = "${event.data.result[i].id}" money = "${event.data.result[i].DriverCut}" name="${event.data.result[i].name}" active = "${event.data.result[i].active}" value = "${event.data.result[i].Value}" ShopId="${event.data.result[i].ShopId}" Buyer = "${event.data.result[i].Buyer}"}>Select</button>
                        </div>
                    `
                );
            }
            $('.DeliveryButton').click(function() {
                var price = $(this).attr('money');
                let name = $(this).attr('name');
                let id = $(this).attr('id');
                let active = $(this).attr('active');
                let value = $(this).attr('value');
                let ShopID = $(this).attr('ShopId');
                let Buyer = $(this).attr('Buyer');
                $('#wrapper').hide();
                $('.shop').hide();
                $('#deliverywrapper').hide('fast');
                $('#cart').hide();
                $.post('http://PMShops/PickUpDelivery', JSON.stringify({ ID: id, DriverCut: price, ShopName: name, Active: active, Value: value, ShopID: ShopID, Buyer: Buyer }));
                $.post('http://PMShops/escape', JSON.stringify({}));
                location.reload(true);
            });
        }
    });

    function CheckForOrders() {
        if (first && second) {
            $(".MyOrders").append(
                `
                <div class="NoOrdersDetected">You have not placed any orders yet!</div>
                `
            )
            first = false;
            second = false;
        }
    }

    function AlertMenuAppend(PriceFinal) {
        $('#alert').html('');
        $('#alert').append(
            `
            <div class="OrderContainerAlert">
                <p>You are about to spend:${PriceFinal}$</p>
                <p>Do you wish to continue?</p>
            </div>
            `
        )
        $('#alert .OrderContainerAlert').append(
            `
            <ul class="OrderButtonsAlert">
                <button id="AlertYes">Yes</button>
                <button id="AlertNo">No</button>
            </ul>
            `
        )
    }

    function AlertShowMenu(PriceFinal, isOrder) {
        $('#alert').show('fast');
        $("#AlertYes,#AlertNo").click(function() {
            if (this.id == "AlertYes") {
                $.post('http://PMShops/FinishOrder', JSON.stringify({ PriceFinal: PriceFinal, isOrder: isOrder }));
            }
            location.reload(true);
            $.post('http://PMShops/escape', JSON.stringify({}));
            $.post('http://PMShops/emptycart', JSON.stringify({}));
            $.post('http://PMShops/emptycartOrder', JSON.stringify({}));
            $.post('http://PMShops/emptyConfirmedList', JSON.stringify({}));
        })
    }


    document.onkeyup = function(data) {
        if (data.which == 27) { // Escape key
            location.reload(true);
            $.post('http://PMShops/escape', JSON.stringify({}));
            $.post('http://PMShops/emptycart', JSON.stringify({}));
            $.post('http://PMShops/emptycartOrder', JSON.stringify({}));
            $.post('http://PMShops/emptyConfirmedList', JSON.stringify({}));
            $('#wrapper').hide();
            $('.shop').hide();
            $('.order').hide();
            $('.storage').hide();
            $('#deliverywrapper').hide();
            $('#cart').hide();
            PriceFinal = 0
        }
    }
});

function AppendFuel() {
    $('.fuel').append(
        `
    <div class="FuelAnim">
        <div class="thermometer">
            <div class="thermometer-outer">
                <div class="thermometer-inner">
                </div>
            </div>
        </div>
        <div class="fuelPercent"></div>
    </div>
    <div class="container">
        <div class="br1">
            <div class="Price"></div>
        </div>
        <div class="br2">
            <div class="FuelInLiters"></div>
        </div>
        <div class="br3">
            <div class="MaxFuel"></div>
        </div>
        <div class="br4">
            <div class="PriceFuel"></div>
        </div>
    </div>
    <div class="form-group">
        <div class="actions">Actions</div>
        <div class="inputOrder">
            <input id="OrderFuelInput" type="number" name="namername" placeholder="$ or L" onfocus="this.placeholder = ''" onblur="this.placeholder = '$ or L'">
        </div>
        <div class="namer-controls">
            <div class="text1">Order Fuel:</div>
            <button class="button button1" id="FuelPickup">Pickup</button>
        </div>
        <div class="namer-controls">
            <div class="text2">Set Fuel Price:</div>
            <button class="button button3" id="confirm">$ / L</button>
        </div>
    </div>
        `
    );
}

function AlertNotif() {
    $('.alertnotif').addClass("show");
    $('.alertnotif').removeClass("hide");
    $('.alertnotif').addClass("showAlert");
    setTimeout(function() {
        $('.alertnotif').removeClass("show");
        $('.alertnotif').addClass("hide");
    }, 5000);
    $('.close-btn').click(function() {
        $('.alertnotif').removeClass("show");
        $('.alertnotif').addClass("hide");
    });
}

function Epoch(date) {
    return Math.round(new Date(date).getTime() / 1000.0);
}

function EpochToDate(epoch) {
    if (epoch < 10000000000)
        epoch *= 1000; // convert to milliseconds (Epoch is usually expressed in seconds, but Javascript uses Milliseconds)
    var epoch = epoch + (new Date().getTimezoneOffset() * -1); //for timeZone        
    return new Date(epoch);
}


(function($) {
    $.fn.thermometer = function(options) {
        var settings = $.extend({
            percent: 0,
            orientation: 'horizontal',
            animate: true,
            speed: 1000
        }, options || {});

        return this.each(function() {
            var _percent = $(this).data('percent') || settings.percent,
                _orientation = $(this).data('orientation') || settings.orientation,
                _animate = $(this).data('animate') === false ? false : settings.animate,
                _speed = $(this).data('speed') || settings.speed;

            /* set the orientation */
            _orientation = _orientation.toLowerCase() === 'vertical' ? 'v' : 'h';

            /* set min and max percentage */
            if (isNaN(_percent) || _percent < 0) {
                _percent = 0;
            } else if (_percent > 100) {
                _percent = 100;
            }

            /* override the default "slow" duration used by jQuery.animate() */
            if ($.type(_speed) === 'string' && _speed.toLowerCase() === 'slow') {
                _speed = 1500;
            }

            $(this).html('<div class="thermometer-outer thermometer-outer-' + _orientation + '">' +
                '<div class="thermometer-inner thermometer-inner-' + _orientation + '">' +
                '</div>' +
                '</div>');

            var initialInnerSize = _animate ? 0 : (_percent + '%');
            if (_orientation === 'v') {
                $(this).find('.thermometer-outer').css('position', 'relative');
                $(this).find('.thermometer-inner').css({
                    position: 'absolute',
                    bottom: '0',
                    height: initialInnerSize
                });
            } else {
                $(this).find('.thermometer-inner').css('width', initialInnerSize);
            }

            if (_animate) {
                var animateProperties = {};
                if (_orientation === 'v') {
                    animateProperties.height = _percent + '%';
                } else {
                    animateProperties.width = _percent + '%';
                }
                $(this).find('.thermometer-inner').animate(animateProperties, _speed);
            }
        });
    };
})(jQuery);