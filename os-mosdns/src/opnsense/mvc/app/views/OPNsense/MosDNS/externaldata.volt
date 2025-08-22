<script>
    $( document ).ready(function() {
        var data_table_id = "grid-external-data";
        var gridopt = {
            ajax: true,
            selection: true,
            multiSelect: true,
            url: '/api/mosdns/externaldata/searchDataFile'
        };
        $("#"+data_table_id).UIBootgrid(gridopt);
        
        // Initialize default data files on first load
        ajaxCall("/api/mosdns/externaldata/initializeDefaults", {}, function(data,status) {
            if (data['result'] != undefined) {
                if (data['result'] == 'ok') {
                    $("#"+data_table_id).bootgrid('reload');
                }
            }
        }, "POST");
        
        // Download single file
        $("#downloadDataFile").click(function(){
            var rows = $("#"+data_table_id).bootgrid('getSelectedRows');
            if (rows != undefined && rows.length == 1) {
                $("#downloadDataFile").addClass("fa fa-spinner fa-pulse");
                ajaxCall("/api/mosdns/externaldata/downloadDataFile/" + rows[0], {}, function(data,status) {
                    $("#downloadDataFile").removeClass("fa fa-spinner fa-pulse");
                    if (data['result'] != undefined) {
                        if (data['result'] == 'ok') {
                            BootstrapDialog.show({
                                type: BootstrapDialog.TYPE_INFO,
                                title: "{{ lang._('Download Started') }}",
                                message: data['message'],
                                buttons: [{
                                    label: "{{ lang._('Close') }}",
                                    action: function(dialogRef){
                                        dialogRef.close();
                                        $("#"+data_table_id).bootgrid('reload');
                                    }
                                }]
                            });
                        } else {
                            BootstrapDialog.show({
                                type: BootstrapDialog.TYPE_DANGER,
                                title: "{{ lang._('Download Failed') }}",
                                message: data['message'],
                                buttons: [{
                                    label: "{{ lang._('Close') }}",
                                    action: function(dialogRef){
                                        dialogRef.close();
                                    }
                                }]
                            });
                        }
                    }
                }, "POST");
            } else {
                BootstrapDialog.show({
                    type: BootstrapDialog.TYPE_INFO,
                    title: "{{ lang._('Information') }}",
                    message: "{{ lang._('Please select a single data file to download.') }}",
                    buttons: [{
                        label: "{{ lang._('Close') }}",
                        action: function(dialogRef){
                            dialogRef.close();
                        }
                    }]
                });
            }
        });
        
        // Download all files
        $("#downloadAllFiles").click(function(){
            $("#downloadAllFiles").addClass("fa fa-spinner fa-pulse");
            ajaxCall("/api/mosdns/externaldata/downloadAll", {}, function(data,status) {
                $("#downloadAllFiles").removeClass("fa fa-spinner fa-pulse");
                if (data['result'] != undefined) {
                    if (data['result'] == 'ok') {
                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_INFO,
                            title: "{{ lang._('Download Started') }}",
                            message: data['message'],
                            buttons: [{
                                label: "{{ lang._('Close') }}",
                                action: function(dialogRef){
                                    dialogRef.close();
                                    $("#"+data_table_id).bootgrid('reload');
                                }
                            }]
                        });
                    } else {
                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_DANGER,
                            title: "{{ lang._('Download Failed') }}",
                            message: data['message'],
                            buttons: [{
                                label: "{{ lang._('Close') }}",
                                action: function(dialogRef){
                                    dialogRef.close();
                                }
                            }]
                        });
                    }
                }
            }, "POST");
        });
        
        // Refresh status
        $("#refreshStatus").click(function(){
            $("#"+data_table_id).bootgrid('reload');
        });
        
        // Add new data file
        $("#addDataFile").click(function(){
            mapDataToFormUI({'frm_DialogExternalData':'/api/mosdns/externaldata/getDataFile'}).done(function(){
                $('#DialogExternalData').modal('show');
            });
        });
        
        // Edit data file
        $("#grid-external-data").on("loaded.rs.jquery.bootgrid", function (e) {
            $("#grid-external-data a[data-row-id]").on('click', function(e) {
                e.preventDefault();
                var uuid = $(this).data("row-id");
                mapDataToFormUI({'frm_DialogExternalData':'/api/mosdns/externaldata/getDataFile/' + uuid}).done(function(){
                    $('#DialogExternalData').modal('show');
                });
            });
        });
        
        // Delete data file
        $("#deleteDataFile").click(function(){
            var rows = $("#"+data_table_id).bootgrid('getSelectedRows');
            if (rows != undefined && rows.length > 0) {
                BootstrapDialog.show({
                    type: BootstrapDialog.TYPE_DANGER,
                    title: "{{ lang._('Delete Data File') }}",
                    message: "{{ lang._('Do you want to delete the selected data file(s)?') }}",
                    buttons: [{
                        label: "{{ lang._('No') }}",
                        action: function(dialogRef){
                            dialogRef.close();
                        }
                    }, {
                        label: "{{ lang._('Yes') }}",
                        action: function(dialogRef){
                            for (var i=0; i < rows.length; i++) {
                                ajaxCall("/api/mosdns/externaldata/delDataFile/" + rows[i], {}, function(data,status) {
                                    if (data['result'] != undefined) {
                                        $("#"+data_table_id).bootgrid('reload');
                                    }
                                });
                            }
                            dialogRef.close();
                        }
                    }]
                });
            }
        });
        
        // Save data file
        $("#saveDataFile").click(function(){
            saveFormToEndpoint("/api/mosdns/externaldata/setDataFile", 'frm_DialogExternalData', function(){
            $("#DialogExternalData").modal('hide');
            $("#"+data_table_id).bootgrid('reload');
        });
        });
        
        // Toggle data file
        $("#toggleDataFile").click(function(){
            var rows = $("#"+data_table_id).bootgrid('getSelectedRows');
            if (rows != undefined && rows.length == 1) {
                ajaxCall("/api/mosdns/externaldata/toggleDataFile/" + rows[0], {}, function(data,status) {
                    if (data['result'] != undefined) {
                        $("#"+data_table_id).bootgrid('reload');
                    }
                });
            }
        });
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    {{ partial("layout_partials/base_form",['fields':formDialogExternalData,'id':'frm_external_data'])}} 
    <div class="col-md-12">
        <hr />
        <button class="btn btn-primary" id="downloadAllFiles" type="button"><b>{{ lang._('Download All Files') }}</b> <i class="fa fa-download"></i></button>
        <button class="btn btn-info" id="refreshStatus" type="button"><b>{{ lang._('Refresh Status') }}</b> <i class="fa fa-refresh"></i></button>
        <hr />
    </div>
    <div class="col-md-12">
        <table id="grid-external-data" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogExternalData">
            <thead>
                <tr>
                    <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                    <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                    <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                    <th data-column-id="filename" data-type="string">{{ lang._('File Name') }}</th>
                    <th data-column-id="url" data-type="string" data-visible="false">{{ lang._('URL') }}</th>
                    <th data-column-id="backup_url" data-type="string" data-visible="false">{{ lang._('Backup URL') }}</th>
                    <th data-column-id="status" data-type="string" data-width="8em">{{ lang._('Status') }}</th>
                    <th data-column-id="last_updated" data-type="string" data-width="10em">{{ lang._('Last Updated') }}</th>
                    <th data-column-id="file_size" data-type="string" data-width="8em">{{ lang._('File Size') }}</th>
                    <th data-column-id="auto_update" data-width="8em" data-type="string" data-formatter="boolean">{{ lang._('Auto Update') }}</th>
                    <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
            <tfoot>
                <tr>
                    <td></td>
                    <td>
                        <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                        <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
    <div class="col-md-12">
        <hr />
        <button class="btn btn-primary" id="addDataFile" type="button"><b>{{ lang._('Add Data File') }}</b> <i class="fa fa-plus"></i></button>
        <button class="btn btn-default" id="deleteDataFile" type="button"><b>{{ lang._('Delete Selected') }}</b> <i class="fa fa-trash-o"></i></button>
        <button class="btn btn-success" id="downloadDataFile" type="button"><b>{{ lang._('Download Selected') }}</b> <i class="fa fa-download"></i></button>
        <button class="btn btn-default" id="toggleDataFile" type="button"><b>{{ lang._('Toggle Selected') }}</b> <i class="fa fa-toggle-on"></i></button>
    </div>
