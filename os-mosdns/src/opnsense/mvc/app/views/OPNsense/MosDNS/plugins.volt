<script>
    $(document).ready(function() {
        var data_get_map = {'frm_PluginsSettings':'/api/mosdns/plugins/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Save configuration
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/plugins/set", formid='frm_PluginsSettings',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                    updateServiceControlUI('mosdns');
                });
            });
        });
    });
</script>

<!-- Plugins Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="table-responsive">
        <div class="col-sm-12">
            <h2>{{ lang._('Plugins Configuration') }}</h2>
            {{ partial("layout_partials/base_form",['fields':pluginsForm,'id':'frm_PluginsSettings']) }}
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
            </div>
        </div>
    </div>
</div>