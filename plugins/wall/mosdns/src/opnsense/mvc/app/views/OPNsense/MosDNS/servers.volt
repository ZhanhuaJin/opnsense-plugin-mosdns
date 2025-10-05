<script>
    // CSRF Token Setup for iframe
    function setupAjaxWithCSRF(csrfToken) {
        if (csrfToken) {
            $.ajaxSetup({
                beforeSend: function(xhr, settings) {
                    if (!/^(GET|HEAD|OPTIONS|TRACE)$/i.test(settings.type) && !this.crossDomain) {
                        xhr.setRequestHeader("X-CSRFToken", csrfToken);
                    }
                }
            });
            console.log("CSRF token set for Servers page:", csrfToken);
        }
    }

    // Listen for CSRF token from parent window
    window.addEventListener("message", function(event) {
        if (event.data && (event.data.type === "csrf-token" || event.data.type === "csrf_token")) {
            var csrfToken = event.data.token || event.data.csrf;
            if (csrfToken) {
                setupAjaxWithCSRF(csrfToken);
            }
        }
    }, false);

    // Try to get CSRF token from parent window if available
    if (window.parent && window.parent !== window) {
        try {
            var parentMeta = window.parent.document.querySelector('meta[name="csrf-token"]');
            if (parentMeta) {
                setupAjaxWithCSRF(parentMeta.getAttribute('content'));
            } else {
                var parentInput = window.parent.document.querySelector('input[name="csrf"]');
                if (parentInput) {
                    setupAjaxWithCSRF(parentInput.value);
                } else if (window.parent.csrfToken) {
                    setupAjaxWithCSRF(window.parent.csrfToken);
                }
            }
        } catch(e) {
            console.log("Could not access parent window for CSRF token");
        }
        
        // Request CSRF token from parent
        window.parent.postMessage({type: 'request_csrf_token'}, '*');
    }

    $( document ).ready(function() {
        var data_get_map = {'frm_DialogEditMosDNSServers':'/api/mosdns/servers/getServers/'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize grid
        $("#grid-servers").UIBootgrid(
            {
                'search':'/api/mosdns/servers/searchServers',
                'get':'/api/mosdns/servers/getServers/',
                'set':'/api/mosdns/servers/setServers/',
                'add':'/api/mosdns/servers/addServers/',
                'del':'/api/mosdns/servers/delServers/',
                'toggle':'/api/mosdns/servers/toggleServers/'
            }
        );

        updateServiceControlUI('mosdns');
    });
</script>

<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#servers">{{ lang._('Servers') }}</a></li>
</ul>

<div class="tab-content content-box tab-content">
    <div id="servers" class="tab-pane fade in active">
        <div class="content-box" style="padding-bottom: 1.5em;">
            <div class="row">
                <div class="col-md-12">
                    <h2>{{ lang._('Servers Configuration') }}</h2>
                    <p>{{ lang._('Configure DNS servers for MosDNS.') }}</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <table id="grid-servers" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEditMosDNSServers">
                        <thead>
                            <tr>
                                <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="entry" data-type="string">{{ lang._('Entry') }}</th>
                                <th data-column-id="listen" data-type="string">{{ lang._('Listen') }}</th>
                                <th data-column-id="udp_or_tcp" data-type="string">{{ lang._('UDP or TCP') }}</th>
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
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b> <i id="reconfigureAct_progress"></i></button>
                <br /><br />
            </div>
        </div>
    </div>
</div>

{{ partial("layout_partials/base_dialog",['fields':file_get_contents('/usr/local/opnsense/mvc/app/views/OPNsense/MosDNS/dialogServers.xml'),'id':'DialogEditMosDNSServers','label':lang._('Edit Servers')])}}