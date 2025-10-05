<script>
    var csrfTokenReceived = false;
    var gridInitialized = false;

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
            console.log("CSRF token set for Hosts page:", csrfToken);
            csrfTokenReceived = true;
            initializeGridIfReady();
        }
    }

    function initializeGridIfReady() {
        if (csrfTokenReceived && !gridInitialized) {
            gridInitialized = true;
            // Initialize the grid and other UI components
            $("#grid-hosts").UIBootgrid({
                search:'/api/mosdns/hosts/searchHosts/',
                get:'/api/mosdns/hosts/getHosts/',
                set:'/api/mosdns/hosts/setHosts/',
                add:'/api/mosdns/hosts/addHosts/',
                del:'/api/mosdns/hosts/delHosts/',
                toggle:'/api/mosdns/hosts/toggleHosts/'
            });
            
            mapDataToFormUI(data_get_map).done(function(data){
                formatTokenizersUI();
                $('.selectpicker').selectpicker('refresh');
            });
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
        var data_get_map = {'frm_DialogEditHosts':'/api/mosdns/hosts/getHosts/'};
        
        // Add a fallback timeout in case CSRF token is not received
        setTimeout(function() {
            if (!csrfTokenReceived) {
                console.warn("CSRF token not received, initializing grid anyway");
                csrfTokenReceived = true;
                initializeGridIfReady();
            }
        }, 1000);
        
        initializeGridIfReady();
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize hosts grid
        $("#grid-hosts").UIBootgrid(
            {
                'search':'/api/mosdns/hosts/searchHosts',
                'get':'/api/mosdns/hosts/getHosts/',
                'set':'/api/mosdns/hosts/setHosts/',
                'add':'/api/mosdns/hosts/addHosts/',
                'del':'/api/mosdns/hosts/delHosts/',
                'toggle':'/api/mosdns/hosts/toggleHosts/'
            }
        );

        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-list"></i> {{ lang._('Hosts Configuration') }}</h2>
        <p>{{ lang._('Configure custom DNS hosts for MosDNS.') }}</p>
        <hr />
        
        <div class="row">
            <div class="col-md-7">
                <div class="bootgrid-header container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="actionBar">
                                <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-plus"></span></button>
                                <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <table id="grid-hosts" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEditHosts">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                            <th data-column-id="files" data-type="string">{{ lang._('Files') }}</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div class="col-md-5">
                <div class="hidden">
                    <div class="col-md-12">
                        <div class="pull-right">
                            <select id="act_service" class="selectpicker" data-style="btn-primary" data-width="200px">
                                <option value="reload">{{ lang._('Reload service') }}</option>
                                <option value="restart">{{ lang._('Restart service') }}</option>
                            </select>
                            <br/><br/>
                            <button id="act_service_update" type="button" class="btn btn-primary">{{ lang._('Apply') }}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-12">
            <hr/>
            <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b> <i id="reconfigureAct_progress"></i></button>
            <br/><br/>
        </div>
    </div>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogEditHosts,'id':'DialogEditHosts','label':lang._('Edit Hosts')])}}