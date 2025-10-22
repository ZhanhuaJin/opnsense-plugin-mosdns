<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

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

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('Save functionality will be implemented when forms are configured.');
        });

        // Import YAML configuration
        $("#importYamlAct").click(function(){
            var yamlContent = $("#yamlEditor").val().trim();
            if (yamlContent === '') {
                alert('{{ lang._("Please enter YAML configuration content.") }}');
                return;
            }
            
            $("#importYamlAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/general/importYaml", sendData={'yaml': yamlContent}, callback=function(data,status) {
                $("#importYamlAct_progress").removeClass("fa fa-spinner fa-pulse");
                if (data && data.result === 'ok') {
                    alert('{{ lang._("YAML configuration imported successfully!") }}');
                    // Optionally clear the editor
                    $("#yamlEditor").val('');
                } else {
                    var errorMsg = data && data.message ? data.message : '{{ lang._("Failed to import YAML configuration.") }}';
                    alert('{{ lang._("Error: ") }}' + errorMsg);
                }
            });
        });

        // Clear YAML editor
        $("#clearYamlAct").click(function(){
            if (confirm('{{ lang._("Are you sure you want to clear the YAML editor?") }}')) {
                $("#yamlEditor").val('');
            }
        });

        // Update service status
        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2>{{ lang._('MosDNS General Settings') }}</h2>
        <p>{{ lang._('Configure general settings for MosDNS service.') }}</p>
        <p><em>{{ lang._('Configuration forms will be available in a future update.') }}</em></p>
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

<!-- YAML Configuration Import Section -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h3>{{ lang._('YAML Configuration Import') }}</h3>
        <p>{{ lang._('Import MosDNS configuration from YAML format. This will update the system configuration.') }}</p>
        <hr />
        
        <div class="row">
            <div class="col-md-12">
                <div class="form-group">
                    <label for="yamlEditor">{{ lang._('YAML Configuration') }}</label>
                    <textarea id="yamlEditor" class="form-control" rows="20" placeholder="{{ lang._('Paste your config.yaml content here...') }}" style="font-family: monospace; font-size: 12px;"></textarea>
                    <small class="help-block">{{ lang._('Enter the complete MosDNS YAML configuration that you want to import into the system.') }}</small>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="btn-group" role="group">
                    <button class="btn btn-primary" id="importYamlAct" type="button">
                        <i class="fa fa-upload"></i> <b>{{ lang._('Import YAML') }}</b> 
                        <i id="importYamlAct_progress"></i>
                    </button>
                    <button class="btn btn-default" id="clearYamlAct" type="button">
                        <i class="fa fa-eraser"></i> <b>{{ lang._('Clear') }}</b>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>