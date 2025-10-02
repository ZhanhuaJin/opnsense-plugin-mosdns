<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_DialogEditIPSet':'/api/mosdns/ipset/getItem/'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize ipset grid
        $("#grid-ipset").UIBootgrid(
            {
                'search':'/api/mosdns/ipset/searchItem',
                'get':'/api/mosdns/ipset/getItem/',
                'set':'/api/mosdns/ipset/setItem/',
                'add':'/api/mosdns/ipset/addItem/',
                'del':'/api/mosdns/ipset/delItem/',
                'toggle':'/api/mosdns/ipset/toggleItem/'
            }
        );

        updateServiceControlUI('mosdns');
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-filter"></i> {{ lang._('IPSet Configuration') }}</h2>
        <p>{{ lang._('Configure IPSet filtering for MosDNS.') }}</p>
        <hr />
        
        <div class="row">
            <div class="col-md-12">
                <table id="grid-ipset" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogEditIPSet" data-editAlert="mosdnsChangeMessage">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                            <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                            <th data-column-id="sets" data-type="string">{{ lang._('Sets') }}</th>
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
            </div>
        </div>
    </div>
</div>

<section class="page-content-main">
    <div class="content-box">
        <div class="col-md-12">
            <br/>
            <div id="mosdnsChangeMessage" class="alert alert-info" style="display: none" role="alert">
                {{ lang._('After changing settings, please remember to apply them with the button below') }}
            </div>
            <button class="btn btn-primary" id="reconfigureAct"
                    data-endpoint='/api/mosdns/service/reconfigure'
                    data-label="{{ lang._('Apply') }}"
                    data-service-widget="mosdns"
                    data-error-title="{{ lang._('Error reconfiguring MosDNS') }}"
                    type="button"
            ></button>
            <br/><br/>
        </div>
    </div>
</section>

{# include dialogs #}
{{ partial("layout_partials/base_dialog",['fields':formDialogEditIPSet,'id':'DialogEditIPSet','label':lang._('Edit IPSet')])}}
