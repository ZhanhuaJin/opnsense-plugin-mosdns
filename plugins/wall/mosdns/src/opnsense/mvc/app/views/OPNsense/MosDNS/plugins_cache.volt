<div id="cache" class="tab-pane fade">
<div class="content-box" style="padding-bottom: 1.5em;">
    <h3><i class="fa fa-database"></i> {{ lang._('Cache Configuration') }}</h3>
    <p>{{ lang._('Configure DNS cache settings for MosDNS.') }}</p>
    
    {{ partial("layout_partials/base_form", ['fields': formCacheSettings, 'id': 'frm_cache_settings']) }}
    
    <!-- Save button for Cache configuration -->
    <div class="col-md-12">
        <hr/>
        <div class="pull-right">
            <button class="btn btn-primary" id="saveCacheAct"
                    data-endpoint='/api/mosdns/plugins/saveCache'
                    data-label="{{ lang._('Save') }}"
                    data-error-title="{{ lang._('Error saving Cache configuration') }}"
                    type="button">
                <i class="fa fa-save"></i> <b>{{ lang._('Save Cache') }}</b> <i id="saveCacheAct_progress"></i>
            </button>
        </div>
        <div class="clearfix"></div>
        <br/>
    </div>

<script>
$(document).ready(function() {
    // Initialize Save button
    $("#saveCacheAct").SimpleActionButton();
});
</script>
</div>
</div>

<!-- Dialog for Cache -->
{{ partial("layout_partials/base_dialog",['fields':formDialogEditCache,'id':'dialogCache','label':lang._('Edit Cache')])}}