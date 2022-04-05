let initFlag = false;
let isAndroid = false;
let isIOS = false;
let isPC = false;
const brdgeName = '_currentBridge';
window[`${brdgeName}`] = null;
function getCurrentBridge() {
  return window[`${brdgeName}`];
}

const objcRegisterHandlerName = 'objcRegisterHandler';

function evil(funStr) {
  const Fun = Function;
  return new Fun(`return ${funStr}`)();
}

// html页面中iframe跨域调用监听。
function OnMessage(e) {
  const json = JSON.parse(e.data);
  const funN = evil(json.callback);
  funN(json.response);
}

const callBackObj = {
  success: {},
  error: {},
};

const tmpCallbck = {};

const handleCallbackObj = {
  handle: {},
};

let reqNum = 0;
const maxReqNumOnce = 26;

// 设定同一时间内最大的请求数量，防止回调被覆盖。
function getMagicNum() {
  reqNum++;
  const templeNum = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const tmpNum = reqNum % maxReqNumOnce;
  return templeNum.charAt(tmpNum);
}

// 检查参数undifined
function checkExist(data) {
  return typeof (data) !== 'undefined' && data;
}

// 检查参数数组类型
function checkArray(data) {
  return data instanceof Array;
}

// 检查参数数字类型
function checkNumber(data) {
  return !Number.isNaN(data);
}

// 检查参数jsonObject对象类型
function checkObject(data) {
  const isjson = checkExist(data) && typeof (data) === 'object'
  && Object.prototype.toString.call(data).toLowerCase() === '[object object]' && !data.length;
  return isjson;
}

// 检查参数string类型
function checkString(data) {
  return typeof (data) === 'string';
}

// 检查参数enum类型
function checkEnum(data, typeArray) {
  for (const obj of typeArray) {
    if (obj === data) {
      return true;
    }
  }
  return false;
}

// 注册回调方法。
function regesterCallback(data) {
  const callback = {};
  const tmp = getMagicNum();
  callBackObj.success[tmp] = function suc(res) {
    const successCB = data.success;
    onSuccess(successCB, res);
  };

  callBackObj.error[tmp] = function err(res) {
    const errorCB = (data.error) ? data.error : data.fail;
    onFail(errorCB, res);
  };
  callback.success = `callBackObj.success.${tmp}`;
  callback.error = `callBackObj.error.${tmp}`;
  registerHandler(data);
  return callback;
}

function registerHandler(data) {
  const handler = {};
  const tmp = getMagicNum();
  if (data.process) {
    tmpCallbck[`${tmp} _success`] = data.process;
  } else {
    tmpCallbck[`${tmp} _success`] = (data.handle) ? data.handle : data.success;
  }
  handleCallbackObj.handle[tmp] = function suc(res) {
    const handle = tmpCallbck[`${tmp} _success`];
    onSuccess(handle, res);
  };
  handler.handle = `handleCallbackObj.handle.${tmp}`;
  return handler;
}

// 捕获所有的成功回调，统一做处理。
function onSuccess(fun, data) {
  let res = data;
  if (typeof (data) !== 'object') {
    try {
      const obj = data.replace(/\\/g, '\\\\');
      res = evil(`(${obj})`);
    } catch (e) {
      res = data;
    }
  }
  fun(res);
}

// 捕获所有的异常回调，统一作处理。
function onFail(fun, data) {
  let res = data;
  if (typeof (data) !== 'object') {
    try {
      res = evil(`(${data})`);
    } catch (e) {
      res = data;
    }
  }
  fun(res);
}

// iOS返回结果重新分发
const iOSResponseDispatch = (dataType, jsbReturnObjString, successCb, failCb) => {
  const returnObj = JSON.parse(jsbReturnObjString);
  if (returnObj) {
    if (returnObj.isSuccess === 1 || returnObj.isSuccess === true) {
      if (typeof successCb === 'function') {
        successCb(returnObj.successData);
      } else {
        evil(successCb)(returnObj.successData);
      }
    } else if (typeof failCb === 'function') {
      failCb(returnObj.errorData);
    } else {
      evil(failCb)(returnObj.errorData);
    }
  } else {
    failCb({});
  }
};

