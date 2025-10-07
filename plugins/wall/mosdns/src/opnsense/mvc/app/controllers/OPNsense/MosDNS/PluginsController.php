<?php

/**
 * Copyright (C) 2023 Deciso B.V.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 * OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

namespace OPNsense\MosDNS;

use OPNsense\Base\ControllerBase;

/**
 * Class PluginsController
 * @package OPNsense\MosDNS
 */
class PluginsController extends ControllerBase
{
    public function indexAction()
    {
        // Set page title for the plugins overview page
        $this->view->title = "MosDNS Plugins";
        
        // Load form definitions for dialog boxes
        $this->view->formDialogEditForward = $this->getForm("dialog_forward");
        $this->view->formDialogEditRedirect = $this->getForm("dialog_redirect");
        $this->view->formDialogEditRules = $this->getForm("dialog_rules");
        $this->view->formDialogEditHosts = $this->getForm("dialog_hosts");
        $this->view->formDialogEditIPSet = $this->getForm("dialog_ipset");
        $this->view->formDialogEditSequence = $this->getForm("dialog_sequence");
        $this->view->formDialogEditFallback = $this->getForm("dialog_fallback");
        $this->view->formDialogEditServers = $this->getForm("dialog_servers");
        $this->view->formDialogEditCache = $this->getForm("dialog_cache");
        
        // Generate grid configurations for tables
        $this->view->formGridForward = $this->getFormGrid('dialog_forward');
        $this->view->formGridRedirect = $this->getFormGrid('dialog_redirect');
        $this->view->formGridRules = $this->getFormGrid('dialog_rules');
        $this->view->formGridHosts = $this->getFormGrid('dialog_hosts');
        $this->view->formGridIPSet = $this->getFormGrid('dialog_ipset');
        $this->view->formGridSequence = $this->getFormGrid('dialog_sequence');
        $this->view->formGridFallback = $this->getFormGrid('dialog_fallback');
        $this->view->formGridServers = $this->getFormGrid('dialog_servers');
        $this->view->formGridCache = $this->getFormGrid('dialog_cache');
        
        $this->view->pick('OPNsense/MosDNS/plugins');
    }



    /**
     * Main plugins page with iframe-based design
     * This provides a cleaner architecture where each plugin runs in its own iframe
     * eliminating timing issues with tab switching and UIBootgrid initialization
     */
    public function mainAction()
    {
        // Set page title for the plugins main page with iframe layout
        $this->view->title = "MosDNS Plugins Main";
        $this->view->pick('OPNsense/MosDNS/plugins_main');
    }

    // Bare versions for iframe embedding (without layout)
    public function forwardBareAction()
    {
        // Completely disable all view rendering to prevent any OPNsense framework
        $this->view->disable();
        
        // Disable response auto-rendering
        $this->response->setHeader('Content-Type', 'text/html; charset=UTF-8');
        
        // Get form data
        $formDialogForward = $this->getForm("dialogForward");
        $formGridForward = $this->getFormGrid('dialogForward');
        
        // Get template path
        $templatePath = $this->view->getViewsDir() . 'forward_bare.volt';
        
        // Initialize Volt engine
        $volt = new \Phalcon\Mvc\View\Engine\Volt($this->view, $this->di);
        $volt->setOptions([
            'compiledPath' => sys_get_temp_dir() . '/',
            'compiledSeparator' => '_'
        ]);
        
        // Create a simple lang function for translations
        $langFunction = function($key) {
            // Simple translation - in a real implementation you'd use proper translation service
            $translations = [
                'Forward Settings' => 'Forward Settings',
                'ID' => 'ID',
                'Enabled' => 'Enabled',
                'Name' => 'Name',
                'Concurrent' => 'Concurrent',
                'Upstreams' => 'Upstreams',
                'Commands' => 'Commands',
                'Edit Forward Entry' => 'Edit Forward Entry'
            ];
            return isset($translations[$key]) ? $translations[$key] : $key;
        };
        
        // Set template variables
        $templateVars = [
            'formDialogForward' => $formDialogForward,
            'formGridForward' => $formGridForward,
            'lang' => (object)['_' => $langFunction]
        ];
        
        // Render template
        $content = $volt->render($templatePath, $templateVars);
        
        // Output content directly and stop execution
        $this->response->setContent($content);
        $this->response->send();
        exit();
    }

    public function cacheBareAction()
    {
        $this->view->disable();
        echo $this->renderBareCachePage();
        return false;
    }
    
