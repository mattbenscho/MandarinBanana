Array.prototype.swap = function (x,y) {
    var b = this[x];
    this[x] = this[y];
    this[y] = b;
    return this;
}

var checkedindex = 4;
var brush = 3;
var stage = new Kinetic.Stage({
    container: 'kineticcontainer',
    width: 640,
    height: 480
});
var isMousedown = false;
var newline;
var points = [];
var color = "black";
var action = "drawing";
var historyStep = 0;
var history = [];
var layerIdCounter = 0;
var rectIdCounter = 0;
var currentLayerId = "L0";
var ahierarchy = [];

function addLayers (number) {
    for (var i=0; i<number; i++) {
	layer = new Kinetic.Layer({id: 'L'+layerIdCounter});
	dragrect = new Kinetic.Rect({width: stage.getWidth(), height: stage.getHeight(), id: 'Rec'+rectIdCounter});
	layerIdCounter++;
	rectIdCounter++;
	layer.add(dragrect);
	layer.setListening(false);
	stage.add(layer);
	ahierarchy.push(layer.getId());
	selectLayer(layer.getId());
    }
    redrawLayerForm();
}
	
function makeHistory() {
    historyStep++;
    if (historyStep < history.length) {
        history.length = historyStep;
    }
    json = layer.toJSON();
    history.push(json);
}

function searcharray(arr, obj) {
    for(var i=0; i<arr.length; i++) {
        if (arr[i] == obj) return i;
    }
}

function undoHistory() {
    if (historyStep > 0) {
        historyStep--;
	var steps = searcharray(ahierarchy,layer.getId());
	ahierarchy.splice(searcharray(ahierarchy,layer.getId()), 1);
	var layerid = layer.getId();
        layer.destroy();
	rectIdCounter++;
        layer = Kinetic.Node.create(history[historyStep], 'container')
	dragrect = new Kinetic.Rect({width: stage.getWidth(), height: stage.getHeight(), id: 'Rec'+rectIdCounter});
	layer.add(dragrect);
	layer.setListening(false);
	layer.setId(layerid);	
	ahierarchy.push(layer.getId());
        stage.add(layer);
	for (var i=1; i < ahierarchy.length-steps; i++) {
	    var position = searcharray(ahierarchy,layer.getId());
	    ahierarchy.swap(position-1,position);
	    layer.moveDown();
	}
	currentLayerId = layer.getId();
	redrawLayerForm();
    }
}

function redoHistory() {
    if (historyStep < history.length-1) {
        historyStep++;
	var steps = searcharray(ahierarchy,layer.getId());
	ahierarchy.splice(searcharray(ahierarchy,layer.getId()), 1);
	var layerid = layer.getId();
        layer.destroy();
	rectIdCounter++;
        layer = Kinetic.Node.create(history[historyStep], 'container')
	dragrect = new Kinetic.Rect({width: stage.getWidth(), height: stage.getHeight(), id: 'Rec'+rectIdCounter});
	layer.add(dragrect);
	layer.setListening(false);
	layer.setId(layerid);	
	ahierarchy.push(layer.getId());
        stage.add(layer);
	for (var i=1; i < ahierarchy.length-steps; i++) {
	    var position = searcharray(ahierarchy,layer.getId());
	    ahierarchy.swap(position-1,position);
	    layer.moveDown();
	}
	currentLayerId = layer.getId();
	redrawLayerForm();
    }
}

function redrawLayerForm() {
    var newHTML = [];
    for (var i=0; i < ahierarchy.length; i++)
    {
	var id = ahierarchy[i];
	if (id == currentLayerId) {	    
	    newHTML[i] = "<input type=\"radio\" name=\"layerRadio\" value=\"" + id + "\" onclick=\"selectLayer('" + id + "');\" checked=\"checked\">" + id + "<br/>";
	} else {
	    newHTML[i] = "<input type=\"radio\" name=\"layerRadio\" value=\"" + id + "\" onclick=\"selectLayer('" + id + "');\">" + id + "<br/>";
	}
    }
    var insert = newHTML.reverse().join("\n");
    document.getElementById('radioForm').innerHTML = insert;
}

function moveLayerUp(rObj) {
    for (var i=0; i < rObj.length; i++) 
    { 
	if (rObj[i].checked && i>0)
	{ 
	    var layerid = rObj[i].value;
	    var position = searcharray(ahierarchy,layerid);
	    ahierarchy.swap(position+1,position);
	    layer.moveUp();
	}
    }
    redrawLayerForm();
}

function moveLayerDown(rObj) {
    for (var i=0; i < rObj.length; i++) 
    { 
	if (rObj[i].checked && i<rObj.length-1)
	{ 
	    var layerid = rObj[i].value;
	    var position = searcharray(ahierarchy,layerid);
	    ahierarchy.swap(position-1,position);
	    layer.moveDown();
	}
    }
    redrawLayerForm();
}

function selectLayer(string) {
    if (layer != null) {
    	layer.setListening(false);
    	layer.setDraggable(false);
    	layer.drawHit();
    }    
    layer = stage.find(eval('\'#'+string+'\''))[0];
    currentLayerId = string;
    if (action == "moving") {
    	updateAction("moving");
    }
    history = [];
    historyStep = 0;
}

function selectBrush(i) {
    brush = i;
}

function updateColor(newcolor) {
    color = newcolor;
}

function updateAction(newaction){
    action = newaction;
    if (action == "drawing"){
	layer.setDraggable(false);
	layer.setListening(false);
	layer.drawHit();
    }
    if (action == "moving"){
	layer.setListening(true);
	layer.setDraggable(true);
	layer.drawHit();
    }
}

stage.on('contentMousedown', function() {
    isMousedown = true;
    if (action != "drawing"){
	return;
    }
    points = [];
    points.push([stage.getPointerPosition().x - layer.getPosition().x,stage.getPointerPosition().y - layer.getPosition().y]);
    var line = new Kinetic.Line({
        points: points,
        stroke: color,
        strokeWidth: brush,
        lineCap: 'round',
        lineJoin: 'round',
	dragOnTop: false
    });
    layer.add(line);
    newline = line;
});

stage.on('contentMousemove', function() {
    if (action == "drawing" && isMousedown) {
	points.push([stage.getPointerPosition().x - layer.getPosition().x,stage.getPointerPosition().y - layer.getPosition().y]);
	newline.setPoints(points);
	newline.drawScene();
    }
});

stage.on('contentMouseup', function() {
    isMousedown = false;
    layer.drawScene();
    makeHistory();
});

addLayers(9);
selectLayer("L4");
redrawLayerForm();
makeHistory();
stage.draw();

