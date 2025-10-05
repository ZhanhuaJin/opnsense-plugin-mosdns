{#

OPNsense® is Copyright © 2024 by Deciso B.V.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

#}

<script>
    $( document ).ready(function() {
        // 设置CSRF令牌头
        $.ajaxSetup({
            beforeSend: function(xhr, settings) {
                // 从cookie中获取CSRF令牌
                var csrfToken = '';
                var cookies = document.cookie.split(';');
                for (var i = 0; i < cookies.length; i++) {
                    var cookie = cookies[i].trim();
                    if (cookie.indexOf('X-CSRFToken=') === 0) {
                        csrfToken = cookie.substring('X-CSRFToken='.length);
                        break;
                    }
                }
                if (csrfToken) {
                    xhr.setRequestHeader('X-CSRFToken', csrfToken);
                }
            }
        });

        $("#grid-forward").UIBootgrid({
            search:'/api/mosdns/plugins/searchForward',
            get:'/api/mosdns/plugins/getForward/',
            set:'/api/mosdns/plugins/setForward/',
            add:'/api/mosdns/plugins/addForward/',
            del:'/api/mosdns/plugins/delForward/',
            toggle:'/api/mosdns/plugins/toggleForward/'
        });

        // 动态标签页控制逻辑 - 参考IPSec connections实现
        $("#ForwardDialog").click(function(){
            $(this).show();
        });

        $("#ForwardDialog").change(function(){
            if ($("#edit_forward").is(':visible')) {
                $("#tab_forwards").click();
                $("#ForwardDialog").hide();
            } else {
                $("#ForwardDialog").click();
            }
        });

        // 根据Forward名称动态更新标签页文本
        $("#forward\\\\.name").change(function(){
            if ($(this).val() !== '') {
                $("#ForwardDialog").text($(this).val());
            } else {
                $("#ForwardDialog").text('{{ lang._("Edit Forward") }}');
            }
        });

        // 将对话框表单移动到编辑标签页中
        $("#frm_ForwardDialog").append($("#frm_DialogForward").detach());

        updateServiceControlUI('mosdns');

        /**
         * reconfigure
         */
        $("#reconfigureAct").SimpleActionButton({
            onAction: function(data, status){
                updateServiceControlUI('mosdns');
            }
        });
    });
</script>

<style>
  div.section_header > hr {
      margin: 0px;
  }
  div.section_header > h2 {
      padding-left: 5px;
      margin: 0px;
  }
</style>

<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" id="tab_forwards" href="#forwards">{{ lang._('Forwards') }}</a></li>
    <li><a data-toggle="tab" href="#edit_forward" id="ForwardDialog" style="display: none;">{{ lang._('Edit Forward') }}</a></li>
</ul>

<div class="tab-content content-box">
    <div id="forwards" class="tab-pane fade in active">
        <table id="grid-forward" class="table table-condensed table-hover table-striped" data-editDialog="ForwardDialog" data-editAlert="ForwardChangeMessage">
            <thead>
                <tr>
                    <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                    <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                    <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                    <th data-column-id="concurrent" data-type="string">{{ lang._('Concurrent') }}</th>
                    <th data-column-id="upstreams" data-type="string">{{ lang._('Upstreams') }}</th>
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
        <div class="col-md-12">
            <div id="ForwardChangeMessage" class="alert alert-info" style="display: none" role="alert">
                {{ lang._('After changing settings, please remember to apply them with the button below') }}
            </div>
            <hr/>
        </div>
        <div class="col-md-12 form-inline __mb">
            <div class="form-group __mr">
                <button class="btn btn-primary" id="reconfigureAct"
                        data-endpoint="/api/mosdns/service/reconfigure"
                        data-label="{{ lang._('Apply') }}"
                        data-service-widget="mosdns"
                        data-error-title="{{ lang._('Error reconfiguring MosDNS') }}"
                        type="button"
                ></button>
            </div>
        </div>
    </div>
    
    <div id="edit_forward" class="tab-pane fade in">
        <div class="section_header">
            <h2>{{ lang._('Forward Settings')}}</h2>
            <hr/>
        </div>
        <div>
            <form id="frm_ForwardDialog">
            </form>
        </div>
    </div>
</div>

{# include dialogs #}
{{ partial("layout_partials/base_dialog",['fields':formDialogForward,'id':'DialogForward','label':lang._('Edit Forward Entry')])}}