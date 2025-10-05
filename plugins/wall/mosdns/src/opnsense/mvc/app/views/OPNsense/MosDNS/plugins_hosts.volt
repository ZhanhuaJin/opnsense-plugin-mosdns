<div id="hosts" class="tab-pane fade">
<table id="{{ formGridHosts['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridHosts['edit_dialog_id'] }}" data-editAlert="{{ formGridHosts['edit_alert_id'] }}">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
            <th data-column-id="hostname" data-width="20em" data-type="string">{{ lang._('Hostname') }}</th>
            <th data-column-id="ip_address" data-width="15em" data-type="string">{{ lang._('IP Address') }}</th>
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

<!-- Save button for Hosts configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveHostsAct"
                data-endpoint='/api/mosdns/plugins/saveHosts'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving Hosts configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save Hosts') }}</b> <i id="saveHostsAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
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
    
    // Initialize Save button
    $("#saveHostsAct").SimpleActionButton();
});
</script>
</div>

<!-- Dialog for Hosts -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditHosts,'id':'dialog_hosts','label':lang._('Edit Hosts')])}}