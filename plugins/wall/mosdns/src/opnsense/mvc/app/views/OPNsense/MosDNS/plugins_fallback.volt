<div id="fallback" class="tab-pane fade">
<div class="content-box" style="padding-bottom: 1.5em;">
<div class="table-responsive">
<table id="grid-fallback" class="table table-condensed table-hover table-striped" data-editDialog="dialog_fallback" style="width: 100%;">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Tag') }}</th>
            <th data-column-id="primary" data-type="string">{{ lang._('Primary') }}</th>
            <th data-column-id="secondary" data-type="string">{{ lang._('Secondary') }}</th>
            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false" data-align="right" data-header-align="right">{{ lang._('Commands') }}</th>
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

<!-- Save button for Fallback configuration -->
<div class="col-md-12">
    <hr/>
    <div class="pull-right">
        <button class="btn btn-primary" id="saveFallbackAct"
                data-endpoint='/api/mosdns/plugins/saveFallback'
                data-label="{{ lang._('Save') }}"
                data-error-title="{{ lang._('Error saving Fallback configuration') }}"
                type="button">
            <i class="fa fa-save"></i> <b>{{ lang._('Save Fallback') }}</b> <i id="saveFallbackAct_progress"></i>
        </button>
    </div>
    <div class="clearfix"></div>
    <br/>
</div>

<script>
$(document).ready(function() {
    $("#grid-fallback").UIBootgrid({
        search:'/api/mosdns/plugins/searchFallback',
        get:'/api/mosdns/plugins/getFallback/',
        set:'/api/mosdns/plugins/setFallback/',
        add:'/api/mosdns/plugins/addFallback/',
        del:'/api/mosdns/plugins/delFallback/',
        toggle:'/api/mosdns/plugins/toggleFallback/'
    });
    
    // Initialize Save button
    $("#saveFallbackAct").SimpleActionButton();
});
</script>
</div>
</div>

<!-- Dialog for Fallback -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditFallback,'id':'dialog_fallback','label':lang._('Edit Fallback')])}}