</div>

<!-- Dialog for adding/editing external data files -->
<div class="modal fade" id="DialogExternalData" tabindex="-1" role="dialog" aria-labelledby="DialogExternalDataLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogExternalDataLabel">{{ lang._('Edit External Data File') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogExternalData">
                    <div class="table-responsive">
                        <table class="table table-striped table-condensed">
                            <tbody>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_name" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('Name') }}</b></div></td>
                                    <td>
                                        <input type="text" id="external_data.name" name="external_data.name" class="form-control" />
                                        <div class="hidden" for="help_for_external_data_name">
                                            {{ lang._('Descriptive name for this data file') }}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_filename" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('File Name') }}</b></div></td>
                                    <td>
                                        <input type="text" id="external_data.filename" name="external_data.filename" class="form-control" />
                                        <div class="hidden" for="help_for_external_data_filename">
                                            {{ lang._('Local filename to save the downloaded file as') }}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_url" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('URL') }}</b></div></td>
                                    <td>
                                        <input type="url" id="external_data.url" name="external_data.url" class="form-control" />
                                        <div class="hidden" for="help_for_external_data_url">
                                            {{ lang._('Primary download URL for the data file') }}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_backup_url" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('Backup URL') }}</b></div></td>
                                    <td>
                                        <input type="url" id="external_data.backup_url" name="external_data.backup_url" class="form-control" />
                                        <div class="hidden" for="help_for_external_data_backup_url">
                                            {{ lang._('Backup download URL to use if primary URL fails') }}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_enabled" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('Enabled') }}</b></div></td>
                                    <td>
                                        <input type="checkbox" id="external_data.enabled" name="external_data.enabled" />
                                        <div class="hidden" for="help_for_external_data_enabled">
                                            {{ lang._('Enable this data file for downloading') }}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_auto_update" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('Auto Update') }}</b></div></td>
                                    <td>
                                        <input type="checkbox" id="external_data.auto_update" name="external_data.auto_update" />
                                        <div class="hidden" for="help_for_external_data_auto_update">
                                            {{ lang._('Automatically update this file at specified intervals') }}
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td><div class="control-label"><a id="help_for_external_data_update_interval" href="#" class="showhelp"><i class="fa fa-info-circle"></i></a> <b>{{ lang._('Update Interval (hours)') }}</b></div></td>
                                    <td>
                                        <input type="number" id="external_data.update_interval" name="external_data.update_interval" class="form-control" min="1" max="168" />
                                        <div class="hidden" for="help_for_external_data_update_interval">
                                            {{ lang._('Update interval in hours (1-168)') }}
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Close') }}</button>
                <button type="button" class="btn btn-primary" id="saveDataFile">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>