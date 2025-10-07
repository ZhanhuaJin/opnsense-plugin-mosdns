<div id="rules" class="tab-pane fade">
<div class="content-box" style="padding-bottom: 1.5em;">
<table id="{{ formGridRules['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridRules['edit_dialog_id'] }}" data-editAlert="{{ formGridRules['edit_alert_id'] }}">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
            <th data-column-id="rule_type" data-width="10em" data-type="string">{{ lang._('Type') }}</th>
            <th data-column-id="rule_value" data-width="20em" data-type="string">{{ lang._('Value') }}</th>
            <th data-column-id="action" data-width="10em" data-type="string">{{ lang._('Action') }}</th>
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

<!-- Save button for Rules configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveRulesAct"
                data-endpoint='/api/mosdns/plugins/saveRules'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving Rules configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save Rules') }}</b> <i id="saveRulesAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
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
            // Grid loaded callback
        });
    }
    
    // Initialize Save button
    $("#saveRulesAct").SimpleActionButton();
});
</script>
</div>
</div>

<!-- Dialog for Rules -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditRules,'id':'dialog_rules','label':lang._('Edit Rules')])}}