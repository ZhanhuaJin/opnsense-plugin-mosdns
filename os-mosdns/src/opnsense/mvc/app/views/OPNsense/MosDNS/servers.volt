<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_servers':'/api/mosdns/servers/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/servers/set", formid='frm_servers',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    updateServiceControlUI('mosdns');
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                });
            });
        });

        // update history on tab state and implement navigation
        if(window.location.hash != "") {
            $('a[href="' + window.location.hash + '"]').click()
        }
        $('.nav-tabs a').on('shown.bs.tab', function (e) {
            history.pushState(null, null, e.target.hash);
        });

        updateServiceControlUI('mosdns');
    });
</script>

<script>
$(document).ready(function() {
    // Initialize servers plugins grid
    $("#grid-servers-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/servers/searchItem',
            'get':'/api/mosdns/servers/getItem/',
            'set':'/api/mosdns/servers/setItem/',
            'add':'/api/mosdns/servers/addItem/',
            'del':'/api/mosdns/servers/delItem/',
            'toggle':'/api/mosdns/servers/toggleItem/'
        }
    );

    // Add new servers plugin
    $("#addServersPlugin").click(function(){
        $("#DialogServers").modal('show');
    });

    // Save servers plugin
    $("#saveServersPlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/servers/addItem', 'frm_DialogServers', function(){
            $("#DialogServers").modal('hide');
            $("#grid-servers-plugins").bootgrid('reload');
        });
    });

    // Server type change handler
    $("#servers_server_type").change(function(){
        var serverType = $(this).val();
        if(serverType === 'udp_server' || serverType === 'tcp_server') {
            $("#listen-group").show();
            $("#entry-group").hide();
        } else {
            $("#listen-group").hide();
            $("#entry-group").show();
        }
    });
});
</script>

<!-- Servers Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addServersPlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Server Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-servers-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogServers">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="server_type" data-type="string">{{ lang._('Server Type') }}</th>
                            <th data-column-id="entry" data-type="string">{{ lang._('Entry') }}</th>
                            <th data-column-id="listen" data-type="string">{{ lang._('Listen') }}</th>
                            <th data-column-id="timeout" data-type="string">{{ lang._('Timeout') }}</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Servers Plugin Dialog -->
<div class="modal fade" id="DialogServers" tabindex="-1" role="dialog" aria-labelledby="DialogServersLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogServersLabel">{{ lang._('Server Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogServers">
                    <div class="form-group">
                        <label for="servers_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="servers_enabled" name="servers[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="servers_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="servers_tag" name="servers[tag]" placeholder="{{ lang._('Enter server tag') }}">
                    </div>
                    <div class="form-group">
                        <label for="servers_server_type">{{ lang._('Server Type') }}</label>
                        <select class="form-control selectpicker" id="servers_server_type" name="servers[server_type]">
                            <option value="udp_server">{{ lang._('UDP Server') }}</option>
                            <option value="tcp_server">{{ lang._('TCP Server') }}</option>
                            <option value="http_server">{{ lang._('HTTP Server') }}</option>
                            <option value="https_server">{{ lang._('HTTPS Server') }}</option>
                        </select>
                    </div>
                    <div class="form-group" id="entry-group">
                        <label for="servers_entry">{{ lang._('Entry Point') }}</label>
                        <input type="text" class="form-control" id="servers_entry" name="servers[entry]" placeholder="{{ lang._('Entry sequence tag (e.g., main_sequence)') }}">
                        <small class="form-text text-muted">{{ lang._('Tag of the sequence to handle requests') }}</small>
                    </div>
                    <div class="form-group" id="listen-group">
                        <label for="servers_listen">{{ lang._('Listen Address') }}</label>
                        <input type="text" class="form-control" id="servers_listen" name="servers[listen]" placeholder="0.0.0.0:53">
                        <small class="form-text text-muted">{{ lang._('IP address and port to listen on') }}</small>
                    </div>
                    <div class="form-group">
                        <label for="servers_timeout">{{ lang._('Timeout (seconds)') }}</label>
                        <input type="number" class="form-control" id="servers_timeout" name="servers[timeout]" placeholder="5" min="1" max="300">
                        <small class="form-text text-muted">{{ lang._('Request timeout in seconds') }}</small>
                    </div>
                    <div class="alert alert-info">
                        <strong>{{ lang._('Note:') }}</strong> {{ lang._('UDP/TCP servers listen for DNS queries, while HTTP/HTTPS servers provide web interfaces or APIs.') }}
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveServersPlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>