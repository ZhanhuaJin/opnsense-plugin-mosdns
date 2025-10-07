<div id="servers" class="tab-pane fade">
<div class="content-box" style="padding-bottom: 1.5em;">
<table id="grid-servers" class="table table-condensed table-hover table-striped" data-editDialog="dialog_servers">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
            <th data-column-id="server_address" data-width="20em" data-type="string">{{ lang._('Server Address') }}</th>
            <th data-column-id="server_type" data-width="10em" data-type="string">{{ lang._('Type') }}</th>
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

<!-- Save button for Servers configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveServersAct"
                data-endpoint='/api/mosdns/plugins/saveServers'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving Servers configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save Servers') }}</b> <i id="saveServersAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
    $("#grid-servers").UIBootgrid({
        search:'/api/mosdns/plugins/searchServers',
        get:'/api/mosdns/plugins/getServers/',
        set:'/api/mosdns/plugins/setServers/',
        add:'/api/mosdns/plugins/addServers/',
        del:'/api/mosdns/plugins/delServers/',
        toggle:'/api/mosdns/plugins/toggleServers/'
    });
    
    // Initialize Save button
    $("#saveServersAct").SimpleActionButton();
});
</script>
</div>
</div>

<!-- Dialog for Servers -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditServers,'id':'dialog_servers','label':lang._('Edit Servers')])}}