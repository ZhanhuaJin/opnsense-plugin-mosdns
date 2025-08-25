<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_GeneralSettings':'/api/mosdns/general/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        updateServiceControlUI('mosdns');

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/general/set", formid='frm_GeneralSettings',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    updateServiceControlUI('mosdns');
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                });
            });
        });

        $("#configtestAct").click(function(){
            $("#configtestAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/mosdns/service/configtest", sendData={}, callback=function(data,status) {
                $("#configtestAct_progress").removeClass("fa fa-spinner fa-pulse");
                if (status == "success") {
                    if (data['result'].indexOf('ERROR') > -1) {
                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_WARNING,
                            title: "{{ lang._('Configuration test') }}",
                            message: data['result'],
                            draggable: true
                        });
                    } else {
                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_INFO,
                            title: "{{ lang._('Configuration test') }}",
                            message: "{{ lang._('Configuration OK') }}",
                            draggable: true
                        });
                    }
                }
            });
        });

        // Handle tab switching and update URL hash
        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var target = $(e.target).attr("href");
            if (target) {
                window.location.hash = target;
            }
        });

        // Load tab from URL hash on page load
        if (window.location.hash) {
            var hash = window.location.hash;
            $('a[href="' + hash + '"]').tab('show');
        }
    });
</script>

<ul class="nav nav-tabs" role="tablist" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#general"><b>{{ lang._('General') }}</b></a></li>
    
    <li role="presentation" class="dropdown">
        <a data-toggle="dropdown" href="#" class="dropdown-toggle pull-right visible-lg-inline-block visible-md-inline-block visible-xs-inline-block visible-sm-inline-block" role="button">
            <b><span class="caret"></span></b>
        </a>
        <a data-toggle="tab" onclick="$('#plugins-cache-tab').click();" class="visible-lg-inline-block visible-md-inline-block visible-xs-inline-block visible-sm-inline-block" style="border-right:0px;"><b>{{ lang._('Plugins') }}</b></a>
        <ul class="dropdown-menu" role="menu">
            <li><a data-toggle="tab" id="plugins-cache-tab" href="#plugins-cache">{{ lang._('Cache') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-fallback">{{ lang._('Fallback') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-forward">{{ lang._('Forward') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-hosts">{{ lang._('Hosts') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-ipset">{{ lang._('IPSet') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-redirect">{{ lang._('Redirect') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-sequence">{{ lang._('Sequence') }}</a></li>
            <li><a data-toggle="tab" href="#plugins-servers">{{ lang._('Servers') }}</a></li>
        </ul>
    </li>
    
    <li><a data-toggle="tab" href="#external-data"><b>{{ lang._('External Data') }}</b></a></li>
    <li><a data-toggle="tab" href="#statistics"><b>{{ lang._('Statistics') }}</b></a></li>
    <li><a data-toggle="tab" href="#log-file"><b>{{ lang._('Log File') }}</b></a></li>
</ul>

<div class="content-box tab-content">
    <!-- General Tab -->
    <div id="general" class="tab-pane fade in active">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':generalForm,'id':'frm_GeneralSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress" class=""></i></button>
                <button class="btn btn-info" id="configtestAct" type="button"><b>{{ lang._('Test Configuration') }}</b> <i id="configtestAct_progress" class=""></i></button>
            </div>
        </div>
    </div>

    <!-- Plugins Tabs -->
    <div id="plugins-cache" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsCacheForm,'id':'frm_PluginsCacheSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsCacheAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-fallback" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsFallbackForm,'id':'frm_PluginsFallbackSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsFallbackAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-forward" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsForwardForm,'id':'frm_PluginsForwardSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsForwardAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-hosts" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsHostsForm,'id':'frm_PluginsHostsSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsHostsAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-ipset" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsIpsetForm,'id':'frm_PluginsIpsetSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsIpsetAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-redirect" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsRedirectForm,'id':'frm_PluginsRedirectSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsRedirectAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-sequence" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsSequenceForm,'id':'frm_PluginsSequenceSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsSequenceAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <div id="plugins-servers" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':pluginsServersForm,'id':'frm_PluginsServersSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="savePluginsServersAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <!-- External Data Tab -->
    <div id="external-data" class="tab-pane fade">
        <div class="col-md-12">
            {{ partial("layout_partials/base_form",['fields':externalDataForm,'id':'frm_ExternalDataSettings']) }}
            <div class="col-md-12">
                <hr/>
                <button class="btn btn-primary" id="saveExternalDataAct" type="button"><b>{{ lang._('Save') }}</b></button>
            </div>
        </div>
    </div>

    <!-- Statistics Tab -->
    <div id="statistics" class="tab-pane fade">
        <div class="col-md-12">
            <h3>{{ lang._('MosDNS Statistics') }}</h3>
            <p>{{ lang._('Statistics and monitoring information will be displayed here.') }}</p>
        </div>
    </div>

    <!-- Log File Tab -->
    <div id="log-file" class="tab-pane fade">
        <div class="col-md-12">
            <h3>{{ lang._('MosDNS Log File') }}</h3>
            <p>{{ lang._('Log file contents will be displayed here.') }}</p>
        </div>
    </div>
</div>