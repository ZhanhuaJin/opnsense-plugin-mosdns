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
use OPNsense\MosDNS\MosDNS;

/**
 * Class PluginsForwardController
 * @package OPNsense\MosDNS\Api
 */
class PluginsForwardController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    // Forward plugin methods
    public function searchForwardAction()
    {
        try {
            $rows = array();
            $existingTags = array();
            
            // First, get data from system config.xml (OPNsense system configuration)
            $xmlRows = $this->parseSystemConfigXml($existingTags);
            $rows = array_merge($rows, $xmlRows);
            
            // Second, get data from config.xml (OPNsense model)
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.forward.forward');
            if ($node !== null) {
                $modelResult = $this->searchBase('plugins.forward.forward', array('enabled', 'name', 'upstream', 'concurrent', 'command'), 'name');
                if (isset($modelResult['rows'])) {
                    foreach ($modelResult['rows'] as $row) {
                        if (!in_array($row['name'], $existingTags)) {
                            $rows[] = $row;
                            $existingTags[] = $row['name'];
                        }
                    }
                }
            }
            
            // Third, parse config.yaml for additional forward configurations
            $yamlConfigPath = '/usr/local/etc/mosdns/config.yaml';
            if (file_exists($yamlConfigPath)) {
                $yamlContent = file_get_contents($yamlConfigPath);
                if ($yamlContent !== false) {
                    $yamlRows = $this->parseYamlForwardConfig($yamlContent, $existingTags);
                    $rows = array_merge($rows, $yamlRows);
                }
            }
            
            return array(
                'rows' => $rows,
                'rowCount' => count($rows),
                'total' => count($rows),
                'current' => 1
            );
        } catch (\Exception $e) {
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }
    
    /**
     * Parse system config.xml for MosDNS forward configurations
     * @param array $existingTags
     * @return array
     */
    private function parseSystemConfigXml(&$existingTags)
    {
        $rows = array();
        
        try {
            global $config;
            
            // Check if MosDNS configuration exists in system config
            if (isset($config['OPNsense']['MosDNS']['Plugins']['Forward'])) {
                $forwardConfigs = $config['OPNsense']['MosDNS']['Plugins']['Forward'];
                
                // Handle both single and multiple forward configurations
                if (!isset($forwardConfigs[0])) {
                    $forwardConfigs = array($forwardConfigs);
                }
                
                foreach ($forwardConfigs as $forward) {
                    if (isset($forward['tag']) && !empty($forward['tag'])) {
                        $tagName = $forward['tag'];
                        if (!in_array($tagName, $existingTags)) {
                            $rows[] = array(
                                'uuid' => 'xml-' . md5($tagName),
                                'enabled' => isset($forward['enabled']) ? $forward['enabled'] : '1',
                                'name' => $tagName,
                                'upstream' => isset($forward['upstream']) ? $forward['upstream'] : '',
                                'concurrent' => isset($forward['concurrent']) ? (string)$forward['concurrent'] : '1',
                                'command' => isset($forward['command']) ? $forward['command'] : ''
                            );
                            $existingTags[] = $tagName;
                        }
                    }
                }
            }
            
        } catch (\Exception $e) {
            // If XML parsing fails, just return empty array
        }
        
        return $rows;
    }
    
    /**
     * Parse YAML config file for forward plugin configurations
     * @param string $yamlContent
     * @param array $existingTags
     * @return array
     */
    private function parseYamlForwardConfig($yamlContent, $existingTags = array())
    {
        $rows = array();
        
        try {
            // Simple YAML parsing for forward plugins
            $lines = explode("\n", $yamlContent);
            $inPlugins = false;
            $currentPlugin = null;
            $pluginData = array();
            
            foreach ($lines as $line) {
                $line = trim($line);
                
                if ($line === 'plugins:') {
                    $inPlugins = true;
                    continue;
                }
                
                if (!$inPlugins) {
                    continue;
                }
                
                // Check for new plugin definition
                if (preg_match('/^- tag:\s*(.+)$/', $line, $matches)) {
                    // Save previous plugin if it was a forward type
                    if ($currentPlugin && isset($pluginData['type']) && $pluginData['type'] === 'forward') {
                        $tagName = $pluginData['tag'];
                        if (!in_array($tagName, $existingTags)) {
                            $rows[] = array(
                                'uuid' => 'yaml-' . md5($tagName),
                                'enabled' => '1',
                                'name' => $tagName,
                                'upstream' => isset($pluginData['upstream']) ? implode("\n", $pluginData['upstream']) : '',
                                'concurrent' => isset($pluginData['concurrent']) ? (string)$pluginData['concurrent'] : '1',
                                'command' => ''
                            );
                        }
                    }
                    
                    // Start new plugin
                    $currentPlugin = trim($matches[1]);
                    $pluginData = array('tag' => $currentPlugin);
                    continue;
                }
                
                // Parse plugin properties
                if ($currentPlugin) {
                    if (preg_match('/^type:\s*(.+)$/', $line, $matches)) {
                        $pluginData['type'] = trim($matches[1]);
                    } elseif (preg_match('/^concurrent:\s*(\d+)$/', $line, $matches)) {
                        $pluginData['concurrent'] = intval($matches[1]);
                    } elseif (preg_match('/^- (.+)$/', $line, $matches) && isset($pluginData['type']) && $pluginData['type'] === 'forward') {
                        // This is likely an upstream server
                        if (!isset($pluginData['upstream'])) {
                            $pluginData['upstream'] = array();
                        }
                        $pluginData['upstream'][] = trim($matches[1]);
                    }
                }
                
                // Reset if we hit a new section
                if (preg_match('/^[a-zA-Z_]+:$/', $line) && $line !== 'plugins:' && $line !== 'args:') {
                    $inPlugins = false;
                }
            }
            
            // Don't forget the last plugin
            if ($currentPlugin && isset($pluginData['type']) && $pluginData['type'] === 'forward') {
                $tagName = $pluginData['tag'];
                if (!in_array($tagName, $existingTags)) {
                    $rows[] = array(
                        'uuid' => 'yaml-' . md5($tagName),
                        'enabled' => '1',
                        'name' => $tagName,
                        'upstream' => isset($pluginData['upstream']) ? implode("\n", $pluginData['upstream']) : '',
                        'concurrent' => isset($pluginData['concurrent']) ? (string)$pluginData['concurrent'] : '1',
                        'command' => ''
                    );
                }
            }
            
        } catch (\Exception $e) {
            // If YAML parsing fails, just return empty array
        }
        
        return $rows;
    }

    public function getForwardAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('forward', 'plugins.forward.forward', $uuid);
    }

    public function setForwardAction($uuid = null)
    {
        return $this->setBase('forward', 'plugins.forward.forward', $uuid);
    }

    public function addForwardAction()
    {
        return $this->addBase('forward', 'plugins.forward.forward');
    }

    public function delForwardAction($uuid = null)
    {
        return $this->delBase('plugins.forward.forward', $uuid);
    }

    public function toggleForwardAction($uuid = null)
    {
        return $this->toggleBase('plugins.forward.forward', $uuid);
    }
}