const initIOSBridge = callback => {
  if (window.WebViewJavascriptBridge) { return callback(window.WebViewJavascriptBridge) }
  if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback) }
  window.WVJBCallbacks = [callback];
  const WVJBIframe = document.createElement('iframe');
  WVJBIframe.style.display = 'none';
  const key = 'src';
  WVJBIframe[key] = 'https:// __bridge_loaded__';
  document.documentElement.appendChild(WVJBIframe);
  setTimeout(() => { document.documentElement.removeChild(WVJBIframe) }, 0);
  return callback;
};

const initBridge = fun => {
  const intervalTimer = setInterval(() => {
    if (getCurrentBridge()) {
      clearInterval(intervalTimer);
      fun();
    }
  }, 10);
};

const initAndroidBridge = callback => {
  if (window.AppJSBridge) {
    callback(window.AppJSBridge);
  } else if (window.deviceService) {
    callback(window.deviceService);
  }
};

window.AppJsBridge = {
  enableDebugMode: function mode(fun) {
    try {
      fun();
    } catch (e) {
      // do nothing.
    }
  },
  service: {},
};

const getFrameName = () => {
  let frameName = '';
  try {
    if (getUrlParams(window.location.href).frameName) {
      frameName = decodeURIComponent(getUrlParams(window.location.href).frameName);
    } else {
      frameName = '';
    }
  } catch (e) {
    frameName = '';
  }
  return frameName;
}

const doSaveTestReport = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().saveTestReport(JSON.stringify(data.record), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCb = jsbReturnObjString => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    };
    const param = {};
    param.data = data.record;
    param.request = 'acceptanceService.saveTestReport';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCb);
    });
  }
};

function doGetTestReportList(data, success, error) {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getTestReportList(JSON.stringify(data.filter), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCb = jsbReturnObjString => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    };
    const param = {};
    param.data = data.filter;
    param.request = 'acceptanceService.getTestReportList';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCb);
    });
  }
}

function doGetTestReportDetail(data, success, error) {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getTestReportDetail(data.recordId, frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCb = jsbReturnObjString => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    };
    const param = {};
    param.data = data.recordId;
    param.request = 'acceptanceService.getTestReportDetail';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCb);
    });
  }
}

function doDeleteTestReport(data, success, error) {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().deleteTestReport(JSON.stringify(data.deleteIds), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCb = jsbReturnObjString => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    };
    const param = {};
    param.data = data.deleteIds;
    param.request = 'acceptanceService.deleteTestReport';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCb);
    });
  }
}

function doRest(data, success, error) {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().rest(JSON.stringify(data.params), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCb = jsbReturnObjString => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    };
    const param = {};
    param.data = data.params;
    param.request = 'restService.rest';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCb);
    });
  }
}

// 初始化设备信息。
const initServiceBridge = () => {
  if (initFlag === false) {
    initFlag = true;
    recogniseDevice();
    if (isAndroid) {
      initAndroidBridge(bridge => {
        window[`${brdgeName}`] = bridge;
      });
    } else if (isIOS) {
      initIOSBridge(bridge => {
        window[`${brdgeName}`] = bridge;
      });
    } else {
      window[`${brdgeName}`] = window.parent;
    }
  }
};

function recogniseDevice() {
  const sUserAgent = navigator.userAgent.toLowerCase();
  if (sUserAgent.indexOf('android') > -1) {
    isAndroid = true;
  } else if (sUserAgent.indexOf('iphone') > -1 || sUserAgent.indexOf('ipad') > -1) {
    isIOS = true;
  } else {
    isPC = true;
    isIOS = !isPC;
    isAndroid = !isPC;
  }
  return isAndroid;
}

// 响应回退事件
const doBack = success => {
  if (isAndroid) {
    // android请求。
    const data = getCurrentBridge().doAction('exit', '');
    success(data);
  } else if (isIOS) {
    // IOS请求。
    const param = {};
    param.request = 'goBack';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, success);
    });
  } else {
  }
};

