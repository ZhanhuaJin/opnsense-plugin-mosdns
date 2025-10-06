<div id="forward" class="tab-pane fade in active">
<div class="col-md-12">
<table id="grid-forward" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialog_forward" data-store-selection="true" data-store-selection-key="forward.selection">
            <thead>
            <tr>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                <th data-column-id="name" data-type="string">{{ lang._('Tag') }}</th>
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

<!-- Hidden edit form -->
<div id="edit-form-container" class="col-md-12" style="display: none;">
    <hr/>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title">{{ lang._('Edit Forward Entry') }}</h4>
        </div>
        <div class="panel-body">
            <form id="edit-form" class="form-horizontal">
                <div class="form-group">
                    <label class="col-sm-2 control-label">{{ lang._('Enabled') }}</label>
                    <div class="col-sm-10">
                        <input type="checkbox" id="edit-enabled" name="enabled" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">{{ lang._('Tag') }}</label>
                    <div class="col-sm-10">
                        <input type="text" id="edit-name" name="name" class="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">{{ lang._('Concurrent') }}</label>
                    <div class="col-sm-10">
                        <input type="text" id="edit-concurrent" name="concurrent" class="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">{{ lang._('Upstream') }}</label>
                    <div class="col-sm-10">
                        <textarea id="edit-upstream" name="upstream" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">{{ lang._('Command') }}</label>
                    <div class="col-sm-10">
                        <input type="text" id="edit-command" name="command" class="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <button type="button" id="save-edit" class="btn btn-primary">{{ lang._('Save') }}</button>
                        <button type="button" id="cancel-edit" class="btn btn-default">{{ lang._('Cancel') }}</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
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

<!-- 移除隐藏的编辑表单容器 -->

<script>
$(document).ready(function() {
    // 使用标准的UIBootgrid配置
    var grid = $("#grid-forward").UIBootgrid({
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

{{ partial("layout_partials/base_dialog",['fields':formDialogEditForward,'id':'dialog_forward','label':lang._('Edit Forward Entry')])}}