<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_hosts':'/api/mosdns/hosts/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/hosts/set", formid='frm_hosts',callback_ok=function(){
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
    // Initialize hosts plugins grid
    $("#grid-hosts-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/hosts/searchItem',
            'get':'/api/mosdns/hosts/getItem/',
            'set':'/api/mosdns/hosts/setItem/',
            'add':'/api/mosdns/hosts/addItem/',
            'del':'/api/mosdns/hosts/delItem/',
            'toggle':'/api/mosdns/hosts/toggleItem/'
        }
    );

    // Add new hosts plugin
    $("#addHostsPlugin").click(function(){
        $("#DialogHosts").modal('show');
    });

    // Save hosts plugin
    $("#saveHostsPlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/hosts/addItem', 'frm_DialogHosts', function(){
            $("#DialogHosts").modal('hide');
            $("#grid-hosts-plugins").bootgrid('reload');
        });
    });

    // Add hosts file
    $("#addHostsFile").click(function(){
        var fileHtml = '<div class="file-item form-group">' +
            '<div class="row">' +
            '<div class="col-md-10">' +
            '<input type="text" class="form-control" name="hosts[files][]" placeholder="/usr/local/etc/mosdns/hosts">' +
            '</div>' +
            '<div class="col-md-2">' +
            '<button type="button" class="btn btn-danger remove-file"><i class="fa fa-trash"></i></button>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#files-container").append(fileHtml);
    });

    // Remove hosts file
    $(document).on('click', '.remove-file', function(){
        $(this).closest('.file-item').remove();
    });
});
</script>

<!-- Hosts Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addHostsPlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Hosts Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-hosts-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogHosts">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="files" data-type="string">{{ lang._('Hosts Files') }}</th>
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

<!-- Hosts Plugin Dialog -->
<div class="modal fade" id="DialogHosts" tabindex="-1" role="dialog" aria-labelledby="DialogHostsLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogHostsLabel">{{ lang._('Hosts Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogHosts">
                    <div class="form-group">
                        <label for="hosts_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="hosts_enabled" name="hosts[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="hosts_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="hosts_tag" name="hosts[tag]" placeholder="{{ lang._('Enter hosts tag') }}">
                    </div>
                    <div class="form-group">
                        <label>{{ lang._('Hosts Files') }}</label>
                        <div id="files-container">
                            <div class="file-item form-group">
                                <div class="row">
                                    <div class="col-md-10">
                                        <input type="text" class="form-control" name="hosts[files][]" placeholder="/usr/local/etc/mosdns/hosts">
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-danger remove-file"><i class="fa fa-trash"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success" id="addHostsFile">
                            <i class="fa fa-plus"></i> {{ lang._('Add File') }}
                        </button>
                    </div>
                    <div class="alert alert-info">
                        <strong>{{ lang._('Note:') }}</strong> {{ lang._('Hosts files should contain domain-to-IP mappings in standard hosts file format.') }}
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveHostsPlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>