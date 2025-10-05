<script>
$(document).ready(function() {
    // Update history on tab state and implement navigation
    if(window.location.hash != "") {
        $('a[href="' + window.location.hash + '"]').click()
    }
    $('.nav-tabs a').on('shown.bs.tab', function (e) {
        history.pushState(null, null, e.target.hash);
    });

    updateServiceControlUI('mosdns');
    
    // CSRF令牌传递机制 - 修正版本
    function sendCSRFTokenToIframes() {
        var csrfToken = '';
        
        // 方法1: 从$.ajaxSetup的beforeSend配置中提取CSRF令牌
        try {
            // 获取当前的ajaxSetup配置
            var ajaxSettings = $.ajaxSettings;
            if (ajaxSettings && ajaxSettings.beforeSend) {
                // 创建一个模拟的XMLHttpRequest对象来捕获令牌
                var mockXHR = {
                    setRequestHeader: function(name, value) {
                        if (name === 'X-CSRFToken') {
                            csrfToken = value;
                        }
                    }
                };
                // 调用beforeSend函数来获取令牌
                ajaxSettings.beforeSend.call(null, mockXHR, {});
                console.log('CSRF token extracted from $.ajaxSetup:', csrfToken);
            }
        } catch (e) {
            console.log('Failed to extract CSRF token from $.ajaxSetup:', e);
        }
        
        // 方法2: 从meta标签获取（备用方案）
        if (!csrfToken) {
            var metaToken = $('meta[name="csrf-token"]').attr('content');
            if (metaToken) {
                csrfToken = metaToken;
                console.log('CSRF token found in meta tag:', csrfToken);
            }
        }
        
        // 方法3: 从隐藏的input字段获取（备用方案）
        if (!csrfToken) {
            var inputToken = $('input[name="_token"], input[name="csrf_token"], input[name="csrf"]').val();
            if (inputToken) {
                csrfToken = inputToken;
                console.log('CSRF token found in input field:', csrfToken);
            }
        }
        
        // 方法4: 从全局JavaScript变量获取（备用方案）
        if (!csrfToken) {
            if (typeof window.csrfToken !== 'undefined') {
                csrfToken = window.csrfToken;
                console.log('CSRF token found in global variable:', csrfToken);
            } else if (typeof window._token !== 'undefined') {
                csrfToken = window._token;
                console.log('CSRF token found in global _token variable:', csrfToken);
            }
        }
        
        // 方法5: 尝试从页面脚本中提取（最后的备用方案）
        if (!csrfToken) {
            try {
                var scripts = $('script');
                scripts.each(function() {
                    var scriptContent = $(this).html();
                    if (scriptContent) {
                        // 查找可能的CSRF令牌模式
                        var tokenMatch = scriptContent.match(/['"]([\w+\/=]{20,})['"]/);
                        if (tokenMatch && tokenMatch[1]) {
                            csrfToken = tokenMatch[1];
                            console.log('CSRF token extracted from script:', csrfToken);
                            return false; // 跳出each循环
                        }
                    }
                });
            } catch (e) {
                console.log('Failed to extract CSRF token from scripts:', e);
            }
        }
        
        if (csrfToken) {
            // 向所有iframe发送CSRF令牌
            $('iframe').each(function() {
                try {
                    this.contentWindow.postMessage({
                        type: 'csrf-token',
                        token: csrfToken
                    }, '*');
                    console.log('Sent CSRF token to iframe:', this.src);
                } catch (e) {
                    console.log('Failed to send message to iframe:', e);
                }
            });
        } else {
            console.warn('No CSRF token found to send to iframes');
        }
    }
    
    // 页面加载完成后发送CSRF令牌
    setTimeout(sendCSRFTokenToIframes, 1000);
    
    // 监听iframe加载完成事件，重新发送CSRF令牌
    $('iframe').on('load', function() {
        setTimeout(sendCSRFTokenToIframes, 500);
    });
    
    // 标签页切换时也发送CSRF令牌
    $('.nav-tabs a').on('shown.bs.tab', function (e) {
        setTimeout(sendCSRFTokenToIframes, 500);
    });
});
</script>

<div class="tab-content content-box tab-content">
    <ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
        <li class="active"><a data-toggle="tab" href="#cache">{{ lang._('Cache') }}</a></li>
        <li><a data-toggle="tab" href="#forward">{{ lang._('Forward') }}</a></li>
        <li><a data-toggle="tab" href="#redirect">{{ lang._('Redirect') }}</a></li>
        <li><a data-toggle="tab" href="#hosts">{{ lang._('Hosts') }}</a></li>
        <li><a data-toggle="tab" href="#ipset">{{ lang._('IP Set') }}</a></li>
        <li><a data-toggle="tab" href="#sequence">{{ lang._('Sequence') }}</a></li>
        <li><a data-toggle="tab" href="#fallback">{{ lang._('Fallback') }}</a></li>
        <li><a data-toggle="tab" href="#servers">{{ lang._('Servers') }}</a></li>
    </ul>

    <div class="tab-content content-box tab-content">
        <div id="cache" class="tab-pane fade in active">
            <iframe src="/ui/mosdns/plugins/cacheBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="forward" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/forwardBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="redirect" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/redirectBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="hosts" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/hostsBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="ipset" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/ipsetBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="sequence" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/sequenceBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="fallback" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/fallbackBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
        <div id="servers" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/serversBare" width="100%" height="600" frameborder="0"></iframe>
        </div>
    </div>
</div>