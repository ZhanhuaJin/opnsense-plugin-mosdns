<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration (placeholder)
        $("#saveAct").click(function(){
            // TODO: Implement save functionality when forms are available
            alert('Cache configuration will be available in a future update.');
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

<div class="tab-content content-box tab-content">
    <div id="cache" class="tab-pane fade in active">
        <div class="content-box" style="padding-bottom: 1.5em;">
            {{ partial("layout_partials/base_form",['fields':cacheForm,'id':'frm_cache'])}} 
            <div class="col-md-12">
                <hr />
                <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
            </div>
        </div>
    </div>
</div>



<!-- Cache Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-database"></i> {{ lang._('Cache Configuration') }}</h2>
        <p>{{ lang._('Configure DNS cache settings for MosDNS.') }}</p>
        <p><em>{{ lang._('Cache configuration interface will be available in a future update.') }}</em></p>
        <hr />
        <button class="btn btn-primary" id="saveAct" type="button"><b>{{ lang._('Save') }}</b> <i id="saveAct_progress"></i></button>
    </div>
</div>