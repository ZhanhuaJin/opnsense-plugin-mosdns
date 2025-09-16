<script>
    $( document ).ready(function() {
        // Initialize selectpickers
        $('.selectpicker').selectpicker('refresh');

        // Save configuration handlers for each plugin
        $("#saveCache").click(function(){
            alert('Cache configuration will be available in a future update.');
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
                    
                    <table id="forwardGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogForward">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="concurrent" data-type="string">{{ lang._('Concurrent') }}</th>
                                <th data-column-id="upstreams" data-type="string">{{ lang._('Upstreams') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
            
            <!-- Redirect Tab -->
            <div role="tabpanel" class="tab-pane" id="redirect">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-share"></i> {{ lang._('Redirect Configuration') }}</h3>
                    <p>{{ lang._('Configure DNS redirection rules for MosDNS.') }}</p>
                    
                    <table id="redirectGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogRedirect">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="rules" data-type="string">{{ lang._('Rules') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
            
            <!-- Hosts Tab -->
            <div role="tabpanel" class="tab-pane" id="hosts">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-list"></i> {{ lang._('Hosts Configuration') }}</h3>
                    <p>{{ lang._('Configure local hosts file management for MosDNS.') }}</p>
                    
                    <table id="hostsGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogHosts">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="files" data-type="string">{{ lang._('Files') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
            
            <!-- IPSet Tab -->
            <div role="tabpanel" class="tab-pane" id="ipset">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-filter"></i> {{ lang._('IPSet Configuration') }}</h3>
                    <p>{{ lang._('Configure IP set management for MosDNS.') }}</p>
                    
                    <table id="ipsetGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogIpset">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="files" data-type="string">{{ lang._('Files') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
            
            <!-- Sequence Tab -->
            <div role="tabpanel" class="tab-pane" id="sequence">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-sort-numeric-asc"></i> {{ lang._('Sequence Configuration') }}</h3>
                    <p>{{ lang._('Configure plugin execution sequence for MosDNS.') }}</p>
                    
                    <table id="sequenceGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogSequence">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="exec" data-type="string">{{ lang._('Exec') }}</th>
                                <th data-column-id="matches" data-type="string">{{ lang._('Matches') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
            
            <!-- Fallback Tab -->
            <div role="tabpanel" class="tab-pane" id="fallback">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-life-ring"></i> {{ lang._('Fallback Configuration') }}</h3>
                    <p>{{ lang._('Configure fallback DNS servers for MosDNS.') }}</p>
                    
                    <table id="fallbackGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogFallback">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="primary" data-type="string">{{ lang._('Primary') }}</th>
                                <th data-column-id="secondary" data-type="string">{{ lang._('Secondary') }}</th>
                                <th data-column-id="threshold" data-type="string">{{ lang._('Threshold') }}</th>
                                <th data-column-id="always_standby" data-type="string">{{ lang._('Always Standby') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
            
            <!-- Servers Tab -->
            <div role="tabpanel" class="tab-pane" id="servers">
                <div class="content-box" style="padding-top: 1.5em;">
                    <h3><i class="fa fa-server"></i> {{ lang._('Servers Configuration') }}</h3>
                    <p>{{ lang._('Configure upstream DNS servers for MosDNS.') }}</p>
                    
                    <table id="serversGrid" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="dialogServers">
                        <thead>
                            <tr>
                                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">{{ lang._('ID') }}</th>
                                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">{{ lang._('Enabled') }}</th>
                                <th data-column-id="name" data-type="string">{{ lang._('Name') }}</th>
                                <th data-column-id="entry" data-type="string">{{ lang._('Entry') }}</th>
                                <th data-column-id="listen" data-type="string">{{ lang._('Listen') }}</th>
                                <th data-column-id="udp_or_tcp" data-type="string">{{ lang._('UDP or TCP') }}</th>
                                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">{{ lang._('Commands') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td>
                                    <button data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                    <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                    
                    <div class="col-md-12">
                        <hr />
                        <button class="btn btn-primary" id="reconfigureAct" type="button"><b>{{ lang._('Apply') }}</b></button>
                        <br /><br />
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Track initialized grids to avoid duplicate initialization
    var gridInited = {};
    
    // Grid configurations for lazy loading
    var gridConfigs = {
        '#cache': {
            gridId: '#cacheGrid',
            config: {
                search:'/api/mosdns/cache/searchItem',
                get:'/api/mosdns/cache/getItem/',
                set:'/api/mosdns/cache/setItem/',
                add:'/api/mosdns/cache/addItem/',
                del:'/api/mosdns/cache/delItem/',
                toggle:'/api/mosdns/cache/toggleItem/'
            }
        },
        '#forward': {
            gridId: '#forwardGrid',
            config: {
                search:'/api/mosdns/forward/searchItem',
                get:'/api/mosdns/forward/getItem/',
                set:'/api/mosdns/forward/setItem/',
                add:'/api/mosdns/forward/addItem/',
                del:'/api/mosdns/forward/delItem/',
                toggle:'/api/mosdns/forward/toggleItem/'
            }
        },
        '#redirect': {
            gridId: '#redirectGrid',
            config: {
                search:'/api/mosdns/redirect/searchItem',
                get:'/api/mosdns/redirect/getItem/',
                set:'/api/mosdns/redirect/setItem/',
                add:'/api/mosdns/redirect/addItem/',
                del:'/api/mosdns/redirect/delItem/',
                toggle:'/api/mosdns/redirect/toggleItem/'
            }
        },
        '#hosts': {
            gridId: '#hostsGrid',
            config: {
                search:'/api/mosdns/hosts/searchItem',
                get:'/api/mosdns/hosts/getItem/',
                set:'/api/mosdns/hosts/setItem/',
                add:'/api/mosdns/hosts/addItem/',
                del:'/api/mosdns/hosts/delItem/',
                toggle:'/api/mosdns/hosts/toggleItem/'
            }
        },
        '#ipset': {
            gridId: '#ipsetGrid',
            config: {
                search:'/api/mosdns/ipset/searchItem',
                get:'/api/mosdns/ipset/getItem/',
                set:'/api/mosdns/ipset/setItem/',
                add:'/api/mosdns/ipset/addItem/',
                del:'/api/mosdns/ipset/delItem/',
                toggle:'/api/mosdns/ipset/toggleItem/'
            }
        },
        '#sequence': {
            gridId: '#sequenceGrid',
            config: {
                search:'/api/mosdns/sequence/searchItem',
                get:'/api/mosdns/sequence/getItem/',
                set:'/api/mosdns/sequence/setItem/',
                add:'/api/mosdns/sequence/addItem/',
                del:'/api/mosdns/sequence/delItem/',
                toggle:'/api/mosdns/sequence/toggleItem/'
            }
        },
        '#fallback': {
            gridId: '#fallbackGrid',
            config: {
                search:'/api/mosdns/fallback/searchItem',
                get:'/api/mosdns/fallback/getItem/',
                set:'/api/mosdns/fallback/setItem/',
                add:'/api/mosdns/fallback/addItem/',
                del:'/api/mosdns/fallback/delItem/',
                toggle:'/api/mosdns/fallback/toggleItem/'
            }
        },
        '#servers': {
            gridId: '#serversGrid',
            config: {
                search:'/api/mosdns/servers/searchItem',
                get:'/api/mosdns/servers/getItem/',
                set:'/api/mosdns/servers/setItem/',
                add:'/api/mosdns/servers/addItem/',
                del:'/api/mosdns/servers/delItem/',
                toggle:'/api/mosdns/servers/toggleItem/'
            }
        }
    };
    
    // Function to clear all grid containers to prevent content overlap
    function clearAllGrids() {
        console.log('Clearing all grid containers to prevent overlap');
        Object.keys(gridConfigs).forEach(function(tabId) {
            var gridConfig = gridConfigs[tabId];
            var $gridElement = $(gridConfig.gridId);
            if ($gridElement.length) {
                try {
                    // Clear the grid content
                    $gridElement.empty();
                    // Reset bootgrid if it exists
                    if ($gridElement.data('bootgrid')) {
                        $gridElement.bootgrid('destroy');
                    }
                } catch (error) {
                    console.warn('Error clearing grid:', gridConfig.gridId, error);
                }
            }
        });
        // Reset all initialization flags
        Object.keys(gridInited).forEach(function(key) {
            gridInited[key] = false;
        });
    }

    // Function to initialize grid for a specific tab with enhanced error handling
    function initGridByTab(tabId) {
        // Validate input parameters
        if (!tabId || !gridConfigs[tabId]) {
            console.log('Skipping initialization for', tabId, '- invalid parameters');
            return;
        }
        
        // Skip if already initialized and working properly
        if (gridInited[tabId]) {
            var gridConfig = gridConfigs[tabId];
            var $gridElement = $(gridConfig.gridId);
            if ($gridElement.length && $gridElement.find('tbody tr').length > 0) {
                console.log('Grid already initialized and has content:', tabId);
                return;
            }
        }
        
        var gridConfig = gridConfigs[tabId];
        var $gridElement = $(gridConfig.gridId);
        var $tabPane = $(tabId); // This is the tab content pane
        
        // Enhanced DOM readiness checks
        if (!$gridElement.length) {
            console.warn('Grid element not found:', gridConfig.gridId);
            return;
        }
        
        if (!$tabPane.length) {
            console.warn('Tab pane not found:', tabId);
            return;
        }
        
        // Check if tab pane is active (correct way to check tab visibility)
        if (!$tabPane.hasClass('active') && !$tabPane.hasClass('show')) {
            console.log('Tab pane not active, skipping initialization:', tabId);
            return;
        }
        
        // Check if grid container is visible
        if ($gridElement.is(':hidden') || $tabPane.is(':hidden')) {
            console.log('Grid or tab pane hidden, delaying initialization:', tabId);
            // Retry after a short delay
            setTimeout(function() {
                if (!gridInited[tabId]) {
                    console.log('Retrying initialization for:', tabId);
                    initGridByTab(tabId);
                }
            }, 400);
            return;
        }
        
        try {
            // Clear the specific grid before initialization
            console.log('Clearing grid before initialization:', tabId);
            $gridElement.empty();
            if ($gridElement.data('bootgrid')) {
                $gridElement.bootgrid('destroy');
            }
            
            // Add additional delay for API readiness
            setTimeout(function() {
                try {
                    // Initialize the grid with enhanced error handling
                    console.log('Initializing grid for tab:', tabId);
                    
                    // Add enhanced error handling for UIBootgrid initialization
                    $gridElement.UIBootgrid($.extend(gridConfig.config, {
                        ajax: true,
                        requestHandler: function(request) {
                            console.log('Grid request for', tabId, ':', request);
                            return request;
                        },
                        responseHandler: function(response) {
                            console.log('Grid response for', tabId, ':', response);
                            // Handle various error conditions
                            if (!response || response.error || response.status === 'error') {
                                console.warn('Error response for', tabId, ', returning empty data');
                                return { current: 1, rowCount: 0, rows: [], total: 0 };
                            }
                            // Ensure response has required structure
                            if (!response.rows) {
                                response.rows = [];
                            }
                            if (!response.total) {
                                response.total = 0;
                            }
                            return response;
                        },
                        failureHandler: function(jqXHR, textStatus, errorThrown) {
                            console.warn('Grid request failed for', tabId, ':', textStatus, errorThrown, jqXHR.status);
                            // Suppress all error dialogs and return empty data
                            if (jqXHR.status === 404 || jqXHR.status === 500 || textStatus === 'error') {
                                console.log('Suppressing error dialog for', tabId, 'and initializing empty grid');
                                // Force grid to show with empty data
                                setTimeout(function() {
                                    try {
                                        $gridElement.bootgrid('reload');
                                    } catch (e) {
                                        console.warn('Failed to reload grid after error:', e);
                                    }
                                }, 100);
                                return false; // Prevent default error handling
                            }
                            return true; // Allow default error handling for other errors
                        },
                        // Ensure buttons are always rendered
                        formatters: {
                            "commands": function(column, row) {
                                return "<button type=\"button\" class=\"btn btn-xs btn-default command-edit bootgrid-tooltip\" data-row-id=\"" + row.uuid + "\"><span class=\"fa fa-pencil\"></span></button> " +
                                       "<button type=\"button\" class=\"btn btn-xs btn-default command-copy bootgrid-tooltip\" data-row-id=\"" + row.uuid + "\"><span class=\"fa fa-clone\"></span></button> " +
                                       "<button type=\"button\" class=\"btn btn-xs btn-default command-delete bootgrid-tooltip\" data-row-id=\"" + row.uuid + "\"><span class=\"fa fa-trash-o\"></span></button>";
                            },
                            "rowtoggle": function(column, row) {
                                var checked = row[column.id] == "1" ? "checked" : "";
                                return "<input type=\"checkbox\" class=\"bootgrid-tooltip\" data-toggle=\"tooltip\" data-placement=\"left\" title=\"" + (checked ? "disable" : "enable") + " this item\" data-row-id=\"" + row.uuid + "\" " + checked + ">";
                            }
                        }
                    }));
                    
                    gridInited[tabId] = true;
                    console.log('Grid initialized successfully:', tabId);
                } catch (initError) {
                    console.error('Error during grid initialization for', tabId, ':', initError);
                    
                    // Try to recover by clearing and retrying once
                    if (!gridInited[tabId + '_retry']) {
                        console.log('Attempting recovery for:', tabId);
                        gridInited[tabId + '_retry'] = true;
                        
                        setTimeout(function() {
                            try {
                                $gridElement.empty();
                                $gridElement.UIBootgrid(gridConfig.config);
                                gridInited[tabId] = true;
                                console.log('Grid recovery successful for:', tabId);
                            } catch (retryError) {
                                console.error('Grid recovery failed for', tabId, ':', retryError);
                                gridInited[tabId] = false;
                            }
                        }, 300);
                    } else {
                        gridInited[tabId] = false;
                    }
                }
            }, 100);
            
        } catch (error) {
            console.error('Error initializing grid for', tabId, ':', error);
            // Reset the flag to allow retry
            gridInited[tabId] = false;
        }
    }
    
    // Enhanced tab event binding with better timing and error handling
    $(document).ready(function() {
        // Wait for DOM to be fully ready
        setTimeout(function() {
            // Bind tab events with multiple selectors for compatibility
            $('a[data-toggle="tab"], a[data-bs-toggle="tab"]').on('shown.bs.tab shown.tab', function (e) {
                var targetId = $(e.target).attr('href');
                console.log('Tab shown event triggered for:', targetId);
                
                // Clear all grids first to prevent overlap
                clearAllGrids();
                
                // Force the tab pane to be active before initializing
                var $targetPane = $(targetId);
                if ($targetPane.length) {
                    // Hide all other tab panes first
                    $('.tab-pane').removeClass('active show');
                    
                    // Ensure the target tab pane has the correct classes
                    $targetPane.addClass('active show');
                    
                    // Add a longer delay to ensure DOM is fully updated and API is ready
                    setTimeout(function() {
                        console.log('Attempting to initialize grid for:', targetId);
                        initGridByTab(targetId);
                    }, 500);
                }
                
                // Update URL hash with error handling
                try {
                    if (history.pushState) {
                        history.pushState(null, null, targetId);
                    } else {
                        window.location.hash = targetId;
                    }
                } catch (error) {
                    console.warn('Failed to update URL hash:', error);
                }
            });
            
            // Also bind to the 'show.bs.tab' event to handle pre-activation
            $('a[data-toggle="tab"], a[data-bs-toggle="tab"]').on('show.bs.tab show.tab', function (e) {
                var targetId = $(e.target).attr('href');
                console.log('Tab show event (before activation) for:', targetId);
                
                // Pre-clear grids to ensure clean state
                clearAllGrids();
            });
            
            // Initialize the first active tab or default tab
            var initialTab = window.location.hash || '#cache';
            var $initialTabLink = $('a[href="' + initialTab + '"]');
            
            if ($initialTabLink.length) {
                // Clear all grids first
                clearAllGrids();
                
                // Activate the tab first
                $initialTabLink.tab('show');
                
                // Ensure the tab pane is properly activated
                var $initialPane = $(initialTab);
                if ($initialPane.length) {
                    $('.tab-pane').removeClass('active show');
                    $initialPane.addClass('active show');
                }
                
                // Then initialize its grid with a longer delay
                setTimeout(function() {
                    console.log('Initializing initial tab:', initialTab);
                    initGridByTab(initialTab);
                }, 600);
            } else {
                // Fallback to first tab
                var $firstTab = $('a[data-toggle="tab"], a[data-bs-toggle="tab"]').first();
                if ($firstTab.length) {
                    var firstTabId = $firstTab.attr('href');
                    
                    // Clear all grids first
                    clearAllGrids();
                    
                    $firstTab.tab('show');
                    
                    // Ensure the tab pane is properly activated
                    var $firstPane = $(firstTabId);
                    if ($firstPane.length) {
                        $('.tab-pane').removeClass('active show');
                        $firstPane.addClass('active show');
                    }
                    
                    setTimeout(function() {
                        console.log('Initializing fallback tab:', firstTabId);
                        initGridByTab(firstTabId);
                    }, 600);
                }
            }
        }, 200);
    });
});
</script>