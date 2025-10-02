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
        $("#{{formGridDataSource['table_id']}}").UIBootgrid(
            {   search:'/api/mosdns/data/searchDataSource',
                get:'/api/mosdns/data/getDataSource/',
                set:'/api/mosdns/data/setDataSource/',
                add:'/api/mosdns/data/addDataSource/',
                del:'/api/mosdns/data/delDataSource/',
                toggle:'/api/mosdns/data/toggleDataSource/'
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
            
            <!-- Data Sources Table -->
            {{ partial("layout_partials/base_bootgrid_table", formGridDataSource) }}
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
{{ partial("layout_partials/base_dialog",['fields':formDialogDataSource,'id':'DialogDataSource','label':lang._('Edit Data Source')])}}