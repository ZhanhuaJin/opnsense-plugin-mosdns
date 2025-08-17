<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_GeneralSettings':'/api/mosdns/settings/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Service control buttons
        $("#reconfigureAct").click(function(){
            $("#reconfigureAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                $("#reconfigureAct_progress").removeClass("fa fa-spinner fa-pulse");
                updateServiceControlUI('mosdns');
            });
        });

        $("#startAct").click(function(){
            $("#startAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/start", sendData={}, callback=function(data,status) {
                $("#startAct_progress").removeClass("fa fa-spinner fa-pulse");
                updateServiceControlUI('mosdns');
            });
        });

        $("#stopAct").click(function(){
            $("#stopAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/stop", sendData={}, callback=function(data,status) {
                $("#stopAct_progress").removeClass("fa fa-spinner fa-pulse");
                updateServiceControlUI('mosdns');
            });
        });

        $("#restartAct").click(function(){
            $("#restartAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/restart", sendData={}, callback=function(data,status) {
                $("#restartAct_progress").removeClass("fa fa-spinner fa-pulse");
                updateServiceControlUI('mosdns');
            });
        });

        // Save configuration
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/settings/set", formid='frm_GeneralSettings',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                    updateServiceControlUI('mosdns');
                });
            });
        });

        // Update service status
        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    {{ partial("layout_partials/base_form",['fields':generalForm,'id':'frm_GeneralSettings']) }}
    <div class="col-md-12">
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="table-responsive">
        <div class="col-sm-12">
            <div class="row">
                <div class="col-xs-12">
                    <div class="pull-right">
                        <select id="service_status_container" class="selectpicker" data-width="200px">
                            <option data-content="<span class='fa fa-play-circle-o text-success'></span> {{ lang._('Running') }}" value="running">{{ lang._('Running') }}</option>
                            <option data-content="<span class='fa fa-stop-circle-o text-danger'></span> {{ lang._('Stopped') }}" value="stopped">{{ lang._('Stopped') }}</option>
                        </select>
                        <br/><br/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <div class="btn-group" role="group">
                        <button class="btn btn-default" id="startAct" type="button"><b>{{ lang._('Start') }}</b> <i id="startAct_progress"></i></button>
                        <button class="btn btn-default" id="stopAct" type="button"><b>{{ lang._('Stop') }}</b> <i id="stopAct_progress"></i></button>
                        <button class="btn btn-default" id="restartAct" type="button"><b>{{ lang._('Restart') }}</b> <i id="restartAct_progress"></i></button>
                        <button class="btn btn-default" id="reconfigureAct" type="button"><b>{{ lang._('Reconfigure') }}</b> <i id="reconfigureAct_progress"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>