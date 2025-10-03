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
            <iframe src="/ui/mosdns/plugins/cache" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="forward" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/forward" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="redirect" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/redirect" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="hosts" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/hosts" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="ipset" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/ipset" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="sequence" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/sequence" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="fallback" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/fallback" width="100%" height="800px" frameborder="0"></iframe>
        </div>
        <div id="servers" class="tab-pane fade">
            <iframe src="/ui/mosdns/plugins/servers" width="100%" height="800px" frameborder="0"></iframe>
        </div>
    </div>
</div>