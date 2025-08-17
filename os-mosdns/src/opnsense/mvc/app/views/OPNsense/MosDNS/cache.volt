<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_cache':'/api/mosdns/cache/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/cache/set", formid='frm_cache',callback_ok=function(){
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

<div class="tab-content content-box tab-content">
    <div id="cache" class="tab-pane fade in active">
        <div class="content-box" style="padding-bottom: 1.5em;">
            {{ partial("layout_partials/base_form",['fields':cacheForm,'id':'frm_cache'])}} 
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Initialize cache plugins grid
    $("#grid-cache-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/cache/searchItem',
            'get':'/api/mosdns/cache/getItem/',
            'set':'/api/mosdns/cache/setItem/',
            'add':'/api/mosdns/cache/addItem/',
            'del':'/api/mosdns/cache/delItem/',
            'toggle':'/api/mosdns/cache/toggleItem/'
        }
    );

    // Add new cache plugin
    $("#addCachePlugin").click(function(){
        $("#DialogCache").modal('show');
    });

    // Save cache plugin
    $("#saveCachePlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/cache/addItem', 'frm_DialogCache', function(){
            $("#DialogCache").modal('hide');
            $("#grid-cache-plugins").bootgrid('reload');
        });
    });
});
</script>

<!-- Cache Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addCachePlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Cache Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-cache-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogCache">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="size" data-type="string">{{ lang._('Cache Size') }}</th>
                            <th data-column-id="lazy_cache_ttl" data-type="string">{{ lang._('Lazy Cache TTL') }}</th>
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

<!-- Cache Plugin Dialog -->
<div class="modal fade" id="DialogCache" tabindex="-1" role="dialog" aria-labelledby="DialogCacheLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogCacheLabel">{{ lang._('Cache Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogCache">
                    <div class="form-group">
                        <label for="cache_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="cache_enabled" name="cache[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="cache_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="cache_tag" name="cache[tag]" placeholder="{{ lang._('Enter cache tag') }}">
                    </div>
                    <div class="form-group">
                        <label for="cache_size">{{ lang._('Cache Size') }}</label>
                        <input type="number" class="form-control" id="cache_size" name="cache[size]" placeholder="10240" min="1024" max="1048576">
                    </div>
                    <div class="form-group">
                        <label for="cache_lazy_cache_ttl">{{ lang._('Lazy Cache TTL (seconds)') }}</label>
                        <input type="number" class="form-control" id="cache_lazy_cache_ttl" name="cache[lazy_cache_ttl]" placeholder="86400" min="60" max="604800">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveCachePlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>