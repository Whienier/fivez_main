/* const CNR_Inventory = new Vue({
	el: "#CNR_Inventory",
    vuetify: new Vuetify(),

	data: {
		ResourceName: "cnr_main",
        ShowMenu: false,
        ShowCreator: false,
        ShowMaxCharacters: true,
		Updating: false,
        Inventory: [],
        GroundInventory: []
	},
	methods: {
		OpenMenu(inventoryData) {
            OpenPage("inventory");
            this.ShowMenu = true;
            
            var strLines = inventoryData.split("\n");
            for (var i in strLines){
                if (i == 0){
                    if (strLines[i] != ""){
                        this.Inventory = JSON.parse(strLines[i]);
                    }
                } else{
                    this.GroundInventory = JSON.parse(strLines[i]);
                }
            }
            document.getElementById("keyPressed").textContent = "true";
            divChecker();
		},

        CloseMenu() {
            this.ShowMenu = false;
            ClosePage("inventory");

            axios.post(`http://cnr_main/nui_close`, {}).then((response) => {console.log(response)}).catch((error) => {console.log(error)});
        },

		UpdateInventory(chars) {
			this.Inventory = JSON.parse(chars);
			this.Updating = false;
        }
	}
})

function divChecker(){
    var val = document.getElementById("keyPressed").textContent;
    switch(val){
        case "false":
            if (CNR_Inventory.ShowMenu == true){
                CNR_Inventory.CloseMenu();
            }
            return;
        case "true":
            break;
        case "":
            break;
    }
    setTimeout(divChecker, 150);
} */

var translations;
var playerMoney = 2500;
var actionLog = [];
var toolTip;
var selectedSlot;
var draggingSlot;
var playerId;
var plyInv;
var otherInv;
var inventoryOpen;
var resourceName;

/* INVENTORY OBJECT */

function closeInventory() {
    document.getElementById('container').style.display = "none";
    inventoryOpen = false;
    $.post(`https://${resourceName}/close_inventory`, {})
}

function useItem() {
    if (selectedSlot && selectedSlot.item && selectedSlot.item.model && selectedSlot.identifier != "ground" && selectedSlot.type != "shop" && selectedSlot.type != "crafting") {
    $.post(`https://${resourceName}/inventory_useItem`,JSON.stringify({fromIdentifier:selectedSlot.identifier,item:selectedSlot.item,fromIndex:selectedSlot.itemIndex+1}));
    }
}

function inventoryCleanup(inv) {
    if (inv) {
    inv.removeChildren(inv.container);
    inv.removeChildren(inv.header);
    }
}

function checkAmountValue(e) {
    if (e.value == "")
    return

    e.value = parseInt(e.value)

    if (e.value < 0) {
    e.value = 0
    return
    }

    e.value = Math.floor(e.value)
}

