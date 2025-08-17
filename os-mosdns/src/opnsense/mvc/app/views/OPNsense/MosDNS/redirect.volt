<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_redirect':'/api/mosdns/redirect/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/redirect/set", formid='frm_redirect',callback_ok=function(){
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
    // Initialize redirect plugins grid
    $("#grid-redirect-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/redirect/searchItem',
            'get':'/api/mosdns/redirect/getItem/',
            'set':'/api/mosdns/redirect/setItem/',
            'add':'/api/mosdns/redirect/addItem/',
            'del':'/api/mosdns/redirect/delItem/',
            'toggle':'/api/mosdns/redirect/toggleItem/'
        }
    );

    // Add new redirect plugin
    $("#addRedirectPlugin").click(function(){
        $("#DialogRedirect").modal('show');
    });

    // Save redirect plugin
    $("#saveRedirectPlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/redirect/addItem', 'frm_DialogRedirect', function(){
            $("#DialogRedirect").modal('hide');
            $("#grid-redirect-plugins").bootgrid('reload');
        });
    });

    // Add redirect rule
    $("#addRule").click(function(){
        var ruleHtml = '<div class="rule-item form-group">' +
            '<div class="row">' +
            '<div class="col-md-5">' +
            '<input type="text" class="form-control" name="redirect[from][]" placeholder="Source domain (e.g., www.example.com)">' +
            '</div>' +
            '<div class="col-md-5">' +
            '<input type="text" class="form-control" name="redirect[to][]" placeholder="Target domain (e.g., cdn.example.com)">' +
            '</div>' +
            '<div class="col-md-2">' +
            '<button type="button" class="btn btn-danger remove-rule"><i class="fa fa-trash"></i></button>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#rules-container").append(ruleHtml);
    });

    // Remove redirect rule
    $(document).on('click', '.remove-rule', function(){
        $(this).closest('.rule-item').remove();
    });
});
</script>

<!-- Redirect Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addRedirectPlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Redirect Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-redirect-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogRedirect">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="rules" data-type="string">{{ lang._('Redirect Rules') }}</th>
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

<!-- Redirect Plugin Dialog -->
<div class="modal fade" id="DialogRedirect" tabindex="-1" role="dialog" aria-labelledby="DialogRedirectLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogRedirectLabel">{{ lang._('Redirect Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogRedirect">
                    <div class="form-group">
                        <label for="redirect_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="redirect_enabled" name="redirect[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="redirect_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="redirect_tag" name="redirect[tag]" placeholder="{{ lang._('Enter redirect tag') }}">
                    </div>
                    <div class="form-group">
                        <label>{{ lang._('Redirect Rules') }}</label>
                        <div id="rules-container">
                            <div class="rule-item form-group">
                                <div class="row">
                                    <div class="col-md-5">
                                        <input type="text" class="form-control" name="redirect[from][]" placeholder="Source domain (e.g., www.example.com)">
                                    </div>
                                    <div class="col-md-5">
                                        <input type="text" class="form-control" name="redirect[to][]" placeholder="Target domain (e.g., cdn.example.com)">
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-danger remove-rule"><i class="fa fa-trash"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success" id="addRule">
                            <i class="fa fa-plus"></i> {{ lang._('Add Rule') }}
                        </button>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveRedirectPlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>