<script>
    $( document ).ready(function() {
        // Load logs on page load
        loadLogs();
        
        // Manual refresh button
        $("#refreshLogAct").click(function(){
            loadLogs();
        });
        
        function loadLogs() {
            ajaxCall(url="/api/mosdns/service/log", sendData={}, callback=function(data,status) {
                if (data && data.log) {
                    $("#logContent").text(data.log);
                } else {
                    $("#logContent").text('No logs available');
                }
            });
        }
    });
</script>

<!-- Log Viewer -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="table-responsive">
        <div class="col-sm-12">
            <h2>{{ lang._('Service Logs') }}</h2>
            <div class="row">
                <div class="col-xs-12">
                    <button class="btn btn-default" id="refreshLogAct" type="button"><b>{{ lang._('Refresh Log') }}</b></button>
                    <br/><br/>
                    <pre id="logContent" style="height: 400px; overflow-y: scroll; background-color: #f5f5f5; padding: 10px; border-radius: 5px;">Loading logs...</pre>
                </div>
            </div>
        </div>
    </div>
</div>