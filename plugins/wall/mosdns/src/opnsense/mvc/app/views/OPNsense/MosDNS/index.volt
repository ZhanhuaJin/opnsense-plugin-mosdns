{#

OPNsense® is Copyright © 2014 – 2024 by Deciso B.V.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

#}

<link rel="stylesheet" type="text/css" href="{{ cache_safe('/ui/css/jquery.bootgrid.css') }}" />
<script type="text/javascript" src="{{ cache_safe('/ui/js/jquery.bootgrid.js') }}"></script>
<script type="text/javascript" src="{{ cache_safe('/ui/js/opnsense_bootgrid_plugin.js') }}"></script>

<!-- General Settings - Simple form without tabs -->
<div class="content-box" style="padding-bottom: 1.5em;">
    {{ partial("layout_partials/base_form",['fields':generalForm,'id':'frm_GeneralSettings'])}}
    <div class="col-md-12">
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
        <button class="btn btn-info" id="configtestAct" type="button"><b>{{ lang._('Test Configuration') }}</b> <i id="configtestAct_progress"></i></button>
    </div>
</div>

<!-- YAML Configuration Import Section -->
<div class="content-box" style="padding-bottom: 1.5em;">
    {{ partial("layout_partials/base_form",['fields':[],'id':'frm_YamlImport'])}}
    <div class="col-md-12">
        <h3>{{ lang._('YAML Configuration Import') }}</h3>
        <p>{{ lang._('Import MosDNS configuration from YAML format. This will update the system configuration.') }}</p>
        <hr />
        
        <div class="form-group" style="margin-left: 0; margin-right: 0;">
            <label for="yamlEditor">{{ lang._('YAML Configuration') }}</label>
            <textarea id="yamlEditor" rows="30" placeholder="{{ lang._('Paste your config.yaml content here...') }}" style="font-family: monospace; font-size: 12px; min-height: 600px; resize: vertical; width: 100% !important; max-width: none !important; box-sizing: border-box; margin: 0; padding: 10px; border: 1px solid #ccc; border-radius: 4px; background-color: #fff;"></textarea>
            <small class="help-block">{{ lang._('Enter the complete MosDNS YAML configuration that you want to import into the system.') }}</small>
        </div>
        
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

<script>
$(document).ready(function() {
    var data_get_map = {'frm_GeneralSettings':"/api/mosdns/general/get"};
    mapDataToFormUI(data_get_map).done(function(data){
        formatTokenizersUI();
        $('.selectpicker').selectpicker('refresh');
    });

    updateServiceControlUI('mosdns');

    // link save button to API set action
    $("#saveAct").click(function(){
        saveFormToEndpoint(url="/api/mosdns/general/set", formid='frm_GeneralSettings',callback_ok=function(){
            $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall("/api/mosdns/service/reconfigure", {}, function(data,status) {
                updateServiceControlUI('mosdns');
                $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
            });
        });
    });

    // link test button to API test action
    $("#configtestAct").click(function(){
        $("#configtestAct_progress").addClass("fa fa-spinner fa-pulse");
        ajaxCall("/api/mosdns/service/configtest", {}, function(data,status) {
            $("#configtestAct_progress").removeClass("fa fa-spinner fa-pulse");
            if (status == "success") {
                if (data['result'] == 'ok') {
                    BootstrapDialog.alert({
                        type: BootstrapDialog.TYPE_SUCCESS,
                        title: "{{ lang._('Configuration Test') }}",
                        message: "{{ lang._('Configuration test successful') }}"
                    });
                } else {
                    BootstrapDialog.alert({
                        type: BootstrapDialog.TYPE_DANGER,
                        title: "{{ lang._('Configuration Test') }}",
                        message: data['result']
                    });
                }
            }
        });
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
                // Reload the form data
                mapDataToFormUI(data_get_map).done(function(data){
                    formatTokenizersUI();
                    $('.selectpicker').selectpicker('refresh');
                });
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
});
</script>