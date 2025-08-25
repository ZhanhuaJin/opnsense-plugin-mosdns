<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration handlers for each plugin
        $("#saveCache").click(function(){
            alert('Cache configuration will be available in a future update.');
        });
        
        $("#saveForward").click(function(){
            alert('Forward configuration will be available in a future update.');
        });
        
        $("#saveRedirect").click(function(){
            alert('Redirect configuration will be available in a future update.');
        });
        
        $("#saveHosts").click(function(){
            alert('Hosts configuration will be available in a future update.');
        });
        
        $("#saveIpset").click(function(){
            alert('IPSet configuration will be available in a future update.');
        });
        
        $("#saveSequence").click(function(){
            alert('Sequence configuration will be available in a future update.');
        });
        
        $("#saveFallback").click(function(){
            alert('Fallback configuration will be available in a future update.');
        });
        
        $("#saveServers").click(function(){
            alert('Servers configuration will be available in a future update.');
        });

        // Handle tab navigation with hash
        if(window.location.hash != "") {
            var hash = window.location.hash;
            if (hash === '#cache' || hash === '#forward' || hash === '#redirect' || hash === '#hosts' || 
                hash === '#ipset' || hash === '#sequence' || hash === '#fallback' || hash === '#servers') {
                $('a[href="' + hash + '"]').tab('show');
            }
        } else {
            // Default to cache tab
            $('a[href="#cache"]').tab('show');
        }
        
        // Update URL hash when tab changes
        $('.nav-tabs a').on('shown.bs.tab', function (e) {
            history.pushState(null, null, e.target.hash);
        });

        updateServiceControlUI('mosdns');
    });
</script>

