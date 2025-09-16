<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('{{PLUGIN_NAME}} configuration will be available in a future update.');
        });

        updateServiceControlUI('mosdns');
    });
</script>

<!-- {{PLUGIN_NAME}} Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa {{ICON_CLASS}}"></i> {{ lang._('{{PLUGIN_TITLE}}') }}</h2>
        <p>{{ lang._('Configure {{PLUGIN_NAME}} settings for MosDNS.') }}</p>
        <p><em>{{ lang._('{{PLUGIN_NAME}} configuration interface will be available in a future update.') }}</em></p>
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>