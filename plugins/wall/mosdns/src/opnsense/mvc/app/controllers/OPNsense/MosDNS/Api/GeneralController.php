<?php

/**
 * Copyright (C) 2024 Deciso B.V.
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

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\Core\Config;

/**
 * Class GeneralController
 * @package OPNsense\MosDNS\Api
 */
class GeneralController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\\OPNsense\\MosDNS\\MosDNS';

    /**
     * Get general settings
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $mdlMosDNS = $this->getModel();
            $result['mosdns'] = $mdlMosDNS->getNodes();
        }
        return $result;
    }

    /**
     * Set general settings
     * @return array
     */
    public function setAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $mdlMosDNS = $this->getModel();
            $mdlMosDNS->setNodes($this->request->getPost("mosdns"));
            $valMsgs = $mdlMosDNS->performValidation();
            foreach ($valMsgs as $field => $msg) {
                $result["validations"]["mosdns." . $msg->getField()] = $msg->getMessage();
            }
            if (count($valMsgs) == 0) {
                $mdlMosDNS->serializeToConfig();
                $result["result"] = "saved";
            }
        }
        return $result;
    }

    /**
     * Reconfigure service
     * @return array
     */
    public function reconfigureAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("template reload OPNsense/MosDNS");
            if (trim($response) == "OK") {
                $response = $backend->configdRun("mosdns restart");
                $result["result"] = trim($response) == "OK" ? "reconfigured" : "failed";
            }
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Get service status
     * @return array
     */
    public function statusAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns status");
            $result["status"] = trim($response);
        }
        return $result;
    }

    /**
     * Start service
     * @return array
     */
    public function startAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns start");
            $result["result"] = trim($response) == "OK" ? "started" : "failed";
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Stop service
     * @return array
     */
    public function stopAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns stop");
            $result["result"] = trim($response) == "OK" ? "stopped" : "failed";
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Restart service
     * @return array
     */
    public function restartAction()
    {
        $result = array("result" => "failed");
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = $backend->configdRun("mosdns restart");
            $result["result"] = trim($response) == "OK" ? "restarted" : "failed";
            $result["response"] = $response;
        }
        return $result;
    }

    /**
     * Import YAML configuration
     * @return array
     */
    public function importYamlAction()
    {
        $result = array("result" => "failed");
        
        if ($this->request->isPost()) {
            try {
                $yamlContent = $this->request->getPost("yaml");
                
                if (empty($yamlContent)) {
                    $result["message"] = "YAML content is empty";
                    return $result;
                }
                
                // Parse YAML content
                if (!function_exists('yaml_parse')) {
                    // Fallback to simple parsing if yaml extension is not available
                    $result["message"] = "YAML parsing extension not available";
                    return $result;
                }
                
                $yamlData = yaml_parse($yamlContent);
                if ($yamlData === false) {
                    $result["message"] = "Invalid YAML format";
                    return $result;
                }
                
                // Get the current model
                $mdlMosDNS = $this->getModel();
                
                // Convert YAML data to model structure
                $this->convertYamlToModel($yamlData, $mdlMosDNS);
                
                // Validate the model
                $valMsgs = $mdlMosDNS->performValidation();
                if (count($valMsgs) > 0) {
                    $errors = array();
                    foreach ($valMsgs as $field => $msg) {
                        $errors[] = $msg->getField() . ": " . $msg->getMessage();
                    }
                    $result["message"] = "Validation errors: " . implode(", ", $errors);
                    return $result;
                }
                
                // Save to config
                $mdlMosDNS->serializeToConfig();
                
                // Reconfigure service
                $backend = new Backend();
                $backend->configdRun("template reload OPNsense/MosDNS");
                
                $result["result"] = "ok";
                $result["message"] = "YAML configuration imported successfully";
                
            } catch (\Exception $e) {
                $result["message"] = "Error importing YAML: " . $e->getMessage();
            }
        }
        
        return $result;
    }
    
    /**
     * Convert YAML data to model structure
     * @param array $yamlData
     * @param object $model
     */
    private function convertYamlToModel($yamlData, $model)
    {
        // Generate UUID helper function
        $generateUuid = function() {
            return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
                mt_rand(0, 0xffff), mt_rand(0, 0xffff),
                mt_rand(0, 0xffff),
                mt_rand(0, 0x0fff) | 0x4000,
                mt_rand(0, 0x3fff) | 0x8000,
                mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
            );
        };

        // Handle general settings
        if (isset($yamlData['log'])) {
            if (isset($yamlData['log']['level'])) {
                $model->general->loglevel = $yamlData['log']['level'];
            }
        }
        
        // Handle plugins section
        if (isset($yamlData['plugins'])) {
            $plugins = $yamlData['plugins'];
            
            // Handle cache plugins
            if (isset($plugins['cache'])) {
                foreach ($plugins['cache'] as $cache) {
                    if (isset($cache['tag'])) {
                        $model->plugins->cache->enabled = "1";
                        if (isset($cache['size'])) {
                            $model->plugins->cache->size = $cache['size'];
                        }
                        if (isset($cache['lazy_cache_ttl'])) {
                            $model->plugins->cache->lazy_cache_ttl = $cache['lazy_cache_ttl'];
                        }
                    }
                }
            }
            
            // Handle forward plugins
            if (isset($plugins['forward'])) {
                $forwardItems = $model->plugins->forward->forward;
                $forwardItems->del(); // Clear existing items
                
                foreach ($plugins['forward'] as $forward) {
                    $uuid = $generateUuid();
                    $forwardNode = $forwardItems->add();
                    $forwardNode->setAttributeValue('uuid', $uuid);
                    
                    $forwardNode->enabled = isset($forward['enabled']) ? ($forward['enabled'] ? "1" : "0") : "1";
                    $forwardNode->name = isset($forward['tag']) ? $forward['tag'] : 'forward_' . substr($uuid, 0, 8);
                    
                    if (isset($forward['concurrent'])) {
                        $forwardNode->concurrent = $forward['concurrent'];
                    }
                    
                    if (isset($forward['upstreams'])) {
                        $upstreams = is_array($forward['upstreams']) ? implode(',', $forward['upstreams']) : $forward['upstreams'];
                        $forwardNode->upstreams = $upstreams;
                    }
                }
            }
            
            // Handle sequence plugins
            if (isset($plugins['sequence'])) {
                $sequenceItems = $model->plugins->sequence->sequence;
                $sequenceItems->del(); // Clear existing items
                
                foreach ($plugins['sequence'] as $sequence) {
                    $uuid = $generateUuid();
                    $sequenceNode = $sequenceItems->add();
                    $sequenceNode->setAttributeValue('uuid', $uuid);
                    
                    $sequenceNode->enabled = isset($sequence['enabled']) ? ($sequence['enabled'] ? "1" : "0") : "1";
                    $sequenceNode->name = isset($sequence['tag']) ? $sequence['tag'] : 'sequence_' . substr($uuid, 0, 8);
                    
                    if (isset($sequence['exec'])) {
                        $exec = is_array($sequence['exec']) ? implode(',', $sequence['exec']) : $sequence['exec'];
                        $sequenceNode->exec = $exec;
                    }
                }
            }
            
            // Handle redirect plugins
            if (isset($plugins['redirect'])) {
                $redirectItems = $model->plugins->redirect->redirect;
                $redirectItems->del(); // Clear existing items
                
                foreach ($plugins['redirect'] as $redirect) {
                    $uuid = $generateUuid();
                    $redirectNode = $redirectItems->add();
                    $redirectNode->setAttributeValue('uuid', $uuid);
                    
                    $redirectNode->enabled = isset($redirect['enabled']) ? ($redirect['enabled'] ? "1" : "0") : "1";
                    $redirectNode->name = isset($redirect['tag']) ? $redirect['tag'] : 'redirect_' . substr($uuid, 0, 8);
                    
                    if (isset($redirect['rules'])) {
                        $rules = is_array($redirect['rules']) ? implode(',', $redirect['rules']) : $redirect['rules'];
                        $redirectNode->rules = $rules;
                    }
                }
            }
            
            // Handle hosts plugins
            if (isset($plugins['hosts'])) {
                $hostsItems = $model->plugins->hosts->hosts;
                $hostsItems->del(); // Clear existing items
                
                foreach ($plugins['hosts'] as $hosts) {
                    $uuid = $generateUuid();
                    $hostsNode = $hostsItems->add();
                    $hostsNode->setAttributeValue('uuid', $uuid);
                    
                    $hostsNode->enabled = isset($hosts['enabled']) ? ($hosts['enabled'] ? "1" : "0") : "1";
                    $hostsNode->name = isset($hosts['tag']) ? $hosts['tag'] : 'hosts_' . substr($uuid, 0, 8);
                    
                    if (isset($hosts['entries'])) {
                        $entries = is_array($hosts['entries']) ? implode(',', $hosts['entries']) : $hosts['entries'];
                        $hostsNode->entries = $entries;
                    }
                }
            }
            
            // Handle servers plugins
            if (isset($plugins['servers'])) {
                $serversItems = $model->plugins->servers->servers;
                $serversItems->del(); // Clear existing items
                
                foreach ($plugins['servers'] as $servers) {
                    $uuid = $generateUuid();
                    $serversNode = $serversItems->add();
                    $serversNode->setAttributeValue('uuid', $uuid);
                    
                    $serversNode->enabled = isset($servers['enabled']) ? ($servers['enabled'] ? "1" : "0") : "1";
                    $serversNode->name = isset($servers['tag']) ? $servers['tag'] : 'servers_' . substr($uuid, 0, 8);
                    
                    if (isset($servers['listen'])) {
                        $listen = is_array($servers['listen']) ? implode(',', $servers['listen']) : $servers['listen'];
                        $serversNode->listen = $listen;
                    }
                    
                    if (isset($servers['entry'])) {
                        $serversNode->entry = $servers['entry'];
                    }
                }
            }
        }
    }
}