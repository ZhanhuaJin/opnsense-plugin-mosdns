<div id="forward" class="tab-pane fade in active">
<div class="content-box" style="padding-bottom: 1.5em;">
<div class="table-responsive">
<table id="grid-forward" class="table table-condensed table-hover table-striped" style="width: 100%;">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Tag') }}</th>
            <th data-column-id="upstream" data-type="string">{{ lang._('Upstream') }}</th>
            <th data-column-id="concurrent" data-width="10em" data-type="string">{{ lang._('Concurrent') }}</th>
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
    // Forward Grid
    $("#grid-forward").UIBootgrid({
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
        }).on("loaded.rs.jquery.bootgrid", function() {
            // Override the add button behavior
            $(this).find('button[data-action="add"]').off('click').on('click', function(e) {
                e.preventDefault();
                // Set title for new entry
                $('#forwardedit-title').text('{{ lang._("Forward New") }}');
                
                // Hide forward tab and show forwardedit tab
                $('#maintabs li a[href="#forward"]').parent().hide();
                $('#maintabs li').removeClass('active');
                $('#maintabs li a[href="#forwardedit"]').parent().show().addClass('active');
                $('.tab-pane').removeClass('active in');
                $('#forward').hide();
                $('#forwardedit').addClass('active in').show();
                
                // Initialize upstream grid when tab is shown
                if (typeof initUpstreamGrid === 'function') {
                    initUpstreamGrid();
                }
                
                // Clear the form for new entry
                $('#forward_enabled').val('1').trigger('change');
                $('#forward_tag').val('');
                $('#forward_concurrent').val('1');
                
                if (typeof mapDataToFormUI === 'function') {
                    var data_get_map = {'frm_forward_settings': "/api/mosdns/plugins/getForward/"};
                    mapDataToFormUI(data_get_map);
                }
            });
            
        }).on("loaded.rs.jquery.bootgrid", function() {
            // Override edit button behavior after grid is loaded
            var grid = $(this);
            grid.find('.command-edit').off('click').on('click', function(e) {
                e.preventDefault();
                var uuid = $(this).data('row-id');
                if (uuid) {
                    // Set title for edit entry
                    $('#forwardedit-title').text('{{ lang._("Forward Edit") }}');
                    
                    // Hide forward tab and show forwardedit tab
                    $('#maintabs li a[href="#forward"]').parent().hide();
                    $('#maintabs li').removeClass('active');
                    $('#maintabs li a[href="#forwardedit"]').parent().show().addClass('active');
                    $('.tab-pane').removeClass('active in');
                    $('#forward').hide();
                    $('#forwardedit').addClass('active in').show();
                    
                    // Initialize upstream grid when tab is shown
                    if (typeof initUpstreamGrid === 'function') {
                        initUpstreamGrid();
                    }
                    
                    // Load the form data for editing
                    if (typeof mapDataToFormUI === 'function') {
                        var data_get_map = {'frm_forward_settings': "/api/mosdns/plugins/getForward/" + uuid};
                        mapDataToFormUI(data_get_map).done(function(data) {
                            // Populate the additional fields
                            if (data && data.frm_forward_settings) {
                                var settings = data.frm_forward_settings;
                                $('#forward_enabled').val(settings.enabled || '1').trigger('change');
                                $('#forward_tag').val(settings.tag || '');
                                $('#forward_concurrent').val(settings.concurrent || '1');
                            }
                        });
                    }
                }
            });
        });
    
    // Initialize Save button
    $("#saveForwardAct").SimpleActionButton();
});
</script>
</div>
</div>

<!-- Dialog for Forward -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditForward,'id':'dialog_forward','label':lang._('Edit Forward')])}}