    private function renderBareCachePage()
    {
        return '<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cache Settings</title>
    <link rel="stylesheet" type="text/css" href="/ui/css/jquery.bootgrid.css" />
    <script src="/ui/js/jquery-3.5.1.min.js"></script>
    <script src="/ui/js/bootstrap.min.js"></script>
    <script src="/ui/js/opnsense.js"></script>
    <script src="/ui/js/opnsense_ui.js"></script>
    <script src="/ui/js/jquery.bootgrid.js"></script>
    <script src="/ui/js/opnsense_bootgrid_plugin.js"></script>
    <style>
        body { 
            margin: 0; 
            padding: 15px; 
            background: #fff; 
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        }
        .content-box { 
            border: none; 
            box-shadow: none; 
            margin: 0; 
            padding: 0; 
        }
        h2 { 
            margin-top: 0; 
            color: #333;
        }
    </style>
</head>
<body>
    <div class="content-box">
        <div class="table-responsive">
            <div class="col-sm-12">
                <h2>Cache Settings</h2>
                <hr/>
            </div>
            <div>
                <form id="frm_CacheDialog">
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-12">
        <table id="grid-cache" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogCache">
            <thead>
            <tr>
                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">Enabled</th>
                <th data-column-id="tag" data-type="string">Tag</th>
                <th data-column-id="size" data-type="string">Size</th>
                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">Commands</th>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">ID</th>
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
    </div>

    <script>
    // CSRF Token Setup for iframe
    function setupAjaxWithCSRF(csrfToken) {
        if (csrfToken) {
            $.ajaxSetup({
                beforeSend: function(xhr, settings) {
                    if (!/^(GET|HEAD|OPTIONS|TRACE)$/i.test(settings.type) && !this.crossDomain) {
                        xhr.setRequestHeader("X-CSRFToken", csrfToken);
                    }
                }
            });
            console.log("CSRF token set for Cache page:", csrfToken);
        }
    }

    // Listen for CSRF token from parent window
    window.addEventListener("message", function(event) {
        if (event.data && (event.data.type === "csrf-token" || event.data.type === "csrf_token")) {
            var csrfToken = event.data.token || event.data.csrf;
            if (csrfToken) {
                setupAjaxWithCSRF(csrfToken);
            }
        }
    }, false);

    // Try to get CSRF token from parent window if available
    if (window.parent && window.parent !== window) {
        try {
            var parentMeta = window.parent.document.querySelector("meta[name=\\"csrf-token\\"]");
            if (parentMeta) {
                setupAjaxWithCSRF(parentMeta.getAttribute("content"));
            } else {
                var parentInput = window.parent.document.querySelector("input[name=\\"csrf\\"]");
                if (parentInput) {
                    setupAjaxWithCSRF(parentInput.value);
                } else if (window.parent.csrfToken) {
                    setupAjaxWithCSRF(window.parent.csrfToken);
                }
            }
        } catch(e) {
            console.log("Could not access parent window for CSRF token");
        }
        
        // Request CSRF token from parent
        window.parent.postMessage({type: "request_csrf_token"}, "*");
    }

        $(document).ready(function() {
            $("#grid-cache").UIBootgrid({
                search: "/api/mosdns/plugins/searchCache",
                get: "/api/mosdns/plugins/getCache/",
                set: "/api/mosdns/plugins/setCache/",
                add: "/api/mosdns/plugins/addCache/",
                del: "/api/mosdns/plugins/delCache/",
                toggle: "/api/mosdns/plugins/toggleCache/"
            });

            var cacheInitialized = false;
            function initializeCache() {
                if (!cacheInitialized) {
                    $("#grid-cache").bootgrid("reload");
                    cacheInitialized = true;
                }
            }

            if (window.parent !== window) {
                setTimeout(initializeCache, 500);
            } else {
                initializeCache();
            }
        });
    </script>
</body>
</html>';
    }

    public function redirectBareAction()
    {
        $this->view->disable();
        echo $this->renderBareRedirectPage();
        return false;
    }
    
