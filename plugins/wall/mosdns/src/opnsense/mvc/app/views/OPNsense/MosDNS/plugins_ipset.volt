<div id="ipset" class="tab-pane fade">
<table id="{{ formGridIPSet['table_id'] }}" class="table table-condensed table-hover table-striped" data-editDialog="{{ formGridIPSet['edit_dialog_id'] }}" data-editAlert="{{ formGridIPSet['edit_alert_id'] }}">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
            <th data-column-id="ipset_name" data-width="15em" data-type="string">{{ lang._('IPSet Name') }}</th>
            <th data-column-id="domain" data-width="20em" data-type="string">{{ lang._('Domain') }}</th>
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

<!-- Save button for IPSet configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveIPSetAct"
                data-endpoint='/api/mosdns/plugins/saveIPSet'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving IPSet configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save IPSet') }}</b> <i id="saveIPSetAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
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
    
    // Initialize Save button
    $("#saveIPSetAct").SimpleActionButton();
});
</script>
</div>

<!-- Dialog for IPSet -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditIPSet,'id':'dialog_ipset','label':lang._('Edit IPSet')])}}