const doOpenURL = (data, successCb) => {
  const [title, url] = [data.title, data.url];
  const urlRoot = url.substring(0, url.indexOf('/') + 1);
  const currentUrl = window.location.href;

  let realUrl = null;
  if (currentUrl.lastIndexOf(urlRoot) > 0) {
    realUrl = currentUrl.substring(0, currentUrl.lastIndexOf(urlRoot)) + url;
  } else if (isIOS) {
    const markStr = '/SmartHomePlugin/';
    if (currentUrl.indexOf(markStr) > 0) {
      const tmpUrlArr = currentUrl.split(markStr);
      realUrl = tmpUrlArr[0] + markStr
      + tmpUrlArr[1].substring(0, tmpUrlArr[1].indexOf('/', tmpUrlArr[1].indexOf('/') + 1) + 1) + url;
    }
  } else {
    const markStr = '/smarthome/';
    if (currentUrl.indexOf(markStr) > 0) {
      const tmpUrlArr = currentUrl.split(markStr);
      realUrl = tmpUrlArr[0] + markStr + tmpUrlArr[1].substring(0, tmpUrlArr[1].indexOf('/') + 1) + url;
    }
  }
  realUrl = encodeURI(realUrl);
  if (isAndroid) {
    let frameName = getFrameName();

    if (frameName) {
      getCurrentBridge().openURL(realUrl, title, frameName, '_successCallback');
    } else {
      getCurrentBridge().openURL(realUrl, title, '', '_successCallback');
    }
  } else if (isIOS) {
    const param = {};
    param.request = 'openURL';
    param.title = title;
    param.realUrl = realUrl;
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCb);
    });
  } else {
    getCurrentBridge().openURL(realUrl, title, getUrlParams(window.location.href).frameId, '_successCallback');
  }
};

/**
 *applicationService调用应用插件--执行动作
 */
const doApplicationServiceDoAction = (params, success) => {
  // 这里传入的params包含了applicationName ,serviceName, action 执行动作,parameter 条件数组
  const [applicationName, serviceName, action, parameter]
  = [params.applicationName, params.serviceName, params.action, params.parameters];

  if (isAndroid) {
    let frameName = getFrameName();

    const appData = {};
    appData.applicationName = applicationName;
    appData.serviceName = serviceName;
    appData.action = action;

    if (window.deviceService) {
      getCurrentBridge().applicationServiceDoAction(JSON.stringify(appData),
        JSON.stringify(parameter), frameName, success);
    } else {
      getCurrentBridge().applicationServiceDoAction(JSON.stringify(appData),
        JSON.stringify(parameter), frameName, success);
    }
  } else if (isIOS) {
    const param = {};
    param.request = 'applicationServiceDoAction';
    param.applicationName = params.applicationName;
    param.serviceName = params.serviceName;
    param.action = params.action;
    param.parameter = parameter;
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  } else {
    getCurrentBridge().applicationServiceDoAction(params.applicationName,
      params.serviceName, params.action, JSON.stringify(params.parameters), evil(success));
  }
};

function getUrlParams(url) {
  const params = {};
  url.replace(/[?&]+([^=&]+)=([^&]*)/gi, (str, key, value) => {
    params[key] = value;
  });
  return params;
}

const doSetGatewayAcsStart = (params, success, error) => {
  const param = {};
  param.radioType = params.radioType;
  param.request = 'setGatewayAcsStart';
  if (isAndroid) {
    let frameName = getFrameName();
    // android请求。
    if (frameName) {
      getCurrentBridge().setGatewayAcsStart(param, frameName, success, error);
    } else {
      getCurrentBridge().setGatewayAcsStart(JSON.stringify(param), '', success, error);
    }
  } else if (isIOS) {
    const successCallbackTemp = jsbReturnObjString => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    };
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTemp);
    });
  }
};

