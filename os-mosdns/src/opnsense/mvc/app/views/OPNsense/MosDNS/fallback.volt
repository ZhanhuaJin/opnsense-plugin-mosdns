<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_DialogEditFallback':'/api/mosdns/fallback/getFallback/'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize fallback grid
        $("#grid-fallback").UIBootgrid(
            {
                'search':'/api/mosdns/fallback/searchFallback',
                'get':'/api/mosdns/fallback/getFallback/',
                'set':'/api/mosdns/fallback/setFallback/',
                'add':'/api/mosdns/fallback/addFallback/',
                'del':'/api/mosdns/fallback/delFallback/',
                'toggle':'/api/mosdns/fallback/toggleFallback/'
            }
        );

        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-shield"></i> {{ lang._('Fallback Configuration') }}</h2>
        <p>{{ lang._('Configure fallback DNS servers for MosDNS.') }}</p>
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
                
                <table id="grid-fallback" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEditFallback">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                            <th data-column-id="primary" data-type="string">{{ lang._('Primary') }}</th>
                            <th data-column-id="secondary" data-type="string">{{ lang._('Secondary') }}</th>
                            <th data-column-id="threshold" data-type="string">{{ lang._('Threshold') }}</th>
                            <th data-column-id="always_standby" data-type="string">{{ lang._('Always Standby') }}</th>
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

{{ partial("layout_partials/base_dialog",['fields':formDialogEditFallback,'id':'DialogEditFallback','label':lang._('Edit Fallback')])}}