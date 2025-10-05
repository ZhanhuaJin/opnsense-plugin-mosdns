{#
 # Copyright (c) 2023 Deciso B.V.
 # All rights reserved.
 #
 # Redistribution and use in source and binary forms, with or without modification,
 # are permitted provided that the following conditions are met:
 #
 # 1. Redistributions of source code must retain the above copyright notice,
 #    this list of conditions and the following disclaimer.
 #
 # 2. Redistributions in binary form must reproduce the above copyright notice,
 #    this list of conditions and the following disclaimer in the documentation
 #    and/or other materials provided with the distribution.
 #
 # THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 # AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 # AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 # OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 # SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 # INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 # CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 # ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 # POSSIBILITY OF SUCH DAMAGE.
 #}

<script>
    $( document ).ready(function() {

        var data_get_map = {'frm_GeneralSettings':"/api/mosdns/general/get"};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        updateServiceControlUI('mosdns');











        // Removed global reconfigureAct button initialization
    });

    // Global functions for form operations
    function showForwardForm(uuid) {
        console.log('showForwardForm called with uuid:', uuid);
        
        // Hide the grid and show the form
        $('#forwardGridContainer').hide();
        $('#forwardFormContainer').show();
        
        // Load form content
        if (uuid) {
            // Edit mode - load existing data
            console.log('Loading existing data for uuid:', uuid);
            loadForwardFormData(uuid);
        } else {
            // Add mode - clear form
            console.log('Clearing form for new entry');
            clearForwardForm();
        }
    }
    
    function hideForwardForm() {
        console.log('hideForwardForm called');
        
        // Hide the form and show the grid
        $('#forwardFormContainer').hide();
        $('#forwardGridContainer').show();
    }
    
    function saveForwardForm() {
        console.log('saveForwardForm called');
        
        // Collect form data
        var formData = {};
        $('#forwardFormContent input, #forwardFormContent select').each(function() {
            var name = $(this).attr('name');
            var value = $(this).val();
            if (name) {
                formData[name] = value;
            }
        });
        
        // Save via API
        $.ajax({
            url: '/api/mosdns/plugins/setForward/',
            type: 'POST',
            data: formData,
            success: function(data) {
                if (data && data.result === 'saved') {
                    hideForwardForm();
                    $("#{{ formGridForward['table_id'] }}").bootgrid('reload');
                } else {
                    alert('{{ lang._("Failed to save forward configuration") }}');
                }
            },
            error: function() {
                alert('{{ lang._("Failed to save forward configuration") }}');
            }
        });
    }
    
    function loadForwardFormData(uuid) {
        // Load form fields dynamically
        $.ajax({
            url: '/api/mosdns/plugins/getForward/' + uuid,
            type: 'GET',
            success: function(data) {
                if (data && data.forward) {
                    var formHtml = generateForwardFormHtml(data.forward);
                    $('#forwardFormContent').html(formHtml);
                }
            },
            error: function() {
                console.error('Failed to load forward data');
            }
        });
    }
    
    function clearForwardForm() {
        var formHtml = generateForwardFormHtml({});
        $('#forwardFormContent').html(formHtml);
    }
    
    function generateForwardFormHtml(data) {
        data = data || {};
        
        var html = '<div class="row">' +
            '<div class="col-md-6">' +
                '<div class="form-group">' +
                    '<label for="forward_enabled">{{ lang._("Enabled") }}</label>' +
                    '<select id="forward_enabled" name="enabled" class="form-control">' +
                        '<option value="1"' + (data.enabled === '1' ? ' selected' : '') + '>{{ lang._("Yes") }}</option>' +
                        '<option value="0"' + (data.enabled === '0' ? ' selected' : '') + '>{{ lang._("No") }}</option>' +
                    '</select>' +
                '</div>' +
            '</div>' +
            '<div class="col-md-6">' +
                '<div class="form-group">' +
                    '<label for="forward_tag">{{ lang._("Tag") }}</label>' +
                    '<input type="text" id="forward_tag" name="tag" class="form-control" value="' + (data.tag || '') + '">' +
                '</div>' +
            '</div>' +
        '</div>' +
        '<div class="row">' +
            '<div class="col-md-6">' +
                '<div class="form-group">' +
                    '<label for="forward_concurrent">{{ lang._("Concurrent") }}</label>' +
                    '<input type="number" id="forward_concurrent" name="concurrent" class="form-control" value="' + (data.concurrent || '1') + '">' +
                '</div>' +
            '</div>' +
            '<div class="col-md-6">' +
                '<div class="form-group">' +
                    '<label for="forward_upstream">{{ lang._("Upstream") }}</label>' +
                    '<input type="text" id="forward_upstream" name="upstream" class="form-control" value="' + (data.upstream || '') + '">' +
                '</div>' +
            '</div>' +
        '</div>';
        
        return html;
    }
</script>

<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#forward">{{ lang._('Forward') }}</a></li>
    <li><a data-toggle="tab" href="#redirect">{{ lang._('Redirect') }}</a></li>
    <li><a data-toggle="tab" href="#rules">{{ lang._('Rules') }}</a></li>
    <li><a data-toggle="tab" href="#hosts">{{ lang._('Hosts') }}</a></li>
    <li><a data-toggle="tab" href="#ipset">{{ lang._('IPSet') }}</a></li>
    <li><a data-toggle="tab" href="#sequence">{{ lang._('Sequence') }}</a></li>
    <li><a data-toggle="tab" href="#fallback">{{ lang._('Fallback') }}</a></li>
    <li><a data-toggle="tab" href="#servers">{{ lang._('Servers') }}</a></li>
    <li><a data-toggle="tab" href="#cache">{{ lang._('Cache') }}</a></li>
</ul>

<div class="tab-content content-box col-xs-12 __mb" id="mainContent">
    <div id="forward" class="tab-pane fade in active">
        {{ partial("OPNsense/MosDNS/plugins_forward") }}
    </div>
    <div id="redirect" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_redirect") }}
    </div>
    <div id="rules" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_rules") }}
    </div>
    <div id="hosts" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_hosts") }}
    </div>
    <div id="ipset" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_ipset") }}
    </div>
    <div id="sequence" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_sequence") }}
    </div>
    <div id="fallback" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_fallback") }}
    </div>
    <div id="servers" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_servers") }}
    </div>
    <div id="cache" class="tab-pane fade">
        {{ partial("OPNsense/MosDNS/plugins_cache") }}
    </div>
</div>

<!-- Dialog definitions for each tab -->


{{ partial("layout_partials/base_dialog",['fields':formDialogEditForward,'id':'dialog_forward','label':lang._('Edit Forward')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditRedirect,'id':'dialog_redirect','label':lang._('Edit Redirect')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditRules,'id':'dialog_rules','label':lang._('Edit Rules')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditHosts,'id':'dialog_hosts','label':lang._('Edit Hosts')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditIPSet,'id':'dialog_ipset','label':lang._('Edit IPSet')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditSequence,'id':'dialog_sequence','label':lang._('Edit Sequence')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditFallback,'id':'dialog_fallback','label':lang._('Edit Fallback')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditServers,'id':'dialog_servers','label':lang._('Edit Servers')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditCache,'id':'dialog_cache','label':lang._('Edit Cache')])}}