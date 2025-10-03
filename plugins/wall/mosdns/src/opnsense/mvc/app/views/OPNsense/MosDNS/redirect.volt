<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_DialogEditRedirect':'/api/mosdns/redirect/getRedirect/'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize redirect grid
        $("#grid-redirect").UIBootgrid(
            {
                'search':'/api/mosdns/redirect/searchRedirect',
                'get':'/api/mosdns/redirect/getRedirect/',
                'set':'/api/mosdns/redirect/setRedirect/',
                'add':'/api/mosdns/redirect/addRedirect/',
                'del':'/api/mosdns/redirect/delRedirect/',
                'toggle':'/api/mosdns/redirect/toggleRedirect/'
            }
        );

        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-share"></i> {{ lang._('Redirect Configuration') }}</h2>
        <p>{{ lang._('Configure DNS redirect settings for MosDNS.') }}</p>
        <hr />
        
        <div class="row">
            <div class="col-md-7">
                <div class="bootgrid-header container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="actionBar">
                                <button data-action="add" type="button" class="btn btn-xs btn-primary"><span class="fa fa-plus"></span></button>
                                <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <table id="grid-redirect" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEditRedirect">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                            <th data-column-id="rules" data-type="string">{{ lang._('Rules') }}</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div class="col-md-5">
                <div class="hidden">
                    <div class="col-md-12">
                        <div class="pull-right">
                            <select id="act_service" class="selectpicker" data-style="btn-primary" data-width="200px">
                                <option value="reload">{{ lang._('Reload service') }}</option>
                                <option value="restart">{{ lang._('Restart service') }}</option>
                            </select>
                            <br/><br/>
                            <button id="act_service_update" type="button" class="btn btn-primary">{{ lang._('Apply') }}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-12">
            <hr/>
            <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b> <i id="reconfigureAct_progress"></i></button>
            <br/><br/>
        </div>
    </div>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogEditRedirect,'id':'DialogEditRedirect','label':lang._('Edit Redirect')])}}