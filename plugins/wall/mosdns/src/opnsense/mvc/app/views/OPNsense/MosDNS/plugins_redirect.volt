<div id="redirect" class="tab-pane fade">
<table id="{{ formGridRedirect['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridRedirect['edit_dialog_id'] }}" data-editAlert="{{ formGridRedirect['edit_alert_id'] }}">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
            <th data-column-id="domain" data-width="20em" data-type="string">{{ lang._('Domain') }}</th>
            <th data-column-id="target" data-width="20em" data-type="string">{{ lang._('Target') }}</th>
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

<!-- Save button for Redirect configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveRedirectAct"
                data-endpoint='/api/mosdns/plugins/saveRedirect'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving Redirect configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save Redirect') }}</b> <i id="saveRedirectAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
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
            // Grid loaded callback
        });
    }
    
    // Initialize Save button
    $("#saveRedirectAct").SimpleActionButton();
});
</script>
</div>

<!-- Dialog for Redirect -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditRedirect,'id':'dialog_redirect','label':lang._('Edit Redirect')])}}