const doGetResource = (url, success) => {
  if (isAndroid) {
    let frameName = getFrameName();
    // android请求。
    if (frameName) {
      getCurrentBridge().getResource(url, frameName, success);
    } else {
      getCurrentBridge().getResource(url, '', success);
    }
  } else if (isIOS) {
    const param = {};
    param.request = 'getResource';
    param.url = url;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  }
};

const doIsBatelcoVersion = (url, success) => {
  if (isAndroid) {
    getCurrentBridge().isBatelcoVersion(success);
  } else if (isIOS) {
    const param = {};
    param.request = 'isBatelcoVersion';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  } else {
    getCurrentBridge().getResource(url, evil(success));
  }
};

const doGetAppTarget = (url, success) => {
  if (isAndroid) {
    getCurrentBridge().getAppTarget(success);
  } else if (isIOS) {
    const param = {};
    param.request = 'getAppTarget';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  } else {
    getCurrentBridge().getAppTarget(url, evil(success));
  }
};

const doGetImgFileList = (url, success) => {
  if (isAndroid) {
    getCurrentBridge().getImgFileList(url, success);
  } else if (isIOS) {
    const param = {};
    param.request = 'getImgFileList';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  } else {
    getCurrentBridge().getResource(url, evil(success));
  }
};

const doGetRealTopo = (url, success) => {
  if (isAndroid) {
    getCurrentBridge().getRealTopo(success);
  } else if (isIOS) {
    const param = {};
    param.request = 'getRealTopo';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  } else {
    getCurrentBridge().getResource(url, evil(success));
  }
};

const doShowTitleBar = () => {
  if (isAndroid) {
    getCurrentBridge().showTitleBar();
  } else if (isIOS) {
    const param = {};
    param.request = 'showTitleBar';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param);
    });
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().showTitleBar(getUrlParams(window.location.href).frameId);
  }
};

const doHideTitleBar = () => {
  if (isAndroid) {
    getCurrentBridge().hideTitleBar();
  } else if (isIOS) {
    const param = {};
    param.request = 'hideTitleBar';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param);
    });
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().hideTitleBar(getUrlParams(window.location.href).frameId);
  }
};

const doSetTitleBar = title => {
  if (isAndroid) {
    getCurrentBridge().setTitleBar(title, '');
  } else if (isIOS) {
    const param = {};
    param.request = 'setTitleBar';
    param.title = title;
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param);
    });
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().setTitleBar(title, getUrlParams(window.location.href).frameId);
  }
};

const doSetBarStyle = (success, error, data) => {
  if (isAndroid) {
    getCurrentBridge().setBarStyle(JSON.stringify(data), success);
  } else if (isIOS) {
    const param = {};
    param.request = 'setBarStyle';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, success);
    });
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().setBarStyle(data, getUrlParams(window.location.href).frameId);
  }
};

const doGetAppStyle = success => {
  if (isAndroid) {
    getCurrentBridge().getAppStyle(success);
  } else if (isIOS) {
    const param = {};
    param.request = 'getAppStyle';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, success);
    });
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().getAppStyle(getUrlParams(window.location.href).frameId);
  }
};

const doAddWidgetMoreAction = fun => {
  if (isAndroid) {
    if (getUrlParams(window.location.href).frameId) {
      this.parent.setEventOnElement(getUrlParams(window.location.href).frameId, fun);
    }
  } else if (isIOS) {
    if (getUrlParams(window.location.href).frameId) {
      this.parent.setEventOnElement(getUrlParams(window.location.href).frameId, fun);
    }
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().addWidgetMoreAction(getUrlParams(window.location.href).frameId, fun);
  }
};

const doShowCurrentWidget = () => {
  if (isAndroid) {
    try {
      const [frameId] = [getUrlParams(window.location.href).frameId];
      const iframe = this.parent.document.getElementById(frameId);
      const widgetDiv = this.parent.document.getElementById(`div_${frameId}`);
      widgetDiv.style.display = 'block';
      iframe.parentNode.style.display = 'block';
      // 重绘高度。
      iframe.height = iframe.contentWindow.document.documentElement.scrollHeight;
      // 显示卡片
    } catch (e) {

    }
  } else if (isIOS) {
    try {
      const [frameId] = [getUrlParams(window.location.href).frameId];
      const iframe = this.parent.document.getElementById(frameId);
      const widgetDiv = this.parent.document.getElementById(`div_${frameId}`);
      widgetDiv.style.display = 'block';
      iframe.parentNode.style.display = 'block';
      // 重绘高度。
      iframe.height = iframe.contentWindow.document.documentElement.scrollHeight;
    // 显示卡片
    } catch (e) {

    }
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().showCurrentWidget(getUrlParams(window.location.href).frameId);
  }
};

