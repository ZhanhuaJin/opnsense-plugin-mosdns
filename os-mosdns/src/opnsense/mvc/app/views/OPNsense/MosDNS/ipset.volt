<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('IPSet configuration will be available in a future update.');
        });

        updateServiceControlUI('mosdns');
    });
</script>

<!-- IPSet Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-filter"></i> {{ lang._('IPSet Configuration') }}</h2>
        <p>{{ lang._('Configure IPSet filtering for MosDNS.') }}</p>
        <p><em>{{ lang._('IPSet configuration interface will be available in a future update.') }}</em></p>
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>