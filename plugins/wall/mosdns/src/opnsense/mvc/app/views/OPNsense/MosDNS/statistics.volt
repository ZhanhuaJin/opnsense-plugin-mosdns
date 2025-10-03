<script>
    $( document ).ready(function() {
        // Load statistics on page load
        loadStatistics();
        
        // Refresh statistics every 30 seconds
        setInterval(loadStatistics, 30000);
        
        // Manual refresh button
        $("#refreshStatsAct").click(function(){
            loadStatistics();
        });
        
        function loadStatistics() {
            ajaxCall(url="/api/mosdns/service/status", sendData={}, callback=function(data,status) {
                if (data && data.status) {
                    $("#statsContent").html(
                        '<div class="row">' +
                        '<div class="col-md-6">' +
                        '<h4>Service Status</h4>' +
                        '<p><strong>Status:</strong> ' + (data.status.running ? 'Running' : 'Stopped') + '</p>' +
                        '<p><strong>PID:</strong> ' + (data.status.pid || 'N/A') + '</p>' +
                        '</div>' +
                        '</div>'
                    );
                } else {
                    $("#statsContent").html('<p>Unable to load statistics</p>');
                }
            });
        }
    });
</script>

<!-- Statistics -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="table-responsive">
        <div class="col-sm-12">
            <h2>{{ lang._('MosDNS Statistics') }}</h2>
            <div class="row">
                <div class="col-xs-12">
                    <button class="btn btn-default" id="refreshStatsAct" type="button"><b>{{ lang._('Refresh Statistics') }}</b></button>
                    <br/><br/>
                    <div id="statsContent" style="background-color: #f5f5f5; padding: 15px; border-radius: 5px;">
                        <p>Loading statistics...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>