const doHideCurrentWidget = () => {
  if (isAndroid) {
    try {
      const [frameId] = [getUrlParams(window.location.href).frameId];
      const widgetDiv = this.parent.document.getElementById(`div_${frameId}`);
      widgetDiv.style.display = 'none';
    } catch (e) {

    }
  } else if (isIOS) {
    try {
      const [frameId] = [getUrlParams(window.location.href).frameId];
      const widgetDiv = this.parent.document.getElementById(`div_${frameId}`);
      widgetDiv.style.display = 'none';
    } catch (e) {

    }
  } else if (getUrlParams(window.location.href).frameId) {
    getCurrentBridge().hideCurrentWidget(getUrlParams(window.location.href).frameId);
  }
};

const doGetLocalHostIp = success => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().getLocalHostIp(frameName, success);
  } else if (isIOS) {
    // IOS请求.
    const param = {};
    param.request = 'getLocalHostIp';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  }
};

const doQueryLanDeviceList = (success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryLanDeviceList(frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'gatewayService.queryLanDeviceList';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doQueryLanDeviceListEx = (success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryLanDeviceListEx(frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'gatewayService.queryLanDeviceListEx';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doQueryLanDeviceLevel = (info, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryLanDeviceLevel(JSON.stringify(info), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'gatewayService.queryLanDeviceLevel';
    param.staMac = info.staMac;
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doSetApChannel = (apInfo, success, error) => {
  if (!checkObject(apInfo) || !checkString(apInfo.apMac)
  || !checkEnum(apInfo.radioType, ['G2P4', 'G5', 'G5G2P4']) || !checkNumber(apInfo.channel)) {
    evil(error)({ errCode: '-5', errMsg: 'invalid parameter' });
    return;
  }
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().setApChannel(JSON.stringify(apInfo), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.apInfo = apInfo;
    param.request = 'gatewayService.setApChannel';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doGetWiFiInfoAll = (success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getWiFiInfoAll(frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'gatewayService.getWiFiInfoAll';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doGetUplinkInfo = (success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getUplinkInfo(frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'gatewayService.getUplinkInfo';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doGetSystemInfo = (success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getSystemInfo(frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'gatewayService.getSystemInfo';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doGetLanDeviceName = (lanDeviceMacList, success, error) => {
  if (checkArray(lanDeviceMacList)) {
    if (lanDeviceMacList.length > 0) {
      for (const obj of lanDeviceMacList) {
        if (!checkString(obj)) {
          evil(error)({ errCode: '-5', errMsg: 'invalid parameter' });
          return;
        }
      }
    }
  } else {
    evil(error)({ errCode: '-5', errMsg: 'invalid parameter' });
    return;
  }
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getLanDeviceName(JSON.stringify(lanDeviceMacList), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.lanDeviceMacList = lanDeviceMacList;
    param.request = 'gatewayService.getLanDeviceName';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doStartTest = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().segmentStartTest(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = (nativeReturnJSONStr) => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    }
    const param2 = param;
    param2.request = 'segmentTestSpeedService.startTest';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doGetTestResult = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().segmentGetTestResult(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = (nativeReturnJSONStr) => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    }
    const param2 = param;
    param2.request = 'segmentTestSpeedService.getTestResult';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doGetTestResultAndStatus = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().getSegmentResultAndStatus(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param2 = param;
    param2.request = 'segmentTestSpeedService.getSegmentResultAndStatus';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doQueryProcessResult = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().querySegmentSpeedProcessResult(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param2 = param;
    param2.request = 'segmentTestSpeedService.querySegmentSpeedProcessResult';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doStopTest = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().segmentStopTest(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param2 = param;
    param2.request = 'segmentTestSpeedService.stopTest';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doGetTestConfig = (success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().segmentGetTestConfig(frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'segmentTestSpeedService.getTestConfig';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doGetTestHistoryRecord = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().segmentGetTestHistoryRecord(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param2 = param;
    param2.request = 'segmentTestSpeedService.getTestHistoryRecord';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doSaveTestRecord = (param, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().segmentSaveTestRecord(JSON.stringify(param), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param2 = param;
    param2.request = 'segmentTestSpeedService.saveTestRecord';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param2, successCallbackTem);
    });
  }
};

const doGetWLANNeighborEx = (radioType, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getWLANNeighborEx(radioType, frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'gatewayService.getWLANNeighborEx';
    param.radioType = radioType;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  } else {
  }
};

const doGetUserLabelList = (userLabelFilter, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getUserLabelList(JSON.stringify(userLabelFilter), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param = {};
    param.request = 'accessInsightService.getUserLabelList';
    param.data = userLabelFilter;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  } else {
  }
};

const doGetQualityIncident = (qualityIncidentFilter, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getQualityIncident(qualityIncidentFilter, frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param = {};
    param.request = 'accessInsightService.getQualityIncident';
    param.data = qualityIncidentFilter;
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  } else {
  }
};

const doGetQualityStatistics = (qualityStatisticsFilter, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getQualityStatistics(qualityStatisticsFilter, frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param = {};
    param.request = 'accessInsightService.getUserQualityStatistics';
    param.data = qualityStatisticsFilter;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doGetOntPowerData = (filter, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().getOntPowerData(JSON.stringify(filter), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param = {};
    param.request = 'accessInsightService.getOntPowerData';
    param.data = filter;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doQueryCustomUserLabels = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryCustomUserLabels(JSON.stringify(data), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param = {};
    param.request = 'accessInsightService.queryCustomUserLabels';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doCustomUserLabel = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().customUserLabel(JSON.stringify(data), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };

    const param = {};
    param.request = 'accessInsightService.customUserLabel';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doQueryAllLabels = (success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryAllLabels(frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'accessInsightService.queryAllLabels';

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doQueryVipFaultAlarm = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryVipFaultAlarm(JSON.stringify(data), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'accessInsightService.queryVipFaultAlarm';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doFaultAlarmTicketDispatch = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().faultAlarmTicketDispatch(JSON.stringify(data), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'accessInsightService.faultAlarmTicketDispatch';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doQueryConnectionQualityIncident = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryConnectionQualityIncident(JSON.stringify(data), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'accessInsightService.queryConnectionQualityIncident';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doQueryBandWidthQualityIncident = (data, success, error) => {
  if (isAndroid) {
    // android请求。
    let frameName = getFrameName();
    getCurrentBridge().queryBandWidthQualityIncident(JSON.stringify(data), frameName, success, error);
  } else if (isIOS) {
    const successCallbackTem = nativeReturnJSONStr => {
      iOSResponseDispatch('JSON', nativeReturnJSONStr, success, error);
    };
    const param = {};
    param.request = 'accessInsightService.queryBandWidthQualityIncident';
    param.data = data;

    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallbackTem);
    });
  }
};

const doGetWirelessAccessPointList = (success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().getWirelessAccessPointList(frameName, success, error);
  } else if (isIOS) {
    const param = {};
    param.request = 'getWirelessAccessPointList';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, evil(success));
    });
  } else {
  }
};

const doGetLanDeviceMemoName = (macList, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().getLanDeviceMemoName(JSON.stringify(macList), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.macList = macList;
    param.request = 'controllerService.getLanDeviceMemoName';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doJudgeLocalNetwork = (success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().judgeLocalNetwork(frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'judgeLocalNetwork';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doQueryLanDeviceManufacturingInfoList = (macList, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().queryLanDeviceManufacturingInfoList(JSON.stringify(macList), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.macList = macList;
    param.request = 'controllerService.queryLanDeviceManufacturingInfoList';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doGetFeatureList = (features, success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().getFeatureList(JSON.stringify(features), frameName, success, error);
  } else if (isIOS) {
    // IOS请求。
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    // IOS请求。
    const param = {};
    param.features = features;
    param.request = 'controllerService.getFeatureList';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  } else {
  }
};

const doQueryEvaluationThreshold = (success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().queryEvaluationThreshold(frameName, success, error);
  } else if (isIOS) {
    // IOS请求.
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'systemService.queryEvaluationThreshold';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  }
};

const doQueryGatewayName = (success, error) => {
  if (isAndroid) {
    let frameName = getFrameName();
    getCurrentBridge().queryGatewayName(frameName, success, error);
  } else if (isIOS) {
    // IOS请求.
    const successCallback = (jsbReturnObjString) => {
      // 由于JS框架不能传多个回调，所以这里再来重新划分
      iOSResponseDispatch('JSON', jsbReturnObjString, success, error);
    }
    const param = {};
    param.request = 'controllerService.queryGatewayName';
    initBridge(() => {
      getCurrentBridge().callHandler(objcRegisterHandlerName, param, successCallback);
    });
  }
};

window.AppJsBridge.service.acceptanceService = {
  saveTestReport: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doSaveTestReport(data, callback.success, callback.error);
  },
  getTestReportList: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetTestReportList(data, callback.success, callback.error);
  },
  getTestReportDetail: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetTestReportDetail(data, callback.success, callback.error);
  },
  deleteTestReport: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doDeleteTestReport(data, callback.success, callback.error);
  },
};

window.AppJsBridge.service.localeService = {
  getResource: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetResource(window.location.href, callback.success);
  },
  isBatelcoVersion: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doIsBatelcoVersion(window.location.href, callback.success);
  },
  getImgFileList: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetImgFileList(window.location.href, callback.success);
  },
  getRealTopo: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetRealTopo(window.location.href, callback.success);
  },
  getAppTarget: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetAppTarget(window.location.href, callback.success);
  },
};

window.AppJsBridge.service.controllerService = {
  getWirelessAccessPointList: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetWirelessAccessPointList(callback.success, callback.error);
  },
  getLanDeviceMemoName: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetLanDeviceMemoName(data.macList, callback.success, callback.error);
  },
  queryLanDeviceManufacturingInfoList: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryLanDeviceManufacturingInfoList(data.macList, callback.success, callback.error);
  },
  getFeatureList: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetFeatureList(data.features, callback.success, callback.error);
  },
  judgeLocalNetwork: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doJudgeLocalNetwork(callback.success, callback.error);
  }
};

/**
 * 新增需求 (TCP/UDP SOCKET API 实现与ONT近端SOCKET请求的JS端API)
 */
window.AppJsBridge.service.socketService = {
  getLocalHostIp: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetLocalHostIp(callback.success, callback.error);
  },
};

/**
 * 增加applicationService调用应用插件
 */
window.AppJsBridge.service.applicationService = {
  // 插件调用--执行动作
  doAction: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doApplicationServiceDoAction(data, callback.success, callback.error);
  },
  showTitleBar: () => {
    initServiceBridge();
    doShowTitleBar();
  },
  hideTitleBar: () => {
    initServiceBridge();
    doHideTitleBar();
  },
  setTitleBar: title => {
    initServiceBridge();
    doSetTitleBar(title);
  },
  closePage: data => {
    initServiceBridge();
    doBack(data.success, data.error);
  },
  openURL: data => {
    initServiceBridge();
    doOpenURL(data, data.success, data.error);
  },
  // 给卡片添加【发现更多】的点击事件。
  addWidgetMoreAction: fun => {
    initServiceBridge();
    doAddWidgetMoreAction(fun);
  },
  showCurrentWidget: () => {
    initServiceBridge();
    doShowCurrentWidget();
  },
  hideCurrentWidget: () => {
    initServiceBridge();
    doHideCurrentWidget();
  },
  setBarStyle: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doSetBarStyle(callback.success, data.error, data.requestData);
  },
  getAppStyle: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetAppStyle(callback.success, data.error);
  },
};

/**
 * 对wifi的相关操作。
 */
window.AppJsBridge.service.wifiService = {
  setGatewayAcsStart: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doSetGatewayAcsStart(data.params, callback.success, callback.error);
  },
};

window.AppJsBridge.service.segmentTestSpeedService = {
  startTest: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doStartTest(data.parameters, callback.success, callback.error);
  },
  getTestResult: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetTestResult(data.parameters, callback.success, callback.error);
  },
  getTestResultAndStatus: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetTestResultAndStatus(data.parameters, callback.success, callback.error);
  },
  stopTest: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doStopTest(data.parameters, callback.success, callback.error);
  },
  getTestConfig: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetTestConfig(callback.success, callback.error);
  },
  getTestHistoryRecord: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doGetTestHistoryRecord(data.parameters, callback.success, callback.error);
  },
  saveTestRecord: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doSaveTestRecord(data.parameters, callback.success, callback.error);
  },
  queryProcessResult: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doQueryProcessResult(data.parameters, callback.success, callback.error);
  },
};

