<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Forward Settings</title>
    <!-- Bootstrap CSS and JS dependencies for UIBootgrid -->
    <link rel="stylesheet" href="/ui/css/bootstrap.min.css">
    <link rel="stylesheet" href="/ui/css/jquery.bootgrid.min.css">
    <script src="/ui/js/jquery-1.12.4.min.js"></script>
    <script src="/ui/js/bootstrap.min.js"></script>
    <script src="/ui/js/jquery.bootgrid.min.js"></script>
    <script src="/ui/js/opnsense_bootgrid_plugin.js"></script>

    <style>
    body {
        margin: 0;
        padding: 10px;
        background: #fff;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    }
    .content-box {
        border: none;
        box-shadow: none;
        margin: 0;
        padding: 0;
    }
    .table-responsive {
        border: none;
    }
    .table {
        margin-bottom: 0;
    }
    .bootgrid-header {
        padding: 10px 0;
    }
    .search-field {
        margin-bottom: 10px;
    }
    .actionBar {
        padding: 10px 0;
    }
    h3 {
        margin-top: 0;
        margin-bottom: 15px;
        font-size: 18px;
        color: #333;
    }
    hr {
        margin: 10px 0 20px 0;
    }
    </style>
</head>
<body>

<script>
    $( document ).ready(function() {
        // 存储接收到的CSRF令牌
        var receivedCSRFToken = '';
        
        // 监听来自父窗口的postMessage
        window.addEventListener('message', function(event) {
            // 验证消息来源（可选，根据需要调整）
            // if (event.origin !== window.location.origin) return;
            
            // 支持两种消息格式以确保兼容性
            if (event.data && event.data.type === 'csrf-token' && event.data.token) {
                receivedCSRFToken = event.data.token;
                console.log('Received CSRF token via postMessage (new format):', receivedCSRFToken.substring(0, 10) + '...');
                
                // 立即设置Ajax配置
                setupAjaxWithCSRF(receivedCSRFToken);
            } else if (event.data && event.data.type === 'csrf_token' && event.data.csrf) {
                receivedCSRFToken = event.data.csrf;
                console.log('Received CSRF token via postMessage (old format):', receivedCSRFToken.substring(0, 10) + '...');
                
                // 立即设置Ajax配置
                setupAjaxWithCSRF(receivedCSRFToken);
            }
        });
        
        // 设置Ajax配置的函数
        function setupAjaxWithCSRF(csrfToken) {
            $.ajaxSetup({
                beforeSend: function(xhr, settings) {
                    if (csrfToken) {
                        xhr.setRequestHeader('X-CSRFToken', csrfToken);
                        console.log('Setting CSRF token in request header for:', settings.url);
                    }
                }
            });
        }
        
        // 延迟初始化，确保DOM完全加载和CSRF令牌已接收
        setTimeout(function() {
            // 如果还没有通过postMessage接收到CSRF令牌，尝试其他方法
            if (!receivedCSRFToken) {
                console.log('No CSRF token received via postMessage, trying fallback methods');
                
                var csrfToken = '';
                
                // 备用方法1: 从父窗口的meta标签获取
                if (window.parent && window.parent.document) {
                    try {
                        var metaTag = window.parent.document.querySelector('meta[name="csrf-token"]');
                        if (metaTag) {
                            csrfToken = metaTag.getAttribute('content');
                        }
                    } catch (e) {
                        console.log('Cannot access parent document meta tags:', e);
                    }
                }
                
                // 备用方法2: 从父窗口的input字段获取
                if (!csrfToken && window.parent && window.parent.document) {
                    try {
                        var csrfInput = window.parent.document.querySelector('input[name="__csrf_magic"]');
                        if (csrfInput) {
                            csrfToken = csrfInput.value;
                        }
                    } catch (e) {
                        console.log('Cannot access parent document input fields:', e);
                    }
                }
                
                // 备用方法3: 从父窗口的全局变量获取
                if (!csrfToken && window.parent && typeof window.parent.csrfToken !== 'undefined') {
                    try {
                        csrfToken = window.parent.csrfToken;
                    } catch (e) {
                        console.log('Cannot access parent window global variables:', e);
                    }
                }
                
                // 备用方法4: 从父窗口的Ajax设置中获取
                if (!csrfToken && window.parent && window.parent.$) {
                    try {
                        var parentAjaxSettings = window.parent.$.ajaxSettings;
                        if (parentAjaxSettings && parentAjaxSettings.beforeSend) {
                            var mockXHR = {
                                setRequestHeader: function(name, value) {
                                    if (name === 'X-CSRFToken') {
                                        csrfToken = value;
                                    }
                                }
                            };
                            parentAjaxSettings.beforeSend(mockXHR, {});
                        }
                    } catch (e) {
                        console.log('Cannot access parent Ajax settings:', e);
                    }
                }
                
                if (csrfToken) {
                    receivedCSRFToken = csrfToken;
                    setupAjaxWithCSRF(csrfToken);
                    console.log('CSRF token found via fallback methods:', csrfToken.substring(0, 10) + '...');
                } else {
                    console.warn('No CSRF token found via any method');
                }
            }
            
            // 初始化UIBootgrid
            $("#grid-forward").UIBootgrid({
                search:'/api/mosdns/plugins/searchForward',
                get:'/api/mosdns/plugins/getForward/',
                set:'/api/mosdns/plugins/setForward/',
                add:'/api/mosdns/plugins/addForward/',
                del:'/api/mosdns/plugins/delForward/',
                toggle:'/api/mosdns/plugins/toggleForward/'
            });
        }, 1500); // 增加延迟时间，确保postMessage有足够时间传递
        
        // 向父窗口请求CSRF令牌（主动请求）
        setTimeout(function() {
            if (window.parent && !receivedCSRFToken) {
                try {
                    window.parent.postMessage({
                        type: 'request_csrf_token'
                    }, '*');
                    console.log('Requested CSRF token from parent window');
                } catch (e) {
                    console.log('Failed to request CSRF token from parent:', e);
                }
            }
        }, 500);
    });
</script>

<div class="content-box">
    <div class="row">
        <div class="col-sm-12">
            <h3>{{ lang._('Forward Settings')}}</h3>
            <hr/>
        </div>
    </div>
</div>

{# include dialogs #}
{{ partial("layout_partials/base_dialog",['fields':formDialogForward,'id':'DialogForward','label':lang._('Edit Forward Entry')])}}

<div class="content-box">
    <div class="row">
        <div class="col-md-12">
            <table id="grid-forward" class="table table-condensed table-hover table-striped" data-editDialog="DialogForward">
                <thead>
                <tr>
                    <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                    <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                    <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                    <th data-column-id="concurrent" data-type="string">{{ lang._('Concurrent') }}</th>
                    <th data-column-id="upstreams" data-type="string">{{ lang._('Upstreams') }}</th>
                    <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
                <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                    </td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogForward,'id':'DialogForward','label':lang._('Edit Forward Entry')]) }}

</body>
</html>