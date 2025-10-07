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
        var data_get_map = {'frm_sequence_settings':"/api/mosdns/plugins/getSequence/"};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // Initialize sequence steps grid (only when needed, not on page load)
        function initSequenceStepsGrid() {
            if (!$("#grid-sequence-steps").hasClass('bootgrid-table')) {
                $("#grid-sequence-steps").UIBootgrid({
                    search:'/api/mosdns/plugins_sequence_edit/searchSequenceStep/',
                    get:'/api/mosdns/plugins_sequence_edit/getSequenceStep/',
                    set:'/api/mosdns/plugins_sequence_edit/setSequenceStep/',
                    add:'/api/mosdns/plugins_sequence_edit/addSequenceStep/',
                    del:'/api/mosdns/plugins_sequence_edit/delSequenceStep/',
                    toggle:'/api/mosdns/plugins_sequence_edit/toggleSequenceStep/'
                });
            }
        }

        // Make the function globally available
        window.initSequenceStepsGrid = initSequenceStepsGrid;

        // Save button functionality
        $("#saveSequenceAct").click(function() {
            saveFormToEndpoint(url="/api/mosdns/plugins/setSequence", formid='frm_sequence_settings', callback_ok=function(){
                // Hide the sequenceedit tab and show the sequence tab
                $('#maintabs li').removeClass('active');
                $('#maintabs li a[href="#sequenceedit"]').parent().hide();
                $('#maintabs li a[href="#sequence"]').parent().show().addClass('active');
                $('.tab-pane').removeClass('active in');
                $('#sequenceedit').hide();
                $('#sequence').addClass('active in').show();
                
                // Reload the sequence grid
                $("#grid-sequence").bootgrid("reload");
            });
        });

        // Cancel button - go back to sequence list
        $("#cancelSequenceAct").click(function() {
            // Hide the sequenceedit tab and show the sequence tab
            $('#maintabs li').removeClass('active');
            $('#maintabs li a[href="#sequenceedit"]').parent().hide();
            $('#maintabs li a[href="#sequence"]').parent().show().addClass('active');
            $('.tab-pane').removeClass('active in');
            $('#sequenceedit').hide();
            $('#sequence').addClass('active in').show();
        });
    });
</script>

<div class="content-box" style="padding-bottom: 1.5em;">
    <h3 id="sequenceedit-title">{{ lang._('Sequence Edit') }}</h3>
    
    <!-- Sequence Settings Form -->
    <div class="row">
        <div class="col-md-6">
            <div class="form-group">
                <label for="sequence_enabled">{{ lang._('Enable') }}</label>
                <select id="sequence_enabled" name="enabled" class="form-control selectpicker">
                    <option value="1">{{ lang._('Yes') }}</option>
                    <option value="0">{{ lang._('No') }}</option>
                </select>
            </div>
        </div>
        <div class="col-md-6">
            <div class="form-group">
                <label for="sequence_name">{{ lang._('Name') }}</label>
                <input type="text" id="sequence_name" name="name" class="form-control" placeholder="{{ lang._('Enter sequence name') }}">
            </div>
        </div>
    </div>
    
    <hr>
    
    <!-- Sequence Steps Table -->
    <h4>{{ lang._('Sequence Steps') }}</h4>
    {{ partial("layout_partials/base_form",['fields':formSequenceSettings,'id':'frm_sequence_settings'])}}
    
    <table id="grid-sequence-steps" class="table table-condensed table-hover table-striped">
        <thead>
            <tr>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                <th data-column-id="order" data-width="8em" data-type="numeric">{{ lang._('Order') }}</th>
                <th data-column-id="step_type" data-width="15em" data-type="string">{{ lang._('Step Type') }}</th>
                <th data-column-id="step_config" data-width="25em" data-type="string">{{ lang._('Configuration') }}</th>
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

    <!-- Action buttons -->
    <div class="col-md-12">
        <hr/>
        <div class="pull-right">
            <button class="btn btn-default" id="cancelSequenceAct" type="button">
                <i class="fa fa-times"></i> <b>{{ lang._('Cancel') }}</b>
            </button>
            <button class="btn btn-primary" id="saveSequenceAct" type="button">
                <i class="fa fa-save"></i> <b>{{ lang._('Save') }}</b> <i id="saveSequenceAct_progress"></i>
            </button>
        </div>
        <div class="clearfix"></div>
        <br/>
    </div>
</div>