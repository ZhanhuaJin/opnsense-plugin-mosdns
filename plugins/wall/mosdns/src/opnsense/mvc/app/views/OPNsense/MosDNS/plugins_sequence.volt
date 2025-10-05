<div id="sequence" class="tab-pane fade">
    <table id="grid-sequence" class="table table-condensed table-hover table-striped" data-editDialog="dialog_sequence">
        <thead>
            <tr>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Name') }}</th>
                <th data-column-id="description" data-width="25em" data-type="string">{{ lang._('Description') }}</th>
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
    
    <!-- Save button for Sequence configuration -->
    <div class="col-md-12">
        <hr/>
        <div class="pull-right">
            <button class="btn btn-primary" id="saveSequenceAct"
                    data-endpoint='/api/mosdns/plugins/saveSequence'
                    data-label="{{ lang._('Save') }}"
                    data-error-title="{{ lang._('Error saving Sequence configuration') }}"
                    type="button">
                <i class="fa fa-save"></i> <b>{{ lang._('Save Sequence') }}</b> <i id="saveSequenceAct_progress"></i>
            </button>
        </div>
        <div class="clearfix"></div>
        <br/>
    </div>
</div>

<script>
$(document).ready(function() {
    $("#grid-sequence").UIBootgrid({
        search:'/api/mosdns/plugins/searchSequence',
        get:'/api/mosdns/plugins/getSequence/',
        set:'/api/mosdns/plugins/setSequence/',
        add:'/api/mosdns/plugins/addSequence/',
        del:'/api/mosdns/plugins/delSequence/',
        toggle:'/api/mosdns/plugins/toggleSequence/'
    });
    
    // Initialize Save button
    $("#saveSequenceAct").SimpleActionButton();
});
</script>

<!-- Dialog for Sequence -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditSequence,'id':'dialog_sequence','label':lang._('Edit Sequence')])}}