<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('Sequence configuration will be available in a future update.');
        });

        updateServiceControlUI('mosdns');
    });
</script>

<!-- Sequence Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-sort-numeric-asc"></i> {{ lang._('Sequence Configuration') }}</h2>
        <p>{{ lang._('Configure execution sequence for MosDNS plugins.') }}</p>
        <p><em>{{ lang._('Sequence configuration interface will be available in a future update.') }}</em></p>
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>