<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_AdvancedSettings':'/api/mosdns/settings/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Save configuration
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/settings/set", formid='frm_AdvancedSettings',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                    updateServiceControlUI('mosdns');
                });
            });
        });
    });
</script>

<!-- Advanced Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="table-responsive">
        <div class="col-sm-12">
            <h2>{{ lang._('Advanced Configuration') }}</h2>
            {{ partial("layout_partials/base_form",['fields':advancedForm,'id':'frm_AdvancedSettings']) }}
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
            </div>
        </div>
    </div>
</div>