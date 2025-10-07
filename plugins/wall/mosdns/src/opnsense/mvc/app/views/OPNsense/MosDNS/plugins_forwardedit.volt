{#

OPNsense® is Copyright © 2024 by Deciso B.V.
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

<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_forward_settings':"/api/mosdns/plugins/getForward/"};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize upstream grid
        $("#grid-upstreams").UIBootgrid({
            search:'/api/mosdns/plugins_forward_edit/searchUpstream/',
            get:'/api/mosdns/plugins_forward_edit/getUpstream/',
            set:'/api/mosdns/plugins_forward_edit/setUpstream/',
            add:'/api/mosdns/plugins_forward_edit/addUpstream/',
            del:'/api/mosdns/plugins_forward_edit/delUpstream/',
            toggle:'/api/mosdns/plugins_forward_edit/toggleUpstream/'
        });

        // Save button
        $("#saveForwardAct").SimpleActionButton({
            onPreAction: function() {
                const result = saveFormToEndpoint(url="/api/mosdns/plugins/setForward", formid='frm_forward_settings', callback_ok=function(){
                    $("#saveForwardAct_progress").addClass("fa fa-spinner fa-pulse");
                    ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                        $("#saveForwardAct_progress").removeClass("fa fa-spinner fa-pulse");
                        if (status != "success" || data['status'] != 'ok') {
                            BootstrapDialog.show({
                                type: BootstrapDialog.TYPE_WARNING,
                                title: "{{ lang._('Error reconfiguring MosDNS') }}",
                                message: data['status'],
                                draggable: true
                            });
                        }
                    });
                });
                return result;
            }
        });

        // Cancel button - go back to forward list
        $("#cancelForwardAct").click(function() {
            window.location.href = '/ui/mosdns/plugins#forward';
        });
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    {{ partial("layout_partials/base_form",['fields':formForwardSettings,'id':'frm_forward_settings'])}}
    
    <div class="col-md-12">
        <hr/>
        <h4>{{ lang._('Upstream Servers') }}</h4>
        <table id="grid-upstreams" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialog_forwardupstream" data-store-selection="true" data-store-selection-key="upstream.selection">
            <thead>
            <tr>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="addr" data-type="string">{{ lang._('Address') }}</th>
                <th data-column-id="trusted" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Trusted') }}</th>
                <th data-column-id="detour" data-type="string">{{ lang._('Detour') }}</th>
                <th data-column-id="domain" data-type="string">{{ lang._('Domain') }}</th>
                <th data-column-id="enable_http3" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('HTTP/3') }}</th>
                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
            <tr>
                <td></td>
                <td>
                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-plus"></span></button>
                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                </td>
            </tr>
            </tfoot>
        </table>
    </div>

    <div class="col-md-12">
        <hr/>
        <div class="pull-right">
            <button class="btn btn-primary" id="saveForwardAct" type="button">
                <i class="fa fa-save"></i> <b>{{ lang._('Save') }}</b> <i id="saveForwardAct_progress"></i>
            </button>
            <button class="btn btn-default" id="cancelForwardAct" type="button">
                <i class="fa fa-times"></i> <b>{{ lang._('Cancel') }}</b>
            </button>
        </div>
        <div class="clearfix"></div>
        <br/>
    </div>
</div>

<!-- Dialog for Upstream -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditUpstream,'id':'dialog_forwardupstream','label':lang._('Edit Upstream Server')])}}