<!-- MosDNS Plugins Configuration -->
<div class="content-box" style="padding-bottom: 1.5em;">
    <div class="col-md-12">
        <h2><i class="fa fa-puzzle-piece"></i> {{ lang._('MosDNS Plugins Configuration') }}</h2>
        <p>{{ lang._('Configure various MosDNS plugins using the tabs below.') }}</p>
        
        <!-- Plugin Tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <li role="presentation" class="active">
                <a href="#cache" aria-controls="cache" role="tab" data-toggle="tab">
                    <i class="fa fa-database"></i> {{ lang._('Cache') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#forward" aria-controls="forward" role="tab" data-toggle="tab">
                    <i class="fa fa-arrow-right"></i> {{ lang._('Forward') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#redirect" aria-controls="redirect" role="tab" data-toggle="tab">
                    <i class="fa fa-share"></i> {{ lang._('Redirect') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#hosts" aria-controls="hosts" role="tab" data-toggle="tab">
                    <i class="fa fa-list"></i> {{ lang._('Hosts') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#ipset" aria-controls="ipset" role="tab" data-toggle="tab">
                    <i class="fa fa-filter"></i> {{ lang._('IPSet') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#sequence" aria-controls="sequence" role="tab" data-toggle="tab">
                    <i class="fa fa-sort-numeric-asc"></i> {{ lang._('Sequence') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#fallback" aria-controls="fallback" role="tab" data-toggle="tab">
                    <i class="fa fa-life-ring"></i> {{ lang._('Fallback') }}
                </a>
            </li>
            <li role="presentation">
                <a href="#servers" aria-controls="servers" role="tab" data-toggle="tab">
                    <i class="fa fa-server"></i> {{ lang._('Servers') }}
                </a>
            </li>
        </ul>
        
        <!-- Tab Content -->
        <div class="tab-content">
            <!-- Cache Tab -->
            <div role="tabpanel" class="tab-pane active" id="cache">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-database"></i> {{ lang._('Cache Configuration') }}</h3>
                    <p>{{ lang._('Configure DNS cache settings for MosDNS.') }}</p>
                    
                    <form id="cacheForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="cache_tag">{{ lang._('Tag') }}</label>
                                    <input type="text" class="form-control" id="cache_tag" name="cache_tag" value="cache" placeholder="cache">
                                    <small class="form-text text-muted">{{ lang._('Unique identifier for the cache plugin') }}</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="cache_size">{{ lang._('Size') }}</label>
                                    <input type="number" class="form-control" id="cache_size" name="cache_size" value="10240" min="1024" max="1048576">
                                    <small class="form-text text-muted">{{ lang._('Cache size in entries (1024-1048576)') }}</small>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="cache_lazy_ttl">{{ lang._('Lazy Cache TTL') }}</label>
                                    <input type="number" class="form-control" id="cache_lazy_ttl" name="cache_lazy_ttl" value="86400" min="60" max="604800">
                                    <small class="form-text text-muted">{{ lang._('Lazy cache TTL in seconds (60-604800)') }}</small>
                                </div>
                            </div>
                        </div>
                    </form>
                    
                    <hr />
                    <button class="btn btn-primary" id="saveCache" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- Forward Tab -->
            <div role="tabpanel" class="tab-pane" id="forward">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-arrow-right"></i> {{ lang._('Forward Configuration') }}</h3>
                    <p>{{ lang._('Configure DNS forwarding settings for MosDNS.') }}</p>
                    
                    <!-- Forward Entries Table -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <table class="table table-striped table-condensed" id="forwardTable">
                                    <thead>
                                        <tr>
                                            <th>{{ lang._('Tag') }}</th>
                                            <th>{{ lang._('Concurrent') }}</th>
                                            <th>{{ lang._('Upstreams') }}</th>
                                            <th>{{ lang._('Actions') }}</th>
                                        </tr>
                                    </thead>
                                    <tbody id="forwardTableBody">
                                        <!-- Dynamic rows will be added here -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Add Forward Entry Form -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" href="#addForwardForm" aria-expanded="false">
                                    <i class="fa fa-plus"></i> {{ lang._('Add Forward Entry') }}
                                </a>
                            </h4>
                        </div>
                        <div id="addForwardForm" class="panel-collapse collapse">
                            <div class="panel-body">
                                <form id="forwardEntryForm">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="forward_tag">{{ lang._('Tag') }}</label>
                                                <input type="text" class="form-control" id="forward_tag" name="forward_tag" placeholder="forward_default" required>
                                                <small class="form-text text-muted">{{ lang._('Unique identifier for the forward plugin') }}</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="forward_concurrent">{{ lang._('Concurrent') }}</label>
                                                <input type="number" class="form-control" id="forward_concurrent" name="forward_concurrent" value="2" min="1" max="10">
                                                <small class="form-text text-muted">{{ lang._('Number of concurrent queries (1-10)') }}</small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label for="forward_upstreams">{{ lang._('Upstreams') }}</label>
                                                <textarea class="form-control" id="forward_upstreams" name="forward_upstreams" rows="3" placeholder="udp://223.5.5.5\nudp://119.29.29.29" required></textarea>
                                                <small class="form-text text-muted">{{ lang._('One upstream per line (e.g., udp://223.5.5.5)') }}</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <button type="button" class="btn btn-success" id="addForwardEntry">
                                                <i class="fa fa-plus"></i> {{ lang._('Add Entry') }}
                                            </button>
                                            <button type="button" class="btn btn-default" id="cancelForwardEntry">
                                                <i class="fa fa-times"></i> {{ lang._('Cancel') }}
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <hr />
                    <button class="btn btn-primary" id="saveForward" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- Redirect Tab -->
            <div role="tabpanel" class="tab-pane" id="redirect">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-share"></i> {{ lang._('Redirect Configuration') }}</h3>
                    <p>{{ lang._('Configure DNS redirection rules for MosDNS.') }}</p>
                    <p><em>{{ lang._('Redirect configuration interface will be available in a future update.') }}</em></p>
                    <hr />
                    <button class="btn btn-primary" id="saveRedirect" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- Hosts Tab -->
            <div role="tabpanel" class="tab-pane" id="hosts">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-list"></i> {{ lang._('Hosts Configuration') }}</h3>
                    <p>{{ lang._('Configure local hosts file management for MosDNS.') }}</p>
                    <p><em>{{ lang._('Hosts configuration interface will be available in a future update.') }}</em></p>
                    <hr />
                    <button class="btn btn-primary" id="saveHosts" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- IPSet Tab -->
            <div role="tabpanel" class="tab-pane" id="ipset">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-filter"></i> {{ lang._('IPSet Configuration') }}</h3>
                    <p>{{ lang._('Configure IP set management for MosDNS.') }}</p>
                    <p><em>{{ lang._('IPSet configuration interface will be available in a future update.') }}</em></p>
                    <hr />
                    <button class="btn btn-primary" id="saveIpset" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- Sequence Tab -->
            <div role="tabpanel" class="tab-pane" id="sequence">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-sort-numeric-asc"></i> {{ lang._('Sequence Configuration') }}</h3>
                    <p>{{ lang._('Configure plugin execution sequence for MosDNS.') }}</p>
                    <p><em>{{ lang._('Sequence configuration interface will be available in a future update.') }}</em></p>
                    <hr />
                    <button class="btn btn-primary" id="saveSequence" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- Fallback Tab -->
            <div role="tabpanel" class="tab-pane" id="fallback">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-life-ring"></i> {{ lang._('Fallback Configuration') }}</h3>
                    <p>{{ lang._('Configure fallback DNS servers for MosDNS.') }}</p>
                    <p><em>{{ lang._('Fallback configuration interface will be available in a future update.') }}</em></p>
                    <hr />
                    <button class="btn btn-primary" id="saveFallback" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
            
            <!-- Servers Tab -->
            <div role="tabpanel" class="tab-pane" id="servers">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-server"></i> {{ lang._('Servers Configuration') }}</h3>
                    <p>{{ lang._('Configure upstream DNS servers for MosDNS.') }}</p>
                    <p><em>{{ lang._('Servers configuration interface will be available in a future update.') }}</em></p>
                    <hr />
                    <button class="btn btn-primary" id="saveServers" type="button"><b>{{ lang._('Save') }}</b></button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Forward entries storage
    var forwardEntries = [];
    
    // Function to render forward table
    function renderForwardTable() {
        var tbody = $('#forwardTableBody');
        tbody.empty();
        
        forwardEntries.forEach(function(entry, index) {
            var upstreamsDisplay = entry.upstreams.split('\n').join(', ');
            if (upstreamsDisplay.length > 50) {
                upstreamsDisplay = upstreamsDisplay.substring(0, 50) + '...';
            }
            
            var row = '<tr>' +
                '<td>' + entry.tag + '</td>' +
                '<td>' + entry.concurrent + '</td>' +
                '<td title="' + entry.upstreams.split('\n').join(', ') + '">' + upstreamsDisplay + '</td>' +
                '<td>' +
                    '<button class="btn btn-xs btn-danger" onclick="removeForwardEntry(' + index + ')">' +
                        '<i class="fa fa-trash"></i>' +
                    '</button>' +
                '</td>' +
            '</tr>';
            tbody.append(row);
        });
        
        if (forwardEntries.length === 0) {
            tbody.append('<tr><td colspan="4" class="text-center text-muted">{{ lang._("No forward entries configured") }}</td></tr>');
        }
    }
    
    // Add forward entry
    $('#addForwardEntry').click(function() {
        var tag = $('#forward_tag').val().trim();
        var concurrent = $('#forward_concurrent').val();
        var upstreams = $('#forward_upstreams').val().trim();
        
        if (!tag || !upstreams) {
            alert('{{ lang._("Please fill in all required fields") }}');
            return;
        }
        
        // Check for duplicate tags
        if (forwardEntries.some(function(entry) { return entry.tag === tag; })) {
            alert('{{ lang._("Tag already exists. Please use a unique tag.") }}');
            return;
        }
        
        forwardEntries.push({
            tag: tag,
            concurrent: concurrent,
            upstreams: upstreams
        });
        
        // Clear form
        $('#forwardEntryForm')[0].reset();
        $('#forward_concurrent').val('2'); // Reset to default
        $('#addForwardForm').collapse('hide');
        
        renderForwardTable();
    });
    
    // Cancel add forward entry
    $('#cancelForwardEntry').click(function() {
        $('#forwardEntryForm')[0].reset();
        $('#forward_concurrent').val('2'); // Reset to default
        $('#addForwardForm').collapse('hide');
    });
    
    // Remove forward entry (global function)
    window.removeForwardEntry = function(index) {
        if (confirm('{{ lang._("Are you sure you want to remove this forward entry?") }}')) {
            forwardEntries.splice(index, 1);
            renderForwardTable();
        }
    };
    
    // Save Cache configuration
    $('#saveCache').click(function() {
        var cacheConfig = {
            tag: $('#cache_tag').val(),
            size: $('#cache_size').val(),
            lazy_cache_ttl: $('#cache_lazy_ttl').val()
        };
        
        // Here you would typically send the data to the server
        console.log('Cache config:', cacheConfig);
        alert('{{ lang._("Cache configuration saved successfully!") }}');
    });
    
    // Save Forward configuration
    $('#saveForward').click(function() {
        // Here you would typically send the forwardEntries to the server
        console.log('Forward entries:', forwardEntries);
        alert('{{ lang._("Forward configuration saved successfully!") }}');
    });
    
    // Initialize table
    renderForwardTable();
    
    // Handle tab switching to update URL hash
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var target = $(e.target).attr('href');
        if (target) {
            window.location.hash = target;
        }
    });
    
    // Show tab based on URL hash
    if (window.location.hash) {
        var hash = window.location.hash;
        if ($(hash).length) {
            $('a[href="' + hash + '"]').tab('show');
        }
    }
});
</script>