    private function renderBareRedirectPage()
    {
        return '<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Redirect Settings</title>
    <link rel="stylesheet" type="text/css" href="/ui/css/jquery.bootgrid.css" />
    <script src="/ui/js/jquery-3.5.1.min.js"></script>
    <script src="/ui/js/bootstrap.min.js"></script>
    <script src="/ui/js/opnsense.js"></script>
    <script src="/ui/js/opnsense_ui.js"></script>
    <script src="/ui/js/jquery.bootgrid.js"></script>
    <script src="/ui/js/opnsense_bootgrid_plugin.js"></script>
    <style>
        body { 
            margin: 0; 
            padding: 15px; 
            background: #fff; 
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        }
        .content-box { 
            border: none; 
            box-shadow: none; 
            margin: 0; 
            padding: 0; 
        }
        h2 { 
            margin-top: 0; 
            color: #333;
        }
    </style>
</head>
<body>
    <div class="content-box">
        <div class="table-responsive">
            <div class="col-sm-12">
                <h2>Redirect Settings</h2>
                <hr/>
            </div>
        </div>
    </div>

    <div class="col-md-12">
        <table id="grid-redirect" class="table table-condensed table-hover table-striped table-responsive" data-editDialog="DialogRedirect">
            <thead>
            <tr>
                <th data-column-id="enabled" data-width="6em" data-type="string" data-formatter="rowtoggle">Enabled</th>
                <th data-column-id="tag" data-type="string">Tag</th>
                <th data-column-id="addr" data-type="string">Address</th>
                <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">Commands</th>
                <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">ID</th>
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
    </div>

    <script>
    var csrfTokenReceived = false;
    var gridInitialized = false;

    // CSRF Token Setup for iframe
    function setupAjaxWithCSRF(csrfToken) {
        if (csrfToken) {
            $.ajaxSetup({
                beforeSend: function(xhr, settings) {
                    if (!/^(GET|HEAD|OPTIONS|TRACE)$/i.test(settings.type) && !this.crossDomain) {
                        xhr.setRequestHeader("X-CSRFToken", csrfToken);
                    }
                }
            });
            console.log("CSRF token set for Redirect page:", csrfToken);
            csrfTokenReceived = true;
            initializeGridIfReady();
        }
    }

    function initializeGridIfReady() {
        if (csrfTokenReceived && !gridInitialized) {
            gridInitialized = true;
            $("#grid-redirect").UIBootgrid({
                search: "/api/mosdns/plugins/searchRedirect",
                get: "/api/mosdns/plugins/getRedirect/",
                set: "/api/mosdns/plugins/setRedirect/",
                add: "/api/mosdns/plugins/addRedirect/",
                del: "/api/mosdns/plugins/delRedirect/",
                toggle: "/api/mosdns/plugins/toggleRedirect/"
            });
        }
    }

    // Listen for CSRF token from parent window
    window.addEventListener("message", function(event) {
        if (event.data && (event.data.type === "csrf-token" || event.data.type === "csrf_token")) {
            var csrfToken = event.data.token || event.data.csrf;
            if (csrfToken) {
                setupAjaxWithCSRF(csrfToken);
            }
        }
    }, false);

    // Try to get CSRF token from parent window if available
    if (window.parent && window.parent !== window) {
        try {
            var parentMeta = window.parent.document.querySelector("meta[name=\\"csrf-token\\"]");
            if (parentMeta) {
                setupAjaxWithCSRF(parentMeta.getAttribute("content"));
            } else {
                var parentInput = window.parent.document.querySelector("input[name=\\"csrf\\"]");
                if (parentInput) {
                    setupAjaxWithCSRF(parentInput.value);
                } else if (window.parent.csrfToken) {
                    setupAjaxWithCSRF(window.parent.csrfToken);
                }
            }
        } catch(e) {
            console.log("Could not access parent window for CSRF token");
        }
        
        // Request CSRF token from parent
        window.parent.postMessage({type: "request_csrf_token"}, "*");
    }

        $(document).ready(function() {
            // Add a fallback timeout in case CSRF token is not received
            setTimeout(function() {
                if (!csrfTokenReceived) {
                    console.warn("CSRF token not received, initializing grid anyway");
                    csrfTokenReceived = true;
                    initializeGridIfReady();
                }
            }, 1000);
            
            initializeGridIfReady();
        });
    </script>
</body>
</html>';
    }

    public function rulesBareAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_LAYOUT);
        $this->view->formDialogRules = $this->getForm("dialogRules");
        $this->view->formGridRules = $this->getFormGrid('dialogRules');
        $this->view->pick('OPNsense/MosDNS/rules');
    }

    public function hostsBareAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_LAYOUT);
        $this->view->formDialogHosts = $this->getForm("dialogHosts");
        $this->view->formGridHosts = $this->getFormGrid('dialogHosts');
        $this->view->pick('OPNsense/MosDNS/hosts');
    }

    public function ipsetBareAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_LAYOUT);
        $this->view->formDialogIPSet = $this->getForm("dialogIPSet");
        $this->view->formGridIPSet = $this->getFormGrid('dialogIPSet');
        $this->view->pick('OPNsense/MosDNS/ipset');
    }

    public function sequenceBareAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_LAYOUT);
        $this->view->formDialogSequence = $this->getForm("dialogSequence");
        $this->view->formGridSequence = $this->getFormGrid('dialogSequence');
        $this->view->pick('OPNsense/MosDNS/sequence');
    }

    public function fallbackBareAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_LAYOUT);
        $this->view->formDialogFallback = $this->getForm("dialogFallback");
        $this->view->formGridFallback = $this->getFormGrid('dialogFallback');
        $this->view->pick('OPNsense/MosDNS/fallback');
    }

    public function serversBareAction()
    {
        $this->view->disableLevel(\Phalcon\Mvc\View::LEVEL_LAYOUT);
        $this->view->formDialogServers = $this->getForm("dialogServers");
        $this->view->formGridServers = $this->getFormGrid('dialogServers');
        $this->view->pick('OPNsense/MosDNS/servers');
    }

    /**
     * Forward edit action - handles the forward edit page
     */
    public function forwardAction()
    {
        $this->view->title = "MosDNS Forward Configuration";
        $this->view->pick('OPNsense/MosDNS/plugins_forward');
    }

    /**
     * Forward edit action - handles the forward edit page
     */
    public function editAction($uuid = null)
    {
        $this->view->title = "Edit MosDNS Forward Configuration";
        
        // Load the forward settings form
        $this->view->formForwardSettings = $this->getForm("plugins_forward");
        
        // Load the upstream dialog form
        $this->view->formDialogUpstream = $this->getForm("dialog_forwardupstream");
        
        // Pass the UUID to the view if provided
        if ($uuid !== null) {
            $this->view->uuid = $uuid;
        }
        
        $this->view->pick('OPNsense/MosDNS/plugins_forwardedit');
    }
}