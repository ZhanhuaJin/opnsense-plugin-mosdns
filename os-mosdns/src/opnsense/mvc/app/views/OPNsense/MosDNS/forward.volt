<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_forward':'/api/mosdns/forward/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/forward/set", formid='frm_forward',callback_ok=function(){
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
    // Initialize forward plugins grid
    $("#grid-forward-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/forward/searchItem',
            'get':'/api/mosdns/forward/getItem/',
            'set':'/api/mosdns/forward/setItem/',
            'add':'/api/mosdns/forward/addItem/',
            'del':'/api/mosdns/forward/delItem/',
            'toggle':'/api/mosdns/forward/toggleItem/'
        }
    );

    // Add new forward plugin
    $("#addForwardPlugin").click(function(){
        $("#DialogForward").modal('show');
    });

    // Save forward plugin
    $("#saveForwardPlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/forward/addItem', 'frm_DialogForward', function(){
            $("#DialogForward").modal('hide');
            $("#grid-forward-plugins").bootgrid('reload');
        });
    });

    // Add upstream server
    $("#addUpstream").click(function(){
        var upstreamHtml = '<div class="upstream-item form-group">' +
            '<div class="row">' +
            '<div class="col-md-5">' +
            '<input type="text" class="form-control" name="forward[upstreams][]" placeholder="udp://8.8.8.8:53">' +
            '</div>' +
            '<div class="col-md-5">' +
            '<input type="text" class="form-control" name="forward[dial_addr][]" placeholder="Dial Address (optional)">' +
            '</div>' +
            '<div class="col-md-2">' +
            '<button type="button" class="btn btn-danger remove-upstream"><i class="fa fa-trash"></i></button>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#upstreams-container").append(upstreamHtml);
    });

    // Remove upstream server
    $(document).on('click', '.remove-upstream', function(){
        $(this).closest('.upstream-item').remove();
    });
});
</script>

<!-- Forward Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addForwardPlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Forward Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-forward-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogForward">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="concurrent" data-type="string">{{ lang._('Concurrent') }}</th>
                            <th data-column-id="upstreams" data-type="string">{{ lang._('Upstreams') }}</th>
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

<!-- Forward Plugin Dialog -->
<div class="modal fade" id="DialogForward" tabindex="-1" role="dialog" aria-labelledby="DialogForwardLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogForwardLabel">{{ lang._('Forward Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogForward">
                    <div class="form-group">
                        <label for="forward_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="forward_enabled" name="forward[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="forward_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="forward_tag" name="forward[tag]" placeholder="{{ lang._('Enter forward tag') }}">
                    </div>
                    <div class="form-group">
                        <label for="forward_concurrent">{{ lang._('Concurrent Queries') }}</label>
                        <input type="number" class="form-control" id="forward_concurrent" name="forward[concurrent]" placeholder="1" min="1" max="10">
                    </div>
                    <div class="form-group">
                        <label>{{ lang._('Upstream Servers') }}</label>
                        <div id="upstreams-container">
                            <div class="upstream-item form-group">
                                <div class="row">
                                    <div class="col-md-5">
                                        <input type="text" class="form-control" name="forward[upstreams][]" placeholder="udp://8.8.8.8:53">
                                    </div>
                                    <div class="col-md-5">
                                        <input type="text" class="form-control" name="forward[dial_addr][]" placeholder="Dial Address (optional)">
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-danger remove-upstream"><i class="fa fa-trash"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success" id="addUpstream">
                            <i class="fa fa-plus"></i> {{ lang._('Add Upstream') }}
                        </button>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveForwardPlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>