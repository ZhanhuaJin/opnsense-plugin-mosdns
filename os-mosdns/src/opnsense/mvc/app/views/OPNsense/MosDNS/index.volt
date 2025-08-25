<script>
    $( document ).ready(function() {
        var data_get_map = {
            'frm_GeneralSettings':'/api/mosdns/general/get'
        };
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        updateServiceControlUI('mosdns');

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/general/set", formid='frm_GeneralSettings',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    updateServiceControlUI('mosdns');
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                });
            });
        });

        $("#configtestAct").click(function(){
            $("#configtestAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/configtest", sendData={}, callback=function(data,status) {
                $("#configtestAct_progress").removeClass("fa fa-spinner fa-pulse");
                if (status == "success") {
                    if (data['result'].indexOf('ERROR') > -1) {
                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_WARNING,
                            title: "{{ lang._('Configuration test') }}",
                            message: data['result'],
                            draggable: true
                        });
                    } else {
                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_INFO,
                            title: "{{ lang._('Configuration test') }}",
                            message: "{{ lang._('Configuration OK') }}",
                            draggable: true
                        });
                    }
                }
            });
        });
    });
</script>

<div class="content-box">
    <div class="col-md-12">
        {{ partial("layout_partials/base_form",['fields':generalForm,'id':'frm_GeneralSettings']) }}
        <div class="col-md-12">
            <hr/>
            <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress" class=""></i></button>
            <button class="btn btn-info" id="configtestAct" type="button"><b>{{ lang._('Test Configuration') }}</b> <i id="configtestAct_progress" class=""></i></button>
        </div>
        
        <!-- Service Controls -->
        <div class="col-md-12">
            <hr/>
            <h4>{{ lang._('Service Controls') }}</h4>
            <button class="btn btn-success" id="startServiceAct" type="button"><b>{{ lang._('Start Service') }}</b></button>
            <button class="btn btn-warning" id="stopServiceAct" type="button"><b>{{ lang._('Stop Service') }}</b></button>
            <button class="btn btn-info" id="restartServiceAct" type="button"><b>{{ lang._('Restart Service') }}</b></button>
            <button class="btn btn-default" id="reconfigureServiceAct" type="button"><b>{{ lang._('Reconfigure Service') }}</b></button>
        </div>
    </div>

</div>