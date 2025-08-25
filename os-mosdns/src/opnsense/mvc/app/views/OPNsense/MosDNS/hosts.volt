<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('Hosts configuration will be available in a future update.');
        });

        updateServiceControlUI('mosdns');
    });
</script>

<!-- Hosts Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-list"></i> {{ lang._('Hosts Configuration') }}</h2>
        <p>{{ lang._('Configure custom DNS hosts for MosDNS.') }}</p>
        <p><em>{{ lang._('Hosts configuration interface will be available in a future update.') }}</em></p>
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>