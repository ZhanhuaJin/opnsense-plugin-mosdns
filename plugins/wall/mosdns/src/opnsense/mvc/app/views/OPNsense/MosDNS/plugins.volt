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
        var forwardGridId = "{{ formGridForward['table_id'] }}";
        console.log('Forward Grid ID:', forwardGridId);
        
        if (forwardGridId && $("#" + forwardGridId).length > 0) {
            console.log('Forward Grid element found, initializing...');
            
            $("#" + forwardGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function() {
                console.log('Forward Grid loaded successfully');
                
                // Handle add button click for Forward Grid
                var addButton = $("#" + forwardGridId).find("button[data-action='add']");
                console.log('Found add buttons:', addButton.length);
                
                addButton.off('click').on('click', function(e) {
                    console.log('Add button clicked');
                    e.preventDefault();
                    showForwardForm();
                });
            }).on("appended.rs.jquery.bootgrid", function() {
                console.log('Forward Grid appended event');
                
                // Re-bind add button after grid updates
                var addButton = $("#" + forwardGridId).find("button[data-action='add']");
                console.log('Re-binding add buttons:', addButton.length);
                
                addButton.off('click').on('click', function(e) {
                    console.log('Add button clicked (re-bound)');
                    e.preventDefault();
                    showForwardForm();
                });
            });
        } else {
            console.error('Forward Grid element not found:', forwardGridId);
        }

        // Redirect Grid
        var redirectGridId = "{{ formGridRedirect['table_id'] }}";
        if (redirectGridId && $("#" + redirectGridId).length > 0) {
            $("#" + redirectGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function() {
                // Grid loaded successfully
            });
        } else {
            console.error('Redirect Grid element not found:', redirectGridId);
        }

        // Rules Grid (now part of sequences)
        var rulesGridId = "{{ formGridRules['table_id'] }}";
        if (rulesGridId && $("#" + rulesGridId).length > 0) {
            $("#" + rulesGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function() {
                // Grid loaded successfully
            });
        } else {
            console.error('Rules Grid element not found:', rulesGridId);
        }

        // Hosts Grid
        var hostsGridId = "{{ formGridHosts['table_id'] }}";
        if (hostsGridId && $("#" + hostsGridId).length > 0) {
            $("#" + hostsGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function() {
                // Grid loaded successfully
            });
        } else {
            console.error('Hosts Grid element not found:', hostsGridId);
        }

        // IPSet Grid
        var ipsetGridId = "{{ formGridIPSet['table_id'] }}";
        if (ipsetGridId && $("#" + ipsetGridId).length > 0) {
            $("#" + ipsetGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on('loaded.rs.jquery.bootgrid', function() {
                // Grid loaded successfully
            });
        } else {
            console.error('IPSet Grid element not found:', ipsetGridId);
        }

        // Sequence Grid
        var sequenceGridId = "{{ formGridSequence['table_id'] }}";
        if (sequenceGridId && $("#" + sequenceGridId).length > 0) {
            $("#" + sequenceGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function() {
                // Grid loaded successfully
            });
        } else {
            console.error('Sequence Grid element not found:', sequenceGridId);
        }

        // Custom handler for Sequence add button to create new tab instead of dialog
        $('#{{ formGridSequence["table_id"] }}').on('click', '[data-action="add"]', function(e) {
            e.preventDefault();
            e.stopPropagation();
            createSequenceTab('new');
            return false;
        });

        // Initialize standard dialogs for all grids except Sequence
        $().ready(function() {
            // Initialize dialogs
            $("#dialogForward").modal({show: false});
            $("#dialogRedirect").modal({show: false});
            $("#dialogRules").modal({show: false});
            $("#dialogHosts").modal({show: false});
            $("#dialogIPSet").modal({show: false});
            $("#dialogFallback").modal({show: false});
            $("#dialogServers").modal({show: false});
            
            // Bind grid events after initialization
            setTimeout(function() {
                // Forward Grid events - Override default behavior
                $('#{{ formGridForward["table_id"] }}').find('[data-action="add"]').off('click');
                
                // Redirect Grid events
                $('#{{ formGridRedirect["table_id"] }}').find('[data-action="add"]').off('click').on('click', function(e) {
                    e.preventDefault();
                    $("#dialogRedirect").modal('show');
                });
                
                // Rules Grid events
                $('#{{ formGridRules["table_id"] }}').find('[data-action="add"]').off('click').on('click', function(e) {
                    e.preventDefault();
                    $("#dialogRules").modal('show');
                });
                
                // Hosts Grid events
                $('#{{ formGridHosts["table_id"] }}').find('[data-action="add"]').off('click').on('click', function(e) {
                    e.preventDefault();
                    $("#dialogHosts").modal('show');
                });
                
                // IPSet Grid events
                $('#{{ formGridIPSet["table_id"] }}').find('[data-action="add"]').off('click').on('click', function(e) {
                    e.preventDefault();
                    $("#dialogIPSet").modal('show');
                });
                
                // Fallback Grid events
                $('#{{ formGridFallback["table_id"] }}').find('[data-action="add"]').off('click').on('click', function(e) {
                    e.preventDefault();
                    $("#dialogFallback").modal('show');
                });
                
                // Servers Grid events
                $('#{{ formGridServers["table_id"] }}').find('[data-action="add"]').off('click').on('click', function(e) {
                    e.preventDefault();
                    $("#dialogServers").modal('show');
                });
            }, 1000);
        });

        // Fallback Grid
        var fallbackGridId = "{{ formGridFallback['table_id'] }}";
        if (fallbackGridId && $("#" + fallbackGridId).length > 0) {
            $("#" + fallbackGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on('loaded.rs.jquery.bootgrid', function() {
                // Grid loaded successfully
            });
        } else {
            console.error('Fallback Grid element not found:', fallbackGridId);
        }

        // Servers Grid
        var serversGridId = "{{ formGridServers['table_id'] }}";
        if (serversGridId && $("#" + serversGridId).length > 0) {
            $("#" + serversGridId).UIBootgrid({
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
                    rowCount: [7, 14, 20, 50, 100, -1],
                    formatters: {
                        "uuid": function(column, row) {
                            return "";  // Hide ID column
                        }
                    }
                }
            }).on("loaded.rs.jquery.bootgrid", function() {
                // Grid loaded successfully
            });
        } else {
            console.error('Servers Grid element not found:', serversGridId);
        }

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

    // Global functions for form operations
    function showForwardForm(uuid) {
        console.log('showForwardForm called with uuid:', uuid);
        
        // Hide the grid and show the form
        $('#{{ formGridForward["table_id"] }}').hide();
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
        $('#{{ formGridForward["table_id"] }}').show();
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
        <!-- Forward Form - Initially Hidden -->
        <div id="forwardFormContainer" style="display: none;" class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    {{ lang._('Forward Configuration') }}
                    <button type="button" class="btn btn-xs btn-default pull-right" onclick="hideForwardForm()">
                        <span class="fa fa-times"></span> {{ lang._('Cancel') }}
                    </button>
                </h4>
            </div>
            <div class="panel-body">
                <!-- Form content will be loaded here -->
                <div id="forwardFormContent"></div>
                <div class="form-group">
                    <button type="button" class="btn btn-primary" onclick="saveForwardForm()">
                        <span class="fa fa-save"></span> {{ lang._('Save') }}
                    </button>
                    <button type="button" class="btn btn-default" onclick="hideForwardForm()">
                        {{ lang._('Cancel') }}
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Forward Grid -->
        <table id="{{ formGridForward['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridForward['edit_dialog_id'] }}" data-editAlert="{{ formGridForward['edit_alert_id'] }}">
            <thead>
                <tr>
                    <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                    <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                    <th data-column-id="name" data-type="string">{{ lang._('Tag') }}</th>
                    <th data-column-id="concurrent" data-width="10em" data-type="string">{{ lang._('Concurrent') }}</th>
                    <th data-column-id="upstream" data-width="20em" data-type="string">{{ lang._('Upstream') }}</th>
                    <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
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
                        <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridRedirect['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridRedirect['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="rules" class="tab-pane fade">
        <table id="{{ formGridRules['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridRules['edit_dialog_id'] }}" data-editAlert="{{ formGridRules['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridRules['fields'] %}
                        <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridRules['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridRules['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="hosts" class="tab-pane fade">
        <table id="{{ formGridHosts['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridHosts['edit_dialog_id'] }}" data-editAlert="{{ formGridHosts['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridHosts['fields'] %}
                        <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridHosts['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridHosts['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="ipset" class="tab-pane fade">
        <table id="{{ formGridIPSet['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridIPSet['edit_dialog_id'] }}" data-editAlert="{{ formGridIPSet['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridIPSet['fields'] %}
                        {% if field['visible'] %}
                            {% if field['column-id'] == 'sets' %}
                            <th data-column-id="sets" data-type="string" {% if field['identifier'] %}data-identifier="true"{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ lang._('Sets') }}</th>
                            {% else %}
                            <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridIPSet['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridIPSet['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="sequence" class="tab-pane fade">
        <table id="{{ formGridSequence['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridSequence['edit_dialog_id'] }}" data-editAlert="{{ formGridSequence['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridSequence['fields'] %}
                        <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridSequence['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridSequence['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="fallback" class="tab-pane fade">
        <table id="{{ formGridFallback['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridFallback['edit_dialog_id'] }}" data-editAlert="{{ formGridFallback['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridFallback['fields'] %}
                        <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridFallback['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridFallback['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
                </tr>
            </tfoot>
        </table>
    </div>
    <div id="servers" class="tab-pane fade">
        <table id="{{ formGridServers['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridServers['edit_dialog_id'] }}" data-editAlert="{{ formGridServers['edit_alert_id'] }}">
            <thead>
                <tr>
                    {% for field in formGridServers['fields'] %}
                        <th data-column-id="{{ field['column-id'] }}" data-type="string" {% if field['identifier'] %}data-identifier="true" data-visible="false"{% else %}{% if not field['visible'] %}data-visible="false"{% endif %}{% endif %} {% if not field['sortable'] %}data-sortable="false"{% endif %}>{{ field['label'] }}</th>
                    {% endfor %}
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    {% set visible_field_count = 0 %}
                    {% for field in formGridServers['fields'] %}
                        {% if field['visible'] %}
                            {% set visible_field_count = visible_field_count + 1 %}
                        {% endif %}
                    {% endfor %}
                    {% set current_visible_index = 0 %}
                    {% for field in formGridServers['fields'] %}
                        {% if field['visible'] %}
                            {% set current_visible_index = current_visible_index + 1 %}
                            {% if current_visible_index == visible_field_count %}
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-fw fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-fw fa-trash-o"></span></button>
                                </td>
                            {% else %}
                                <td></td>
                            {% endif %}
                        {% endif %}
                    {% endfor %}
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
    <button class="btn btn-primary" id="reconfigureAct"
            data-endpoint='/api/mosdns/service/reconfigure'
            data-label="{{ lang._('Apply') }}"
            data-service-widget="mosdns"
            data-error-title="{{ lang._('Error reconfiguring MosDNS') }}"
            type="button">
    </button>
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