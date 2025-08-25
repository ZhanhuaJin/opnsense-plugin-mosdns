<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('Redirect configuration will be available in a future update.');
        });

        updateServiceControlUI('mosdns');
    });
</script>

<!-- Redirect Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-share"></i> {{ lang._('Redirect Configuration') }}</h2>
        <p>{{ lang._('Configure DNS redirect settings for MosDNS.') }}</p>
        <p><em>{{ lang._('Redirect configuration interface will be available in a future update.') }}</em></p>
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>