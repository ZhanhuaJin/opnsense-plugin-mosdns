<script>
    $( document ).ready(function() {
        var data_get_map = {'frm_sequence':'/api/mosdns/sequence/get'};
        mapDataToFormUI(data_get_map).done(function(data){
            formatTokenizersUI();
            $('.selectpicker').selectpicker('refresh');
        });

        // link save button to API set action
        $("#saveAct").click(function(){
            saveFormToEndpoint(url="/api/mosdns/sequence/set", formid='frm_sequence',callback_ok=function(){
                $("#saveAct_progress").addClass("fa fa-spinner fa-pulse");
                ajaxCall(url="/api/mosdns/service/reconfigure", sendData={}, callback=function(data,status) {
                    updateServiceControlUI('mosdns');
                    $("#saveAct_progress").removeClass("fa fa-spinner fa-pulse");
                });
            });
        });

        // update history on tab state and implement navigation
        if(window.location.hash != "") {
            $('a[href="' + window.location.hash + '"]').click()
        }
        $('.nav-tabs a').on('shown.bs.tab', function (e) {
            history.pushState(null, null, e.target.hash);
        });

        updateServiceControlUI('mosdns');
    });
</script>

<script>
$(document).ready(function() {
    // Initialize sequence plugins grid
    $("#grid-sequence-plugins").UIBootgrid(
        {
            'search':'/api/mosdns/sequence/searchItem',
            'get':'/api/mosdns/sequence/getItem/',
            'set':'/api/mosdns/sequence/setItem/',
            'add':'/api/mosdns/sequence/addItem/',
            'del':'/api/mosdns/sequence/delItem/',
            'toggle':'/api/mosdns/sequence/toggleItem/'
        }
    );

    // Add new sequence plugin
    $("#addSequencePlugin").click(function(){
        $("#DialogSequence").modal('show');
    });

    // Save sequence plugin
    $("#saveSequencePlugin").click(function(){
        saveFormToEndpoint('/api/mosdns/sequence/addItem', 'frm_DialogSequence', function(){
            $("#DialogSequence").modal('hide');
            $("#grid-sequence-plugins").bootgrid('reload');
        });
    });

    // Add sequence step
    $("#addStep").click(function(){
        var stepHtml = '<div class="step-item form-group">' +
            '<div class="row">' +
            '<div class="col-md-10">' +
            '<textarea class="form-control" name="sequence[steps][]" rows="2" placeholder="exec: $forward_local\nmatches: has_resp\nexec: accept"></textarea>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<button type="button" class="btn btn-danger remove-step"><i class="fa fa-trash"></i></button>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#steps-container").append(stepHtml);
    });

    // Remove sequence step
    $(document).on('click', '.remove-step', function(){
        $(this).closest('.step-item').remove();
    });
});
</script>

<!-- Sequence Plugins Grid -->
<div class="tab-content content-box tab-content">
    <div class="content-box" style="padding-bottom: 1.5em;">
        <div class="table-responsive">
            <div class="col-sm-12">
                <div class="pull-right">
                    <button id="addSequencePlugin" type="button" class="btn btn-default">
                        <span class="fa fa-plus"></span> {{ lang._('Add Sequence Plugin') }}
                    </button>
                </div>
            </div>
            <div class="col-sm-12">
                <table id="grid-sequence-plugins" class="table table-condensed table-hover table-striped" data-editDialog="DialogSequence">
                    <thead>
                        <tr>
                            <th data-column-id="enabled" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                            <th data-column-id="tag" data-type="string">{{ lang._('Tag') }}</th>
                            <th data-column-id="steps" data-type="string">{{ lang._('Steps') }}</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Sequence Plugin Dialog -->
<div class="modal fade" id="DialogSequence" tabindex="-1" role="dialog" aria-labelledby="DialogSequenceLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="DialogSequenceLabel">{{ lang._('Sequence Plugin') }}</h4>
            </div>
            <div class="modal-body">
                <form id="frm_DialogSequence">
                    <div class="form-group">
                        <label for="sequence_enabled">{{ lang._('Enabled') }}</label>
                        <input type="checkbox" id="sequence_enabled" name="sequence[enabled]" value="1">
                    </div>
                    <div class="form-group">
                        <label for="sequence_tag">{{ lang._('Tag') }}</label>
                        <input type="text" class="form-control" id="sequence_tag" name="sequence[tag]" placeholder="{{ lang._('Enter sequence tag') }}">
                    </div>
                    <div class="form-group">
                        <label>{{ lang._('Sequence Steps') }}</label>
                        <div id="steps-container">
                            <div class="step-item form-group">
                                <div class="row">
                                    <div class="col-md-10">
                                        <textarea class="form-control" name="sequence[steps][]" rows="2" placeholder="exec: $forward_local"></textarea>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-danger remove-step"><i class="fa fa-trash"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success" id="addStep">
                            <i class="fa fa-plus"></i> {{ lang._('Add Step') }}
                        </button>
                    </div>
                    <div class="alert alert-info">
                        <strong>{{ lang._('Note:') }}</strong> {{ lang._('Each step can contain exec commands, matches conditions, or other sequence operations. Use YAML format for complex steps.') }}
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ lang._('Cancel') }}</button>
                <button type="button" class="btn btn-primary" id="saveSequencePlugin">{{ lang._('Save') }}</button>
            </div>
        </div>
    </div>
</div>