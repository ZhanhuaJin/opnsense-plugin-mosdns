<div id="forward" class="tab-pane fade in active">
<table id="grid-forward" class="table table-condensed table-hover table-striped" data-editDialog="dialog_forward">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
            <th data-column-id="upstream" data-width="25em" data-type="string">{{ lang._('Upstream') }}</th>
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

<!-- Save button for Forward configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveForwardAct"
                data-endpoint='/api/mosdns/plugins/saveForward'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving Forward configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save Forward') }}</b> <i id="saveForwardAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
    $("#grid-forward").UIBootgrid({
        search:'/api/mosdns/plugins/searchForward',
        get:'/api/mosdns/plugins/getForward/',
        set:'/api/mosdns/plugins/setForward/',
        add:'/api/mosdns/plugins/addForward/',
        del:'/api/mosdns/plugins/delForward/',
        toggle:'/api/mosdns/plugins/toggleForward/'
    });
    
    // Initialize save button
    $("#saveForwardAct").SimpleActionButton();
});
</script>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogForward,'id':'dialog_forward','label':lang._('Edit Forward Entry')])}}