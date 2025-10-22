<div id="sequence" class="tab-pane fade">
<div class="content-box" style="padding-bottom: 1.5em;">
<div class="table-responsive">
<table id="grid-sequence" class="table table-condensed table-hover table-striped" style="width: 100%;">
    <thead>
        <tr>
            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
            <th data-column-id="name" data-width="15em" data-type="string">{{ lang._('Tag') }}</th>
            <th data-column-id="exec" data-type="string">{{ lang._('Exec') }}</th>
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

<script>
$(document).ready(function() {
    $("#grid-sequence").UIBootgrid({
        search:'/api/mosdns/plugins/searchSequence',
        get:'/api/mosdns/plugins/getSequence/',
        set:'/api/mosdns/plugins/setSequence/',
        add:'/api/mosdns/plugins/addSequence/',
        del:'/api/mosdns/plugins/delSequence/',
        toggle:'/api/mosdns/plugins/toggleSequence/',
        options: {
            selection: true,
            multiSelect: true,
            rowSelect: true,
            rowCount: [7, 14, 20, 50, 100, -1],
            formatters: {
                "uuid": function(column, row) {
                    return "";  // Hide ID column
                },
                "commands": function(column, row) {
                    var buttons = '<button type="button" class="btn btn-xs btn-default command-edit" data-row-id="' + row.uuid + '"><span class="fa fa-pencil"></span></button> ';
                    buttons += '<button type="button" class="btn btn-xs btn-default command-copy" data-row-id="' + row.uuid + '"><span class="fa fa-clone"></span></button> ';
                    buttons += '<button type="button" class="btn btn-xs btn-default command-delete" data-row-id="' + row.uuid + '"><span class="fa fa-trash-o"></span></button>';
                    return buttons;
                }
            }
        }
    }).on("loaded.rs.jquery.bootgrid", function() {
        // Override the add button behavior - use sequenceedit tab
        $(this).find('button[data-action="add"]').off('click').on('click', function(e) {
            e.preventDefault();
            
            // Set title for new entry
            $('#sequenceedit-title').text('{{ lang._("Sequence New") }}');
            
            // Hide sequence tab and show sequenceedit tab
            $('#maintabs li a[href="#sequence"]').parent().hide();
            $('#maintabs li').removeClass('active');
            $('#maintabs li a[href="#sequenceedit"]').parent().show().addClass('active');
            $('.tab-pane').removeClass('active in');
            $('#sequence').hide();
            $('#sequenceedit').addClass('active in').show();
            
            // Initialize sequence steps grid when tab is shown
            if (typeof initSequenceStepsGrid === 'function') {
                initSequenceStepsGrid();
            }
            
            // Clear the form for new entry
            $('#sequence_enabled').val('1').trigger('change');
            $('#sequence_name').val('');
            
            if (typeof mapDataToFormUI === 'function') {
                var data_get_map = {'frm_sequence_settings': "/api/mosdns/plugins/getSequence/"};
                mapDataToFormUI(data_get_map);
            }
        });
        
    }).on("loaded.rs.jquery.bootgrid", function() {
        // Override edit button behavior after grid is loaded - use sequenceedit tab
        var grid = $(this);
        grid.find('.command-edit').off('click').on('click', function(e) {
            e.preventDefault();
            var uuid = $(this).data('row-id');
            if (uuid) {
                // Set title for edit entry
                $('#sequenceedit-title').text('{{ lang._("Sequence Edit") }}');
                
                // Hide sequence tab and show sequenceedit tab
                $('#maintabs li a[href="#sequence"]').parent().hide();
                $('#maintabs li').removeClass('active');
                $('#maintabs li a[href="#sequenceedit"]').parent().show().addClass('active');
                $('.tab-pane').removeClass('active in');
                $('#sequence').hide();
                $('#sequenceedit').addClass('active in').show();
                
                // Initialize sequence steps grid when tab is shown
                if (typeof initSequenceStepsGrid === 'function') {
                    initSequenceStepsGrid();
                }
                
                // Load the form data for editing
                if (typeof mapDataToFormUI === 'function') {
                    var data_get_map = {'frm_sequence_settings': "/api/mosdns/plugins/getSequence/" + uuid};
                    mapDataToFormUI(data_get_map).done(function(data) {
                        // Populate the additional fields
                        if (data && data.frm_sequence_settings) {
                            var settings = data.frm_sequence_settings;
                            $('#sequence_enabled').val(settings.enabled || '1').trigger('change');
                            $('#sequence_name').val(settings.name || '');
                        }
                    });
                }
            }
        });
        
        // Handle custom delete button clicks
        grid.find('.command-delete').off('click').on('click', function(e) {
            e.preventDefault();
            var uuid = $(this).data('row-id');
            if (uuid && confirm('{{ lang._("Do you really want to delete this entry?") }}')) {
                ajaxCall('/api/mosdns/plugins/delSequence/' + uuid, {}, function(data, status) {
                    if (status === "success") {
                        $("#grid-sequence").bootgrid("reload");
                    }
                });
            }
        });
        
        // Handle custom copy button clicks
        grid.find('.command-copy').off('click').on('click', function(e) {
            e.preventDefault();
            var uuid = $(this).data('row-id');
            if (uuid) {
                ajaxCall('/api/mosdns/plugins/getSequence/' + uuid, {}, function(data, status) {
                    if (status === "success" && data.sequence) {
                        // Create a copy with new UUID
                        var copyData = JSON.parse(JSON.stringify(data.sequence));
                        delete copyData.uuid;
                        copyData.name = copyData.name + '_copy';
                        
                        ajaxCall('/api/mosdns/plugins/addSequence/', copyData, function(result, status) {
                            if (status === "success") {
                                $("#grid-sequence").bootgrid("reload");
                            }
                        });
                    }
                });
            }
        });
    });
    
    // Initialize Save button
    $("#saveSequenceAct").SimpleActionButton();
});
</script>
</div>
</div>