window.AppJsBridge.service.accessInsightService = {
  getUserLabelList: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetUserLabelList(data.userLabelFilter, callback.success, callback.error);
  },
  getQualityIncident: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetQualityIncident(data.qualityIncidentFilter, callback.success, callback.error);
  },
  getQualityStatistics: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetQualityStatistics(data.qualityStatisticsFilter, callback.success, callback.error);
  },
  getOntPowerData: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetOntPowerData(data.filter, callback.success, callback.error);
  },
  queryCustomUserLabels: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryCustomUserLabels(data.param, callback.success, callback.error);
  },
  queryAllLabels: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryAllLabels(callback.success, callback.error);
  },
  customUserLabel: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doCustomUserLabel(data.param, callback.success, callback.error);
  },
  queryVipFaultAlarm: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryVipFaultAlarm(data.param, callback.success, callback.error);
  },
  faultAlarmTicketDispatch: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doFaultAlarmTicketDispatch(data.param, callback.success, callback.error);
  },
  queryConnectionQualityIncident: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryConnectionQualityIncident(data.param, callback.success, callback.error);
  },
  queryBandWidthQualityIncident: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryBandWidthQualityIncident(data.param, callback.success, callback.error);
  }
};
window.AppJsBridge.service.gatewayService = {
  queryLanDeviceList: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryLanDeviceList(callback.success, callback.error);
  },
  queryLanDeviceListEx: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryLanDeviceListEx(callback.success, callback.error);
  },
  queryLanDeviceLevel: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryLanDeviceLevel(data.parameters, callback.success, callback.error);
  },
  setApChannel: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doSetApChannel(data.apInfo, callback.success, callback.error);
  },
  getWiFiInfoAll: data => {
    let callback = regesterCallback(data);
    initServiceBridge();

    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetWiFiInfoAll(callback.success, callback.error);
  },
  getUplinkInfo: data => {
    let callback = regesterCallback(data);
    initServiceBridge();

    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetUplinkInfo(callback.success, callback.error);
  },
  getSystemInfo: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetSystemInfo(callback.success, callback.error);
  },
  getLanDeviceName: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetLanDeviceName(data.lanDeviceMacList, callback.success, callback.error);
  },
  getWLANNeighborEx: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doGetWLANNeighborEx(data.radioType, callback.success, callback.error);
  },
  queryGatewayName: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryGatewayName(callback.success, callback.error);
  },
};

window.AppJsBridge.service.systemService = {
  queryEvaluationThreshold: data => {
    let callback = regesterCallback(data);
    initServiceBridge();
    if (isIOS) {
      // IOS请求。
      callback = data;
    }
    doQueryEvaluationThreshold(callback.success, callback.error);
  },
};

window.AppJsBridge.service.restService = {
  rest: data => {
    const callback = regesterCallback(data);
    initServiceBridge();
    doRest(data, callback.success, callback.error);
  },
};