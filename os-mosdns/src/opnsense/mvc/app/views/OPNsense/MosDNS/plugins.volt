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

        // Forward Grid
        $("#{{ formGridForward['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchForward',
            get: '/api/mosdns/plugins/getForward/',
            set: '/api/mosdns/plugins/setForward/',
            add: '/api/mosdns/plugins/addForward/',
            del: '/api/mosdns/plugins/delForward/',
            toggle: '/api/mosdns/plugins/toggleForward/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        });

        // Redirect Grid
        $("#{{ formGridRedirect['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchRedirect',
            get: '/api/mosdns/plugins/getRedirect/',
            set: '/api/mosdns/plugins/setRedirect/',
            add: '/api/mosdns/plugins/addRedirect/',
            del: '/api/mosdns/plugins/delRedirect/',
            toggle: '/api/mosdns/plugins/toggleRedirect/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        });

        // Rules Grid
        $("#{{ formGridRules['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchRules',
            get: '/api/mosdns/plugins/getRules/',
            set: '/api/mosdns/plugins/setRules/',
            add: '/api/mosdns/plugins/addRules/',
            del: '/api/mosdns/plugins/delRules/',
            toggle: '/api/mosdns/plugins/toggleRules/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        });

        // Hosts Grid
        $("#{{ formGridHosts['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchHosts',
            get: '/api/mosdns/plugins/getHosts/',
            set: '/api/mosdns/plugins/setHosts/',
            add: '/api/mosdns/plugins/addHosts/',
            del: '/api/mosdns/plugins/delHosts/',
            toggle: '/api/mosdns/plugins/toggleHosts/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        });

        // IPSet Grid
        console.log('Initializing IPSet Grid with ID:', "{{ formGridIPSet['table_id'] }}");
        console.log('IPSet Grid search endpoint:', '/api/mosdns/plugins/searchIPSet');
        $("#{{ formGridIPSet['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchIPSet',
            get: '/api/mosdns/plugins/getIPSet/',
            set: '/api/mosdns/plugins/setIPSet/',
            add: '/api/mosdns/plugins/addIPSet/',
            del: '/api/mosdns/plugins/delIPSet/',
            toggle: '/api/mosdns/plugins/toggleIPSet/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        }).on('loaded.rs.jquery.bootgrid', function() {
            console.log('IPSet Grid loaded successfully');
        }).on('load.rs.jquery.bootgrid', function() {
            console.log('IPSet Grid loading data...');
        });

        // Sequence Grid
        $("#{{ formGridSequence['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchSequence',
            get: '/api/mosdns/plugins/getSequence/',
            set: '/api/mosdns/plugins/setSequence/',
            add: '/api/mosdns/plugins/addSequence/',
            del: '/api/mosdns/plugins/delSequence/',
            toggle: '/api/mosdns/plugins/toggleSequence/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        });

        // Custom handler for Sequence add button to create new tab instead of dialog
        $('#{{ formGridSequence["table_id"] }}').on('click', '[data-action="add"]', function(e) {
            e.preventDefault();
            e.stopPropagation();
            createSequenceTab('new');
            return false;
        });

        // Fallback Grid
        console.log('Initializing Fallback Grid with ID:', "{{ formGridFallback['table_id'] }}");
        console.log('Fallback Grid search endpoint:', '/api/mosdns/plugins/searchFallback');
        $("#{{ formGridFallback['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchFallback',
            get: '/api/mosdns/plugins/getFallback/',
            set: '/api/mosdns/plugins/setFallback/',
            add: '/api/mosdns/plugins/addFallback/',
            del: '/api/mosdns/plugins/delFallback/',
            toggle: '/api/mosdns/plugins/toggleFallback/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        }).on('loaded.rs.jquery.bootgrid', function() {
            console.log('Fallback Grid loaded successfully');
        }).on('load.rs.jquery.bootgrid', function() {
            console.log('Fallback Grid loading data...');
        });

        // Servers Grid
        $("#{{ formGridServers['table_id'] }}").UIBootgrid({
            search: '/api/mosdns/plugins/searchServers',
            get: '/api/mosdns/plugins/getServers/',
            set: '/api/mosdns/plugins/setServers/',
            add: '/api/mosdns/plugins/addServers/',
            del: '/api/mosdns/plugins/delServers/',
            toggle: '/api/mosdns/plugins/toggleServers/',
            options: {
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: [7, 14, 20, 50, 100, -1]
            }
        });

        // Cache Grid - removed as Cache is now a form
        // $("#{{ formGridCache['table_id'] }}").UIBootgrid({
        //     search: '/api/mosdns/plugins/searchCache',
        //     get: '/api/mosdns/plugins/getCache/',
        //     set: '/api/mosdns/plugins/setCache/',
        //     add: '/api/mosdns/plugins/addCache/',
        //     del: '/api/mosdns/plugins/delCache/',
        //     toggle: '/api/mosdns/plugins/toggleCache/'
        // });

        // Sequence tab management functions
        function createSequenceTab(uuid) {
            var tabId = uuid === 'new' ? 'sequence-tab-' + Date.now() : 'sequence-tab-' + uuid;
            var tabTitle = uuid === 'new' ? '{{ lang._("New Sequence") }}' : '{{ lang._("Edit Sequence") }}';
            
            // Create tab
            var tabHtml = '<li role="presentation" id="' + tabId + '-tab">' +
                '<a href="#' + tabId + '" data-toggle="tab">' + tabTitle + 
                ' <button type="button" class="close" onclick="closeSequenceTab(\'' + tabId + '\')" style="margin-left: 10px;">&times;</button>' +
                '</a></li>';
            
            $('#maintabs').append(tabHtml);
            
            // Create tab content
            var content = createSequenceTabContent(tabId, uuid);
            $('#mainContent').append(content);
            
            // Activate the new tab
            $('#' + tabId + '-tab a').tab('show');
            
            return tabId;
        }
        
        function createSequenceTabContent(tabId, uuid) {
            var content = $('<div class="tab-pane" id="' + tabId + '">' +
                '<div class="content-box">' +
                    '<div class="content-box-main">' +
                        '<div class="table-responsive">' +
                            '<div class="col-xs-12">' +
                                '<div class="pull-right">' +
                                    '<button class="btn btn-primary" onclick="addRule(\'' + tabId + '\')">{{ lang._("Add Rule") }}</button>' +
                                '</div>' +
                            '</div>' +
                            '<div class="clearfix"></div>' +
                            '<div id="' + tabId + '-rules" style="margin-top: 20px;"></div>' +
                        '</div>' +
                        '<div class="col-xs-12">' +
                            '<button type="button" class="btn btn-primary" onclick="saveSequence(\'' + tabId + '\', \'' + uuid + '\')">{{ lang._("Save") }}</button>' +
                            '<button type="button" class="btn btn-default" onclick="closeSequenceTab(\'' + tabId + '\')">{{ lang._("Cancel") }}</button>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>');
            
            return content;
        }
        
        function closeSequenceTab(tabId) {
            $('#' + tabId + '-tab').remove();
            $('#' + tabId).remove();
            
            // Activate the first available tab
            $('#maintabs li:first a').tab('show');
        }
        
        function addRule(tabId) {
            var ruleHtml = '<div class="rule-item" style="margin-bottom: 10px; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">' +
                '<div class="row">' +
                    '<div class="col-md-4">' +
                        '<select class="form-control rule-type">' +
                            '<option value="exec">{{ lang._("Execute") }}</option>' +
                            '<option value="if">{{ lang._("If Condition") }}</option>' +
                            '<option value="goto">{{ lang._("Goto") }}</option>' +
                        '</select>' +
                    '</div>' +
                    '<div class="col-md-6">' +
                        '<input type="text" class="form-control rule-value" placeholder="{{ lang._("Rule value") }}">' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<button type="button" class="btn btn-danger btn-sm" onclick="$(this).closest(\'.rule-item\').remove()">{{ lang._("Remove") }}</button>' +
                    '</div>' +
                '</div>' +
            '</div>';
            
            $('#' + tabId + '-rules').append(ruleHtml);
        }
        
        function saveSequence(tabId, uuid) {
            var rules = [];
            $('#' + tabId + '-rules .rule-item').each(function() {
                var type = $(this).find('.rule-type').val();
                var value = $(this).find('.rule-value').val();
                if (type && value) {
                    rules.push({type: type, value: value});
                }
            });
            
            // Here you would normally save the sequence via API
            console.log('Saving sequence:', {uuid: uuid, rules: rules});
            
            // Close the tab after saving
            closeSequenceTab(tabId);
            
            // Reload the sequence grid
            $("#{{ formGridSequence['table_id'] }}").bootgrid('reload');
        }

        $("#reconfigureAct").SimpleActionButton();
    });
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
        <table id="{{ formGridForward['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridForward['edit_dialog_id'] }}" data-editAlert="{{ formGridForward['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridForward['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="redirect" class="tab-pane fade">
        <table id="{{ formGridRedirect['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridRedirect['edit_dialog_id'] }}" data-editAlert="{{ formGridRedirect['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridRedirect['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="rules" class="tab-pane fade">
        <table id="{{ formGridRules['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridRules['edit_dialog_id'] }}" data-editAlert="{{ formGridRules['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridRules['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="hosts" class="tab-pane fade">
        <table id="{{ formGridHosts['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridHosts['edit_dialog_id'] }}" data-editAlert="{{ formGridHosts['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridHosts['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="ipset" class="tab-pane fade">
        <table id="{{ formGridIPSet['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridIPSet['edit_dialog_id'] }}" data-editAlert="{{ formGridIPSet['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridIPSet['fields'] %}
                    {% if field['column-id'] == 'sets' %}
                    <th data-column-id="sets" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ lang._('Sets') }}</th>
                    {% else %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endif %}
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="sequence" class="tab-pane fade">
        <table id="{{ formGridSequence['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridSequence['edit_dialog_id'] }}" data-editAlert="{{ formGridSequence['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridSequence['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="fallback" class="tab-pane fade">
        <table id="{{ formGridFallback['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridFallback['edit_dialog_id'] }}" data-editAlert="{{ formGridFallback['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridFallback['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="servers" class="tab-pane fade">
        <table id="{{ formGridServers['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridServers['edit_dialog_id'] }}" data-editAlert="{{ formGridServers['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridServers['fields'] %}
                    <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['visible'] %}data-visible="false"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="cache" class="tab-pane fade">
        <div class="content-box">
            <div class="content-box-main">
                <h3><i class="fa fa-database"></i> {{ lang._('Cache Configuration') }}</h3>
                <p>{{ lang._('Configure DNS cache settings for MosDNS.') }}</p>
                
                {{ partial("layout_partials/base_form", ['fields': formDialogEditCache, 'id': 'frm_cache_settings']) }}
                
                <div class="col-md-12">
                    <hr/>
                    <button class="btn btn-primary" id="saveCacheAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveCacheAct_progress"></i></button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Dialog definitions for each tab -->
<!-- Apply button section -->
<div class="col-md-12">
    <hr/>
    <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b> <i id="reconfigureAct_progress"></i></button>
    <br/><br/>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogEditForward,'id':'dialogForward','label':lang._('Edit Forward')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditRedirect,'id':'dialogRedirect','label':lang._('Edit Redirect')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditRules,'id':'dialogRules','label':lang._('Edit Rules')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditHosts,'id':'dialogHosts','label':lang._('Edit Hosts')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditIPSet,'id':'dialogIPSet','label':lang._('Edit IPSet')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditSequence,'id':'dialogSequence','label':lang._('Edit Sequence')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditFallback,'id':'dialogFallback','label':lang._('Edit Fallback')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditServers,'id':'dialogServers','label':lang._('Edit Servers')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditCache,'id':'dialogCache','label':lang._('Edit Cache')])}}