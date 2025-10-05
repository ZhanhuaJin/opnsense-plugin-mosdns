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
            console.log("CSRF token set for Sequence page:", csrfToken);
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
        var data_get_map = {'frm_DialogEditSequence':'/api/mosdns/sequence/getSequence/'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize sequence grid
        $("#grid-sequence").UIBootgrid(
            {
                'search':'/api/mosdns/sequence/searchSequence',
                'get':'/api/mosdns/sequence/getSequence/',
                'set':'/api/mosdns/sequence/setSequence/',
                'add':'/api/mosdns/sequence/addSequence/',
                'del':'/api/mosdns/sequence/delSequence/',
                'toggle':'/api/mosdns/sequence/toggleSequence/'
            }
        );

        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-sort-numeric-asc"></i> {{ lang._('Sequence Configuration') }}</h2>
        <p>{{ lang._('Configure execution sequence for MosDNS plugins.') }}</p>
        <hr />
        
        <div class="row">
            <div class="col-md-7">
                <div class="table-responsive">
                    <table id="grid-sequence" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEditSequence">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                                <th data-column-id="type" data-type="string">{{ lang._('Type') }}</th>
                                <th data-column-id="args" data-type="string">{{ lang._('Args') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
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

{{ partial("layout_partials/base_dialog",['fields':formDialogEditSequence,'id':'DialogEditSequence','label':lang._('Edit Sequence')])}}