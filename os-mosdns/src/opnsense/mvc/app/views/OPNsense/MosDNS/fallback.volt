<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_fallback':'/api/mosdns/fallback/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/fallback/set", formid='frm_fallback',callback_ok=function(){
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
    // Initialize fallback plugins grid
    $("#grid-fallback-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/fallback/searchItem',
            'get':'/api/mosdns/fallback/getItem/',
            'set':'/api/mosdns/fallback/setItem/',
            'add':'/api/mosdns/fallback/addItem/',
            'del':'/api/mosdns/fallback/delItem/',
            'toggle':'/api/mosdns/fallback/toggleItem/'
        }
    );

    // Add new fallback plugin
    $("#addFallbackPlugin").click(function(){
        $("#DialogFallback").modal('show');
    });

    // Save fallback plugin
    $("#saveFallbackPlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/fallback/addItem', 'frm_DialogFallback', function(){
            $("#DialogFallback").modal('hide');
            $("#grid-fallback-plugins").bootgrid('reload');
        });
    });
});
</script>

<!-- Fallback Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addFallbackPlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Fallback Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-fallback-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogFallback">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="primary" data-type="string">{{ lang._('Primary') }}</th>
                            <th data-column-id="secondary" data-type="string">{{ lang._('Secondary') }}</th>
                            <th data-column-id="threshold" data-type="string">{{ lang._('Threshold (ms)') }}</th>
                            <th data-column-id="always_standby" data-type="string">{{ lang._('Always Standby') }}</th>
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

<!-- Fallback Plugin Dialog -->
<div class="modal fade" id="DialogFallback" tabindex="-1" role="dialog" aria-labelledby="DialogFallbackLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogFallbackLabel">{{ lang._('Fallback Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogFallback">
                    <div class="form-group">
                        <label for="fallback_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="fallback_enabled" name="fallback[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="fallback_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="fallback_tag" name="fallback[tag]" placeholder="{{ lang._('Enter fallback tag') }}">
                    </div>
                    <div class="form-group">
                        <label for="fallback_primary">{{ lang._('Primary Server') }}</label>
                        <input type="text" class="form-control" id="fallback_primary" name="fallback[primary]" placeholder="{{ lang._('Primary server tag (e.g., local_sequence)') }}">
                        <small class="form-text text-muted">{{ lang._('Tag of the primary DNS server or sequence') }}</small>
                    </div>
                    <div class="form-group">
                        <label for="fallback_secondary">{{ lang._('Secondary Server') }}</label>
                        <input type="text" class="form-control" id="fallback_secondary" name="fallback[secondary]" placeholder="{{ lang._('Secondary server tag (e.g., remote_sequence)') }}">
                        <small class="form-text text-muted">{{ lang._('Tag of the secondary DNS server or sequence') }}</small>
                    </div>
                    <div class="form-group">
                        <label for="fallback_threshold">{{ lang._('Threshold (ms)') }}</label>
                        <input type="number" class="form-control" id="fallback_threshold" name="fallback[threshold]" placeholder="500" min="1" max="10000">
                        <small class="form-text text-muted">{{ lang._('Response time threshold in milliseconds to trigger fallback') }}</small>
                    </div>
                    <div class="form-group">
                        <label for="fallback_always_standby">{{ lang._('Always Standby') }}</label>
                        <input type="checkbox" id="fallback_always_standby" name="fallback[always_standby]" value="1">
                        <small class="form-text text-muted">{{ lang._('Keep secondary server always ready for faster fallback') }}</small>
                    </div>
                    <div class="alert alert-info">
                        <strong>{{ lang._('Note:') }}</strong> {{ lang._('Fallback plugin switches to secondary server when primary server response time exceeds the threshold or fails to respond.') }}
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveFallbackPlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>