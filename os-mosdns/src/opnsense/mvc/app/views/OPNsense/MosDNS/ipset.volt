<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_ipset':'/api/mosdns/ipset/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/ipset/set", formid='frm_ipset',callback_ok=function(){
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
    // Initialize ipset plugins grid
    $("#grid-ipset-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/ipset/searchItem',
            'get':'/api/mosdns/ipset/getItem/',
            'set':'/api/mosdns/ipset/setItem/',
            'add':'/api/mosdns/ipset/addItem/',
            'del':'/api/mosdns/ipset/delItem/',
            'toggle':'/api/mosdns/ipset/toggleItem/'
        }
    );

    // Add new ipset plugin
    $("#addIpsetPlugin").click(function(){
        $("#DialogIpset").modal('show');
    });

    // Save ipset plugin
    $("#saveIpsetPlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/ipset/addItem', 'frm_DialogIpset', function(){
            $("#DialogIpset").modal('hide');
            $("#grid-ipset-plugins").bootgrid('reload');
        });
    });

    // Add IP list file
    $("#addIpFile").click(function(){
        var fileHtml = '<div class="file-item form-group">' +
            '<div class="row">' +
            '<div class="col-md-10">' +
            '<input type="text" class="form-control" name="ipset[files][]" placeholder="/usr/local/etc/mosdns/china_ip_list.txt">' +
            '</div>' +
            '<div class="col-md-2">' +
            '<button type="button" class="btn btn-danger remove-file"><i class="fa fa-trash"></i></button>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#files-container").append(fileHtml);
    });

    // Remove IP list file
    $(document).on('click', '.remove-file', function(){
        $(this).closest('.file-item').remove();
    });
});
</script>

<!-- IPSet Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addIpsetPlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add IP Set Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-ipset-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogIpset">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="files" data-type="string">{{ lang._('IP List Files') }}</th>
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

<!-- IPSet Plugin Dialog -->
<div class="modal fade" id="DialogIpset" tabindex="-1" role="dialog" aria-labelledby="DialogIpsetLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogIpsetLabel">{{ lang._('IP Set Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogIpset">
                    <div class="form-group">
                        <label for="ipset_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="ipset_enabled" name="ipset[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="ipset_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="ipset_tag" name="ipset[tag]" placeholder="{{ lang._('Enter IP set tag') }}">
                    </div>
                    <div class="form-group">
                        <label>{{ lang._('IP List Files') }}</label>
                        <div id="files-container">
                            <div class="file-item form-group">
                                <div class="row">
                                    <div class="col-md-10">
                                        <input type="text" class="form-control" name="ipset[files][]" placeholder="/usr/local/etc/mosdns/china_ip_list.txt">
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-danger remove-file"><i class="fa fa-trash"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success" id="addIpFile">
                            <i class="fa fa-plus"></i> {{ lang._('Add File') }}
                        </button>
                    </div>
                    <div class="alert alert-info">
                        <strong>{{ lang._('Note:') }}</strong> {{ lang._('IP list files should contain IP addresses or CIDR blocks, one per line.') }}
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveIpsetPlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>