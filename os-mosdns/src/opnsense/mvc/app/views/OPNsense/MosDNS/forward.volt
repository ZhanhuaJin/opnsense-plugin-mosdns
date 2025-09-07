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
        $("#grid-forward").UIBootgrid(
            {   search:'/api/mosdns/forward/searchForward',
                get:'/api/mosdns/forward/getForward/',
                set:'/api/mosdns/forward/setForward/',
                add:'/api/mosdns/forward/addForward/',
                del:'/api/mosdns/forward/delForward/',
                toggle:'/api/mosdns/forward/toggleForward/'
            }
        );
        
        // Update service control UI
        updateServiceControlUI('mosdns');
    });

</script>

<div class="content-box">
    <div class="content-box-main">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <small>{{ lang._('full help') }} </small>
                    <a href="#" class="showhelp"><i class="fa fa-info-circle"></i></a>
                </div>
            </div>
            
            <!-- Forward Entries Table -->
            <table id="grid-forward" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogForward" data-editAlert="mosdnsChangeMessage">
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
{{ partial("layout_partials/base_dialog",['fields':formDialogForward,'id':'DialogForward','label':lang._('Edit Forward Entry')])}}