function Inventory(type,identifier,label,data) {
    this.type       = type;
    this.identifier = identifier;
    this.label      = label || ('Unknown Label: '+label);
    this.data       = data;

    if (identifier == playerId) {
    this.container = document.getElementById('player-inventory');
    this.header    = document.getElementById('player-header');
    } else {
    this.container = document.getElementById('other-inventory');
    this.header    = document.getElementById('other-header');
    }

    this.removeChildren = function(ele) {
    var child = ele.lastChild;
    while (child) {
        child.remove();
        child = ele.lastChild;
    }        
    }

    this.refresh = function(data) {
    this.data = data;
    this.refreshHeader();
    this.refreshContainer();
    }

    this.refreshHeader = function() {
    this.removeChildren(this.header);
    this.constructHeader();
    }

    this.refreshContainer = function() {
    this.removeChildren(this.container);
    this.constructContainer();
    }

    this.constructHeader = function() {
    var title = document.createElement('DIV');
    title.className = "title";
    title.innerHTML = `<b>${this.label}</b>`;
    this.header.appendChild(title);

    var info = document.createElement('DIV');
    info.className = "info";

    var slotA = document.createElement('DIV');
    var slotB = document.createElement('DIV');
    var slotC = document.createElement('DIV');

    if (this.type == "inventory" || this.type == "subinventory") {

        slotA.className = "weight-image";
        slotB.className = "weight-bar";
        slotC.className = "weight-text";
        slotC.textContent = (this.data.identifier == "ground" ? "INF" : this.data.maxWeight);

        var weightFill = document.createElement('DIV');
        weightFill.className = "weight-fill";
        weightFill.textContent = (this.data.identifier == "ground" ? 0 : this.data.weight);
        weightFill.style.width = (this.data.identifier == "ground" ? "0%" : Math.min(100,Math.floor(this.data.weight / this.data.maxWeight * 100))+"%");
        var col = getWeightBarColor(this.data.identifier == "ground" ? 0 : Math.min(this.data.weight,this.data.maxWeight),this.data.maxWeight);
        weightFill.style.backgroundColor = col;

        slotB.appendChild(weightFill);
    } else if (this.type == "shop") {
        if (this.identifier == "bennys"){
            slotB.className = "money";
        slotB.innerHTML = "Benny's Credit Account";
        }else{
        
        slotB.className = "money";
        slotB.innerHTML = "You have <green-text>$${playerMoney}</green-text> to spend".replace('${playerMoney}',playerMoney);
        }
    
    } else if (this.type == "crafting") {
    }

    info.appendChild(slotA);
    info.appendChild(slotB);
    info.appendChild(slotC);

    this.header.appendChild(info);
    }

    this.constructContainer = function() {
    if (this.type == "crafting") {
        this.container.style.gridTemplateRows = `repeat(${Math.ceil(this.data.recipes.length+1 / 2)},170px)`;
        this.container.style.gridTemplateColumns = "50% 50%";

        for (var j=0;j<this.data.recipes.length;j++) {
        var recipe = this.data.recipes[j];
        var craftingSlot = document.createElement('DIV');
        craftingSlot.className = "crafting-slot";

        var slot = document.createElement('DIV');
        slot.className = "grid-slot";

        var item = document.createElement('DIV');
        item.className = "item";

        var count = document.createElement('DIV');
        count.className = "weight";

        var info = document.createElement('DIV');
        info.className = "info";

        slot.className += " crafting-grid-slot";

        item.style.backgroundImage = `url(assets/inventory/${recipe.model}.png)`;

        count.textContent = `${recipe.count} (${recipe.count*recipe.weight})`;

        var l = recipe.label.toUpperCase();
        if (l.length >= 15) {
            l = l.substr(0,15) + "..";
        }
        info.textContent = l;

        item.appendChild(count);
        slot.appendChild(item);
        slot.appendChild(info);

        var recipeSlot = document.createElement('DIV');
        recipeSlot.className = "crafting-info-slot";

        var infoSlot = document.createElement('DIV');
        infoSlot.className = "recipe";
        infoSlot.style.gridTemplateRows = `repeat(${Math.ceil((recipe.required.length+2)/2)},40px)`;

        for (var i=0;i<recipe.required.length;i++) {
            var item = recipe.required[i];
            var image = document.createElement('DIV');
            image.className = "image";
            image.style.backgroundImage = `url(assets/inventory/${item.model}.png)`;

            
            var label = item.label;
            if (label.length >= 12) {
            label = label.substr(0,12) + "..";
            }

            var text = document.createElement('DIV');
            text.className = "text";
            text.textContent = label + ": " + item.count + ":" + item.quality;

            infoSlot.appendChild(image);
            infoSlot.appendChild(text);
        }

        recipeSlot.appendChild(infoSlot);


        craftingSlot.itemIndex = i;
        craftingSlot.item = recipe;
        craftingSlot.type = this.type;
        craftingSlot.identifier = this.identifier;

        craftingSlot.onmouseenter = function(e) {
            if (!this.classList.contains("selected")) {
            this.classList.add("hovered");   
            }
        }

        craftingSlot.onmousedown = function(e) {
            if (toolTip) {
            removeTooltip();
            }

            if (selectedSlot) {
            selectedSlot.slot.classList.remove("selected");
            }

            if (this.item && this.item.model) {
            selectedSlot = {
                slot:this,
                type:this.type,
                itemIndex:this.itemIndex,
                item:this.item,
                identifier:this.identifier
            }

            selectedSlot.slot.classList.add("selected");
            selectedSlot.slot.classList.remove("hovered");

            constructTooltip(this,this.type,this.item); 

            draggingSlot = {
                slot:this,
                x:e.x,
                y:e.y
            }
            }
        }

        craftingSlot.onmouseup = function() {
            if (draggingSlot) {
            if (this == draggingSlot.slot) {
                if (draggingSlot.copy) {
                draggingSlot.copy.remove();
                }
                draggingSlot = undefined;
            }
            }
        }

        craftingSlot.onmousemove = function(e) {     
            if (draggingSlot) {  
            if (!draggingSlot.copy && pointDist(draggingSlot.x,draggingSlot.y,e.x,e.y) >= 5) {     
                createDragCopy(this);
                removeTooltip();
            }
            }
        }

        craftingSlot.onmouseleave = function() {
            if (toolTip) {
            removeTooltip();
            }

            this.classList.remove("hovered");  
        }

        craftingSlot.appendChild(slot);
        craftingSlot.appendChild(recipeSlot);
        this.container.appendChild(craftingSlot);
        }

    } else if (this.type == "combining") {
        this.container.style.gridTemplateRows = `repeat(${Math.ceil(2/2)}, 150px)`;
        this.container.style.gridTemplateColumns = "33.3% 33.3% 33.3%";

        for (var i=0;i<2;i++){
            var slot = document.createElement("DIV");
            slot.className = "grid-slot";

            var item = document.createElement("DIV");
            item.className = "item";

            var itemLabel = document.createElement("SPAN");
            itemLabel.textContent = `EMPTY`

            var itemQuality = document.createElement("DIV");
            itemQuality.className = "quality";
            itemQuality.style.width = 0;
            itemQuality.style.backgroundColor = getQualityBarColor(0);

            var count = document.createElement("DIV");
            count.className = "weight";

            var info = document.createElement("DIV");
            info.className = "info";

            slot.className += " combining-grid-slot";

            info.appendChild(itemLabel);
            info.appendChild(itemQuality);
            item.appendChild(count);
            
            slot.appendChild(item);
            slot.appendChild(info);

            slot.itemInfo = {itemLabel:itemLabel, itemQuality:itemQuality};
            slot.itemIndex = i;
            slot.item = [];
            slot.type = this.type;
            slot.identifier = this.identifier;

            slot.onmouseenter = function(e){
                if (!this.classList.contains("selected")){
                    this.classList.add('hovered');
                }
            }

            slot.onmousedown = function(e){
                if (toolTip){
                    removeTooltip();
                }

                if (selectedSlot) {
                    selectedSlot.slot.classList.remove("selected");
                }

                if (this.item && this.item.model) {
                    this.item = [];
                    this.itemInfo.itemLabel.textContent = ``;
                    this.itemInfo.itemQuality.style.width = 0;
                    
                    var combineSlot = this.parentElement.childNodes[2]
                    if (combineSlot.item && combineSlot.item.model){
                        combineSlot.item = []
                        combineSlot.itemInfo.itemLabel.textContent = ``;
                        combineSlot.itemInfo.itemQuality.style.width = 0;
                    }
                }
            }

            slot.onmouseup = function(){
                if (draggingSlot){
                    if (this == draggingSlot.slot){
                        if (draggingSlot.copy){
                            draggingSlot.copy.remove();
                        }
                        draggingSlot = undefined;
                    } else{
                        if (this.identifier != selectedSlot.identifier) {
                            if (this.type == "combining") {
                                var otherIdentifier = this.identifier;
                                var otherType = this.type;

                                var count = Math.floor(parseInt(document.getElementById('amount').value));
                                count = (count > 0 ? count : (selectedSlot.item.count ? selectedSlot.item.count : 1));

                                this.item = selectedSlot.item;
                                this.itemIndex = selectedSlot.itemIndex;
                                this.itemInfo.itemQuality.style.width = `${selectedSlot.item.quality}%`;
                                this.itemInfo.itemQuality.style.backgroundColor = getQualityBarColor(selectedSlot.item.quality);
                                this.itemInfo.itemLabel.textContent = selectedSlot.item.label;

                                var firstSlot = this.parentElement.childNodes[0];
                                var secondSlot = this.parentElement.childNodes[1];
                                if (firstSlot.item.model && secondSlot.item.model) {
                                    var outputSlot = this.parentElement.childNodes[2];

                                    var combinedQuality = (firstSlot.item.quality + secondSlot.item.quality) > 100 ? 100 : firstSlot.item.quality+secondSlot.item.quality;
                                    outputSlot.firstItemIndex = firstSlot.itemIndex;
                                    outputSlot.secondItemIndex = secondSlot.itemIndex;
                                    outputSlot.item = Object.assign({}, firstSlot.item);
                                    outputSlot.item.style.backgroundImage = `url(assets/inventory/${outputSlot.item.model}.png)`;
                                    outputSlot.item.quality = combinedQuality;

                                    outputSlot.itemInfo.itemQuality.style.width = `${combinedQuality}%`;
                                    outputSlot.itemInfo.itemQuality.style.backgroundColor = getQualityBarColor(combinedQuality);
                                    outputSlot.itemInfo.itemLabel.textContent = `${firstSlot.item.label}`;
                                }
                            }
                        }
                    }
                }
            }
            slot.onmousemove = function(e){
                if (draggingSlot){
                    if (!draggingSlot.copy && pointDist(draggingSlot.x, draggingSlot.y, e.x, e.y) >= 5){
                        createDragCopy(this);
                        removeTooltip();
                    }
                }
            }

            slot.onmouseleave = function(){
                if (toolTip){
                    removeTooltip();
                }

                this.classList.remove("hovered");
            }

            this.container.appendChild(slot);
        }
        var outputSlot = document.createElement("DIV");
        outputSlot.className = "grid-slot";

        var item = document.createElement("DIV");
        item.className = "item";

        var itemLabel = document.createElement("SPAN");
        itemLabel.textContent = ``;

        var itemQuality = document.createElement("DIV");
        itemQuality.className = "quality";
        itemQuality.style.width = 0;
        var info = document.createElement("DIV");
        info.className = "info";

        outputSlot.className += " combining-grid-slot";

        info.appendChild(itemLabel);
        info.appendChild(itemQuality);

        outputSlot.appendChild(item);
        outputSlot.appendChild(info);

        outputSlot.itemInfo = {itemLabel:itemLabel, itemQuality:itemQuality};
        outputSlot.itemIndex = 3;
        outputSlot.firstItemIndex = -1;
        outputSlot.secondItemIndex = -1;
        outputSlot.item = [];
        outputSlot.type = this.type;
        outputSlot.identifier = this.identifier;

        outputSlot.onmouseenter = function(e) {
            if (!this.classList.contains("selected") && this.item.model){
                this.classList.add("hovered");
            }
        }

        outputSlot.onmousedown = function(e) {
            if (toolTip){
                removeTooltip();
            }

            if (selectedSlot){
                selectedSlot.slot.classList.remove("selected");
            }

            if (this.item && this.item.model){
                selectedSlot = {
                    slot:this,
                    type:this.type,
                    identifier:this.identifier,
                    itemIndex:this.itemIndex,
                    item:this.item,
                    firstItemIndex:this.firstItemIndex,
                    secondItemIndex:this.secondItemIndex
                }

                selectedSlot.slot.classList.add("selected");
                selectedSlot.slot.classList.remove("hovered");

                constructTooltip(this, this.type, this.item);

                draggingSlot = {
                    slot:this,
                    x:e.x,
                    y:e.y
                }
            }
        }

        outputSlot.onmouseup = function() {
            if (draggingSlot) {
                if (this == draggingSlot.slot) {
                    if (draggingSlot.copy) {
                        draggingSlot.copy.remove();
                    }
                    draggingSlot = undefined;
                }
            }
        }

        outputSlot.onmousemove = function(e) {
            if (draggingSlot){
                if (!draggingSlot.copy && pointDist(draggingSlot.x, draggingSlot.y, e.x, e.y) >= 5){
                    createDragCopy(this);
                    removeTooltip();
                }
            }
        }

        outputSlot.onmouseleave = function() {
            if (toolTip){
                removeTooltip();
            }
            this.classList.remove("hovered");
        }

        this.container.appendChild(outputSlot);
        
    } else {
        this.container.style.gridTemplateRows = `repeat(${Math.ceil(this.data.maxSlots / 5)},150px)`;
        this.container.style.gridTemplateColumns = "repeat(5,19.5%)";

        for (var i=0;i<this.data.maxSlots;i++) {
        var slot = document.createElement('DIV');
        slot.className = "grid-slot";

        var item = document.createElement('DIV');
        item.className = "item";

        var info = document.createElement('DIV');
        info.className = "info";

        if (this.type == "inventory" || this.type == "subinventory") {
            slot.className += " inventory-grid-slot";
            if (this.data.items[i] && this.data.items[i].model) {
            item.style.backgroundImage = `url(assets/inventory/${this.data.items[i].model}.png)`;

            var itemLabel = document.createElement('SPAN');
            itemLabel.textContent = this.data.items[i].label;

            var itemQuality = document.createElement('DIV');
            itemQuality.className = "quality";
            itemQuality.style.width = (this.data.items[i].quality ? `${this.data.items[i].quality}%` : "100%");
            itemQuality.style.backgroundColor = getQualityBarColor(this.data.items[i].quality);

            var countWeight = document.createElement('DIV');
            countWeight.className = "weight";
            countWeight.textContent = `${this.data.items[i].count} (${this.data.items[i].weight * this.data.items[i].count})`;
            
            if (this.data.items[i].label == "Cash" || this.data.items[i].label == "Dirty Money" ) {
                countWeight.textContent = `$${(this.data.items[i].count).toLocaleString('en')} (${this.data.items[i].weight * this.data.items[i].count})`;

            }
            
            item.appendChild(countWeight);

            if (this.identifier == playerId && i < 5) {
                var hotKey = document.createElement('DIV');
                hotKey.className = "hotkey";
                hotKey.textContent = i + 1;
        
                item.appendChild(hotKey);                
            }

            info.appendChild(itemLabel);
            info.appendChild(itemQuality);
            }
        } else if (this.type == "shop") {
            slot.className += " shop-grid-slot";

            if (this.data.items[i] && this.data.items[i].model) {
            item.style.backgroundImage = `url(assets/inventory/${this.data.items[i].model}.png)`;

            var itemPrice = document.createElement('SPAN');

            if (this.data.items[i].price) {
                itemPrice.innerHTML = `<green-text>$${(this.data.items[i].price).toLocaleString('en')}</green-text>`;

                if (this.data.items[i].buyPrice) {
                itemPrice.innerHTML += ` | <green-text>$${(this.data.items[i].buyPrice).toLocaleString('en')}</green-text>`;
                } 
            } else if (this.data.items[i].buyPrice) {
                itemPrice.innerHTML = `<green-text>$${(this.data.items[i].buyPrice).toLocaleString('en')}</green-text>`;                 
            }

            var itemLabel = document.createElement('SPAN');
            itemLabel.textContent = this.data.items[i].label.toUpperCase();

            info.appendChild(itemPrice);
            info.appendChild(itemLabel);
            } 
        }
        if (!this.data.items[i] || !this.data.items[i].model) {
            slot.style.opacity = 0.7;
        }

        slot.appendChild(item);
        slot.appendChild(info);

        slot.itemIndex = i;
        slot.item = this.data.items[i];
        slot.type = this.type;
        slot.identifier = this.identifier;

        slot.onmouseenter = function(e) {
            if (!this.classList.contains("selected")) {
            this.classList.add("hovered");   
            }
        }

        slot.onmousedown = function(e) {
            if (this.item.model == "Empty") {
                return;
            }

            if (toolTip) {
            removeTooltip();
            }

            if (selectedSlot) {
            selectedSlot.slot.classList.remove("selected");
            }

            if (this.item && this.item.model) {
            selectedSlot = {
                slot:this,
                type:this.type,
                itemIndex:this.itemIndex,
                item:this.item,
                identifier:this.identifier
            }

            selectedSlot.slot.classList.add("selected");
            selectedSlot.slot.classList.remove("hovered");

            constructTooltip(this,this.type,this.item); 

            draggingSlot = {
                slot:this,
                x:e.x,
                y:e.y
            }
            }
        }

        slot.onmouseup = function() {
            if (draggingSlot) {
            if (this == draggingSlot.slot) {
                if (draggingSlot.copy) {
                draggingSlot.copy.remove();
                }
                draggingSlot = undefined;
            } else {
                if (this.identifier != selectedSlot.identifier) {
                var otherIdentifier = this.identifier;
                var otherType = this.type;

                var count = Math.floor(parseInt(document.getElementById('amount').value));
                count = (count > 0 ? count : (selectedSlot.item.count ? selectedSlot.item.count : 1));

                if ((selectedSlot.type != "crafting" && selectedSlot.type != "combining") || selectedSlot.item.buyPrice) {
                    transferItems(selectedSlot.identifier,otherIdentifier,selectedSlot.type,otherType,count,selectedSlot.item,selectedSlot.itemIndex,this.itemIndex);
                } else if (selectedSlot.type == "crafting") {
                    craftItem(selectedSlot.identifier,selectedSlot.item);
                } else if (selectedSlot.type == "combining" && selectedSlot.itemIndex == 3) {
                    combineItems(selectedSlot.firstItemIndex, selectedSlot.secondItemIndex, this.itemIndex);
                } 

                if (draggingSlot.copy) {
                    draggingSlot.copy.remove();
                }

                selectedSlot.slot.classList.remove("selected");
                selectedSlot = undefined;
                draggingSlot = undefined;
                } else {
                var otherIdentifier = this.identifier;
                var otherType = this.type;

                if (otherType != "shop" && otherIdentifier != "ground") {
                    transferLocalItems(otherIdentifier,draggingSlot.count,draggingSlot.item,draggingSlot.itemIndex,this.itemIndex);
                }
                }
            }
            }
        }

        slot.onmousemove = function(e) {     
            if (draggingSlot) {  
            if (!draggingSlot.copy && pointDist(draggingSlot.x,draggingSlot.y,e.x,e.y) >= 5) {     
                createDragCopy(this);
                removeTooltip();
            }
            }
        }

        slot.onmouseleave = function() {
            if (toolTip) {
            removeTooltip();
            }

            this.classList.remove("hovered");  
        }

        this.container.appendChild(slot);
        }
    }
    }

    this.set = function(key,val) {
    this[key] = val;
    }

    this.get = function(key,val) {
    return this[key];
    }

    this.setData = function(key,val) {
    this.data[key] = val;
    }

    this.getData = function(key) {
    return this.data[key];
    }

    this.refresh(this.data);
}

