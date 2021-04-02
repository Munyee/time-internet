var currentBridge = null;

function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {
                                  callback(WebViewJavascriptBridge)
                                  }, false)
    }
}




var load = function() {
    connectWebViewJavascriptBridge(
                                   function(bridge) {
                                   currentBridge = bridge;
                                 
                                   bridge.init(function(message, responseCallback) { });
                          
                                     init(bridge);
                                   }
                                );
	
}
                                   
                                   
 function init(bridge){
                                   var data = {};
                                   data.request = "getWedgists";
                bridge.send(data, function(responseData) {
                            
                           // alert(responseData);
                            initWedgist(responseData);
                            
                               })
                 }

var initWedgist = function(data) {

    var obj = eval(data);
    var more = "View More";
    
    if(obj.more){
        more = obj.more;
        obj = obj.wedgistArray;
    }
    
    var rootDom = document.getElementById("main");
    rootDom.innerHTML = "";
    for ( var i = 0; i < obj.length; i++) {
        var wedgist = obj[i];
        console.log(JSON.stringify(wedgist));
        
        var cardContentDiv = $dom("div");
        rootDom.appendChild(cardContentDiv);
        cardContentDiv.setAttribute("class", "card_content");
        cardContentDiv.setAttribute("id","div_iframe_"+i);
        if(i == 0 && "MIAN_FAMILY_NETWORK" != wedgist["id"]){
            cardContentDiv.setAttribute("class", "card_content first_card");
        }
        
        var titleDiv = $dom("div");
        titleDiv.setAttribute("class", "title_txt");
        var leftTopColorSpan = $dom("span");
        leftTopColorSpan.setAttribute("class", "title_color_span");
        titleDiv.appendChild(leftTopColorSpan);
        var cardTitleSpan = $dom("span");
        
        cardTitleSpan.innerHTML = wedgist["title"];
        cardTitleSpan.setAttribute("class", "title_txt_span");
        titleDiv.appendChild(cardTitleSpan);
        if("MIAN_FAMILY_NETWORK" == wedgist["id"]){
            titleDiv.setAttribute("class", "hide_title");
        }
        
        var showMoreImgSpan = $dom("span");
        showMoreImgSpan.setAttribute("class", "title_next");
        var nextImg = $dom("img");
        nextImg.setAttribute("src", "next.png");
        showMoreImgSpan.appendChild(nextImg);
        titleDiv.appendChild(showMoreImgSpan);
        
        cardContentDiv.appendChild(titleDiv)
        
        var divDom = $dom("div");
        divDom.setAttribute("class", "frame_content");
        var iframeDom = $dom("iframe");
        iframeDom.setAttribute("frameborder", "no");
        iframeDom.setAttribute("name", "iframe_" + i);
        iframeDom.setAttribute("id", "iframe_" + i);
        iframeDom.setAttribute("scrolling", "no");
        iframeDom.setAttribute("allowtransparency", "true");
        
        iframeDom.setAttribute("src", "file://" + wedgist["path"]
                               + "?frameName=iframe_" + i + "&frameId=iframe_" + i);
        
        //		iframeDom.setAttribute("onload", "initIframeHeight(this)");
        divDom.appendChild(iframeDom);
        cardContentDiv.appendChild(divDom);
        
        var bottomDiv = $dom("div");
        bottomDiv.setAttribute("class", "bottom_more");
        
        var refreshSpan = $dom("span");
        refreshSpan.setAttribute("class", "refresh_img");
        var refreshImg = $dom("img");
        refreshImg.setAttribute("src", "refresh.png");
        
        refreshImg.id =  "iframe_" + i;
        refreshImg.addEventListener('click', function(event){
                                    var id = event.currentTarget.id;
                                    var iframe = document.getElementById(id);
                                    iframe.contentWindow.location.reload();
                                    event.stopPropagation();
                                    });
        
        refreshSpan.appendChild(refreshImg);
        bottomDiv.appendChild(refreshSpan);
        
        var showMoreTxtSpan = $dom("span");
        showMoreTxtSpan.setAttribute("class", "more");
        showMoreTxtSpan.innerHTML = more;
        bottomDiv.appendChild(showMoreTxtSpan);
        
//        var showMoreImgSpan = $dom("span");
//        showMoreImgSpan.setAttribute("class", "next");
//        var nextImg = $dom("img");
//        nextImg.setAttribute("src", "next.png");
//        showMoreImgSpan.appendChild(nextImg);
//        bottomDiv.appendChild(showMoreImgSpan);
        cardContentDiv.appendChild(bottomDiv);
    }
}

var initIframeHeight = function(obj){
	setTimeout(function() {
		obj.height = obj.contentWindow.document.documentElement.scrollHeight;
	}, 100);
}

var $dom = function(tagName) {
	return document.createElement(tagName);
}

function refreshPage(flag) {
	if (flag) {
		cleanPage();
		return;
	}
	load();
}

function cleanPage() {
	document.getElementById("main").innerHTML = "";
}

function reloadPage(){
	cleanPage();
	load();
}

function iframeCallback(response, frameName, callback) {
	var messageData = {
		"response" : response,
		"callback" : callback
	};
	var fra = document.getElementById(frameName);
	fra.contentWindow.postMessage(JSON.stringify(messageData), "*");
}

function getFramePosition(frameId){
	var frame = document.getElementById(frameId);
	var position = {"x":frame.offsetLeft,"y":frame.offsetTop,"height":frame.offsetHeight,"width":frame.offsetWidth};
	return position;
}

function setEventOnElement(frameId,fun){
    var frame = document.getElementById(frameId);
    var cardDiv = frame.parentNode.parentNode;
    var spans = cardDiv.getElementsByTagName("span");
    for(var i = 0; i < spans.length; i++){
        var span = spans[i];
        if(span.getAttribute("class") && (span.getAttribute("class") == "next" || span.getAttribute("class") == "more")){
            span.onclick = fun;
            span.style.display = "block";
        }
        
        if(span.getAttribute("class") && span.getAttribute("class") == "title_next"){
            span.parentNode.onclick = fun;
            span.style.display = "block";
        }
        
    }
}
