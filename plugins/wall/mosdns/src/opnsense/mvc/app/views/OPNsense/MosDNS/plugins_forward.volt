<div id="forward" class="tab-pane fade in active">
<div class="col-md-12">
<table id="grid-forward" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialog_forward" data-store-selection="true" data-store-selection-key="forward.selection">
            <thead>
            <tr>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                <th data-column-id="name" data-type="string">{{ lang._('Tag') }}</th>
                <th data-column-id="concurrent" data-type="string">{{ lang._('Concurrent') }}</th>
                <th data-column-id="upstream" data-type="string">{{ lang._('Upstream') }}</th>
                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
            <tr>
                <td></td>
                <td>
                    <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-plus"></span></button>
                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
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
    // 使用标准的UIBootgrid配置，但自定义add和edit行为
    var grid = $("#grid-forward").UIBootgrid({
        search:'/api/mosdns/plugins/searchForward',
        get:'/api/mosdns/plugins/getForward/',
        set:'/api/mosdns/plugins/setForward/',
        add:'/api/mosdns/plugins/addForward/',
        del:'/api/mosdns/plugins/delForward/',
        toggle:'/api/mosdns/plugins/toggleForward/',
        options: {
            formatters: {
                "commands": function(column, row) {
                    return '<button type="button" class="btn btn-xs btn-default command-edit" data-row-id="' + row.uuid + '"><span class="fa fa-pencil"></span></button> ' +
                           '<button type="button" class="btn btn-xs btn-default command-copy" data-row-id="' + row.uuid + '"><span class="fa fa-clone"></span></button> ' +
                           '<button type="button" class="btn btn-xs btn-default command-delete" data-row-id="' + row.uuid + '"><span class="fa fa-trash-o"></span></button>';
                }
            }
        }
    });
    
    // Override add button behavior
    $("#grid-forward").on("click", "button[data-action='add']", function(e) {
        e.preventDefault();
        e.stopPropagation();
        window.location.href = '/ui/mosdns/forward/edit';
    });
    
    // Override edit button behavior
    $("#grid-forward").on("click", ".command-edit", function(e) {
        e.preventDefault();
        e.stopPropagation();
        var uuid = $(this).data('row-id');
        window.location.href = '/ui/mosdns/forward/edit/' + uuid;
    });
    
    // Initialize save button
    $("#saveForwardAct").SimpleActionButton();
});
</script>
</div>