/* QUALITY COLORS */

function getWeightBarColor(cur,max) {
    var pct = cur/max;
    var col = lerpColor("#39bf68","#e85151",pct);
    return col;
}

function getQualityTextColor(num) {
    if (num) {
    var col = lerpColor("#b70000","#00b75b",num/100);
    return col;
    }
}

function getQualityBarColor(num) {
    if (num) {
    var col = lerpColor("#b85151","#597599",num/100);
    return col;
    }
}

function lerpColor(a, b, amount) { 
    var ah = parseInt(a.replace(/#/g, ''), 16),
    ar = ah >> 16, ag = ah >> 8 & 0xff, ab = ah & 0xff,
    bh = parseInt(b.replace(/#/g, ''), 16),
    br = bh >> 16, bg = bh >> 8 & 0xff, bb = bh & 0xff,
    rr = ar + amount * (br - ar),
    rg = ag + amount * (bg - ag),
    rb = ab + amount * (bb - ab);

    return '#' + ((1 << 24) + (rr << 16) + (rg << 8) + rb | 0).toString(16).slice(1);
}

/* DRAG OBJECT */

function createDragCopy(ele) {
    var rect = ele.getBoundingClientRect();
    var copy = document.createElement('DIV');
    copy.className = "copy";
    copy.style.width = "110px";
    copy.style.height = "150px";
    copy.style.left = rect.x + "px";
    copy.style.top = rect.y + "px";

    var item = document.createElement('DIV');
    item.className = "item";
    item.style.backgroundImage = `url(assets/inventory/${ele.item.model}.png)`;

    var countWeight = document.createElement('DIV');
    countWeight.className = "weight";

    var count = Math.floor(parseInt(document.getElementById('amount').value));
    count = (count > 0 ? Math.min((ele.item.count ? ele.item.count : 1),count) : (ele.item.count ? ele.item.count : 1));
    countWeight.textContent = `${count} (${count*ele.item.weight})`;

    var info = document.createElement('DIV');
    info.className = "info";

    info.textContent = ele.item.label;

    item.appendChild(countWeight);
    copy.appendChild(item);
    copy.appendChild(info);

    document.body.appendChild(copy);

    draggingSlot.copy       = copy;
    draggingSlot.count      = count;
    draggingSlot.item       = ele.item;
    draggingSlot.itemIndex  = ele.itemIndex;
}

function pointDist(x1,y1,x2,y2) {
    var a = x1 - x2;
    var b = y1 - y2;
    return Math.sqrt(a*a + b*b);
}

window.addEventListener('mousemove',function(e) {  
    if (draggingSlot) {  
    if (!draggingSlot.copy && pointDist(draggingSlot.x,draggingSlot.y,e.x,e.y) >= 5) {     
        createDragCopy(draggingSlot.slot);
        removeTooltip();
    } else if (draggingSlot.copy) {
        draggingSlot.copy.style.left = e.x + "px";
        draggingSlot.copy.style.top = e.y + "px";
    }
    }
})

window.addEventListener('mouseup',function(e) {
    if (draggingSlot && draggingSlot.copy) {
    if (e.toElement.id == "use") {
        if (selectedSlot && selectedSlot.item && selectedSlot.item.model && selectedSlot.identifier != "ground" && selectedSlot.type != "shop" && selectedSlot.type != "crafting") {
    $.post(`https://${resourceName}/inventory_useItem`,JSON.stringify({fromIdentifier:selectedSlot.identifier,item:selectedSlot.item,fromIndex:selectedSlot.itemIndex+1}));
    }
    }

    draggingSlot.copy.remove();
    draggingSlot = undefined;
    }
})

/* TOOLTIP */

function removeTooltip() {
    if (toolTip) {
    toolTip.remove();
    toolTip = false;
    }
}

function constructTooltip(slot,type,item) {
    var w = window.innerWidth;
    var h = window.innerHeight;
    var rect = slot.getBoundingClientRect();

    toolTip = document.createElement('DIV');
    toolTip.className   = "tooltip";
    toolTip.style.left  = rect.x + rect.width + 20 + "px";

    var label = document.createElement('DIV');
    label.className = "label";
    label.innerHTML = `<b>${item.label}</b><hr>`;

    var info = document.createElement('DIV');
    info.className = "flex";

    var flexItem = document.createElement('DIV');
    if (type == "inventory" || type == "subinventory") {
    flexItem.innerHTML = `<b>`+'Item Weight'+`</b>: ${item.weight*item.count} | <b>`+'Count'+`</b>: ${item.count} | <b>`+'Quality'+`</b>: <empty style='color:${getQualityTextColor(item.quality)}'><b>${item.quality}</b></empty>`;
    } else if (type == "shop") {
    if (item.price) {
        if (item.buyPrice) {
        flexItem.innerHTML = `<b>`+translations["sell_price_text"]+`</b>: <green-text>$${(item.price).toLocaleString('en')}</green-text> | <b>`+translations["buy_price_text"]+`<b>: <green-text>$${(item.buyPrice).toLocaleString('en')}</green-text>`;        
        } else {
        flexItem.innerHTML = `<b>price</b>: <green-text>$${(item.price).toLocaleString('en')}</green-text>`;               
        }   
    } else  if (item.buyPrice) {
        flexItem.innerHTML = `<b>`+translations["buy_price"]+`</b>: <green-text>$${(item.buyPrice).toLocaleString('en')}</green-text>`;
    }   
    } else if (type == "crafting") {
    flexItem.innerHTML = `<b>Weight</b>: ${item.weight*item.count} | <b>Amount</b>: ${item.count} | <b>Quality</b>: <empty style='color:${getQualityTextColor(100)}'><b>${100}</b></empty>`;        
    }

    info.appendChild(flexItem);

    toolTip.appendChild(label);
    toolTip.appendChild(info);

    if (item.description) {
    var desc = document.createElement('DIV');
    desc.className = "description";
    desc.innerHTML = `<hr><i>${item.description}</i>`;
    toolTip.appendChild(desc);
    }

    document.body.appendChild(toolTip);   

    var ttRect = toolTip.getBoundingClientRect();
    var width = ttRect.width;
    var left = ttRect.x;

    if (left + (width/2) >= w) {
    toolTip.style.left  = rect.x - rect.width - 50 + "px";
    }
    toolTip.style.top = rect.y + (ttRect.height / 2) + "px";
}

/* MINIGAME */

var circle = document.getElementById('minigame-player');
var target = document.getElementById('minigame-target');
var radius = circle.r.baseVal.value;
var circumference = radius * 2 * Math.PI; //345
circle.style.strokeDasharray = `${circumference} ${circumference}`;
circle.style.strokeDashoffset = `${circumference}`;

target.style.strokeDasharray = `${circumference} ${circumference}`;
target.style.strokeDashoffset = `${circumference}`;

function setProgress(percent) {
    //345 - 0 / 100 * 345 = 345
    const offset = circumference - percent / 100 * circumference;
    circle.style.strokeDashoffset = offset;
}

function setTarget(rot,percent) {
    //345 - 15 / 100 * 345 = 293.7389131106457 (15% of 345)
    //Get 15 percent in fraction form, times it by circumeference to find the percentage difference, take the difference away from the circumference
    const offset = circumference - percent / 100 * circumference;
    //Tell target to when to stop or start drawing?
    target.style.strokeDashoffset = offset;
    //Rotate the target
    target.style.transform = `rotate(${rot}deg)`;
}

var playingMinigame = false;
var pressedKeys = {};

function startMinigame(length,s) {
    document.getElementById('minigame').style.display = "block";

    playingMinigame = true;

    document.getElementById('minigame-text').textContent = length;

    //Is degrees, how far the target will rotate
    let target = (Math.random()*180) + 35; //Maximum possible value should be 215
    let progress = 0;
    let speed = s;
    setProgress(progress)
    setTarget(target,15);
    //See the target rotation plus the offset result
    //190 + 51 = 241
    console.log(target + (15 / 100 * circumference));
    pressedKeys[" "] = undefined;

    let result;

    function gameLoop() {
    if (playingMinigame) {
        //198, 190 + (15 * 3.6)
        
        //Plus 90 degress onto target?
        if (progress * 3.6 > (target+90) + (15 * 3.6)) {
            playingMinigame = false;    
            result = false;   
        } else {
            if (pressedKeys[" "]) {
                if (progress * 3.6 >= target) {
                    if (length <= 1) {
                        playingMinigame = false;       
                        result = true;         
                    } else {
                        pressedKeys[" "] = false;
                        progress = 0;
                        setProgress(progress);
                        target = (Math.random()*180 + 100);
                        setTarget(target,15);
                        length--;
                        document.getElementById('minigame-text').textContent = length;
                    }
                } else {
                    playingMinigame = false;
                    result = false;
                }
            }
        }
        
        progress += (1 * speed);
        setProgress(progress);  

        window.requestAnimationFrame(gameLoop);
    } else {
        $.post(`https://${resourceName}/minigameComplete`,JSON.stringify({result:result}))
        document.getElementById('minigame').style.display = "none";
    }
    }

    setTimeout(function() {
    window.requestAnimationFrame(gameLoop)
    },1000);
}

closeMinigame = function() {
    playingMinigame = false;
    document.getElementById('minigame').style.display = "none";
    $.post(`https://${resourceName}/closedMinigame`);
}

window.addEventListener('keydown',function(e) { 
    pressedKeys[" "] = true;
});

window.addEventListener('keyup',function(e) { 
    pressedKeys[" "] = false;
});

/* TRANSFER STUFF */
//CRAFTING WIP NOT SURE IF WE WANNA DO IT LIKE THIS
craftItem = function(identifier,recipe) {
    $.post(`https://${resourceName}/craft`,JSON.stringify({identifier:identifier,recipe:recipe}));
}

combineItems = function(firstItemIndex, secondItemIndex, slotDraggedOnto) {
    if (firstItemIndex == secondItemIndex) { return; }
    $.post(`https://${resourceName}/combine_items`, JSON.stringify({
        firstSlotId:firstItemIndex,
        secondSlotId:secondItemIndex,
        slotDraggedOnto:slotDraggedOnto
    }))
}

transferItems = function(fromIdentifier,toIdentifier,fromType,toType,count,item,fromItemIndex,toItemIndex) {
    count = Math.abs(parseInt(count))
    if (fromType == "shop") {
    $.post(`https://${resourceName}/inventory_purchase`,JSON.stringify({
        fromIdentifier:fromIdentifier,
        count:count,
        item:item,
        fromIndex:fromItemIndex+1,
        toIndex:toItemIndex+1
    }));
    } else if (toType == "shop") {
    $.post(`https://${resourceName}/inventory_sell`,JSON.stringify({
        toIdentifier:toIdentifier,
        count:count,
        item:item,
        fromIndex:fromItemIndex+1,
        toIndex:toItemIndex+1
    }));
    } else {
    $.post(`https://${resourceName}/inventory_transfer`,JSON.stringify({
        fromIdentifier:fromIdentifier,
        toIdentifier:toIdentifier,
        count:count,
        item:item,
        fromIndex:fromItemIndex+1,
        toIndex:toItemIndex+1
    }));
    }
}

transferLocalItems = function(identifier,count,item,fromItemIndex,toItemIndex) {
    count = Math.abs(parseInt(count))
    $.post(`https://${resourceName}/inventory_move`,JSON.stringify({
    identifier:identifier,
    fromIndex:fromItemIndex+1,
    toIndex:toItemIndex+1,
    count:count,
    item:item
    }));
}

/* INIT */

function updateActions(actions) {
    actionLog = actions;     

    var notifications = document.getElementById('notifications');
    var child = notifications.lastChild;
    while (child) {
    child.remove();
    child = notifications.lastChild;
    }

    for (var i=0;i<actions.length;i++) {
    var act = actions[i];
    var div = document.createElement('DIV');
    div.textContent = act;
    notifications.appendChild(div);
    }
    notifications.scrollTop = notifications.scrollHeight;
}

var notifCount = 0;

function addNotification(added,item) {
    let container = document.getElementById('swap-notifications');
    let newNotif = document.createElement('DIV');
    newNotif.className = "notification";

    var image = document.createElement('DIV');
    image.className = "image";
    image.style.backgroundImage = `url(assets/inventory/${item.model}.png)`;

    var count = document.createElement('DIV');
    count.className = "count";

    var label = document.createElement("DIV");
    label.className = "label";

    var text = item.label;
    if (text.length >= 10) {
    text = text.substr(0,10) + "..";
    }
    label.innerHTML = `<div>${text}</div>`;

    if (added) {
    count.textContent = `x${item.count} Added`;
    } else {
    count.textContent = `x${item.count} Removed`;
    }

    image.appendChild(count);
    newNotif.appendChild(image);
    newNotif.appendChild(label);
    container.appendChild(newNotif);

    notifCount++;

    container.style.display = "flex";

    setTimeout(function() {
    $(newNotif).fadeOut(500,function() {
        newNotif.remove();
        notifCount--;
        if (notifCount <= 0) {
        container.style.display = "block";
        }
    })
    },2000);
}

var hotkeysOpen = false;
var pressedHotkeys = {};

hotkeyPressed = function(index,hotkeyItems) {
    document.getElementById('hotkeys').style.display = "grid";

    for (var i=0;i<hotkeyItems.length;i++) {
    
    if (!hotkeysOpen) {

        var item = hotkeyItems[i];
        let ele = document.getElementById('hotkey-'+(i+1));
        
        var child = ele.lastChild;
        while (child) {
        child.remove();
        child = ele.lastChild;
        }

        var image = document.createElement('div');
        image.className = "image";

        var key = document.createElement('div');
        key.className = "key";
        key.textContent = i+1;

        var label = document.createElement('div');
        label.className = "label";

        if (item && item.model) {
        image.style.backgroundImage = `url(assets/inventory/${item.model}.png)`;

        var l = item.label;
        if (l && l.length >= 10) {
            l = l.substr(0,10) + "..";
        } 
        label.innerHTML = `<span>${l}</span>`;
        }

        image.appendChild(key);
        ele.appendChild(image);
        ele.appendChild(label);

        if (i+1 == index) {
        var item = hotkeyItems[index];
        pressedHotkeys[index] = Date.now();

        $(ele).animate({top:"-10px"},300);
        $(ele).css({opacity:1.0});

        setTimeout(function() {
            var now = Date.now();
            if (now - pressedHotkeys[index] >= 900) {
            pressedHotkeys[index] = undefined;

            $(ele).animate({top:"0px"},200);
            $(ele).css({opacity:0.0});

            var c = 0;
            for (var key in pressedHotkeys) {
                if (pressedHotkeys[key]) {
                c++;
                }
            }

            if (c <= 0) {
                hotkeysOpen = false;
            }
            }
        },2500)      
        }
    } else {
        var item = hotkeyItems[index];
        let ele = document.getElementById('hotkey-'+(index));

        pressedHotkeys[index] = Date.now();

        $(ele).animate({top:"-10px"},300);
        $(ele).css({opacity:1.0});

        setTimeout(function() {
        var now = Date.now();
        if (now - pressedHotkeys[index] >= 900) {
            $(ele).animate({top:"0px"},200);
            $(ele).css({opacity:0.0});

            pressedHotkeys[index] = undefined;

            var c = 0;
            for (var key in pressedHotkeys) {
            if (pressedHotkeys[key]) {
                c++;
            }
            }

            if (c <= 0) {
            hotkeysOpen = false;
            }
        }
        },2500)       
    }
    }

    hotkeysOpen = true;
}

window.addEventListener('keyup',function(e) {
    if (e.key == "esc" || e.key == "Esc" || e.key == "Escape" || e.key == "escape") {
    if (playingMinigame) {
        closeMinigame();
    } else if (inventoryOpen) {
        if (toolTip) {
        removeTooltip();
        }
        closeInventory();
        console.log("Closing Inv");
        $.post(`https://${this.resourceName}/close_inventory`);
    }
    }
})

window.addEventListener('message',async (event) => {
    if (event.data.type != "message"){
        return;
    }
    switch (event.data.message) {
    case "init":
        resourceName  = event.data.resourceName;
        playerId      = event.data.plyId;
        playerMoney   = (event.data.plyMoney).toLocaleString('en');
        //$.post(`https://${resourceName}/loaded`);

        $("#close-button-text").text("Close");
        $("#use-button-text").text("Use");
    break;

    case "setMoney":
        playerMoney = (event.data.money).toLocaleString('en');
        $('.money').html("You have <green-text>$${{playerMoney}}</green-text> to spend.".replace('${playerMoney}',playerMoney));
    break;

    case "openInventory":
        inventoryOpen = true;

        plyInv = new Inventory(event.data.playerInventory.type,event.data.playerInventory.identifier,event.data.playerInventory.label,event.data.playerInventory);
        otherInv = new Inventory(event.data.otherInventory.type,event.data.otherInventory.identifier,event.data.otherInventory.label,event.data.otherInventory,event.data.otherInventory.isBennys);

        document.getElementById('swap-notifications').style.display = "none";
        document.getElementById('hotkeys').style.display = "none";
        document.getElementById('container').style.display = "block";
    break;

    case "refreshInventory":
        if (event.data.playerInventory) {
        if (plyInv) {
            plyInv.refresh(event.data.playerInventory);
        }
        } 

        if (event.data.otherInventory) {
        if (otherInv) {
            otherInv.refresh(event.data.otherInventory);
        }
        }
    break;

    case "closeInventory":
        document.getElementById('container').style.display = "none";
    break;

    case "startMinigame":
        startMinigame(event.data.length,event.data.speed);
    break;

    case "updateActions":
        updateActions(event.data.actions);
    break;

    case "pressHotkey":
        hotkeyPressed(event.data.index,event.data.hotkeyItems);
    break;

    case "addNotification":
        addNotification(event.data.added,event.data.item);
    break;
    }
})