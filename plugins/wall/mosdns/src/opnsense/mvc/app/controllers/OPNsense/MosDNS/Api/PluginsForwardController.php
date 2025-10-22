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
            
            // Debug: Log start of search
            error_log("MosDNS Forward Search: Starting search operation");
            
            // First, get data from system config.xml using BaseConfigParser
            // This will now use forward- prefix for forward plugins
            error_log("MosDNS Forward Search: Parsing system config XML");
            $xmlRows = BaseConfigParser::parseSystemConfigXml('Forward', $existingTags);
            error_log("MosDNS Forward Search: Found " . count($xmlRows) . " entries from XML config");
            $rows = array_merge($rows, $xmlRows);
            
            // Second, get data from config.xml (OPNsense model)
            error_log("MosDNS Forward Search: Parsing OPNsense model config");
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.forward.forward');
            if ($node !== null) {
                $modelResult = $this->searchBase('plugins.forward.forward', array('enabled', 'name', 'upstream', 'concurrent'), 'name');
                if (isset($modelResult['rows'])) {
                    error_log("MosDNS Forward Search: Found " . count($modelResult['rows']) . " entries from model config");
                    foreach ($modelResult['rows'] as $row) {
                        // Check if this name already exists in any form (from XML or YAML)
                        if (!in_array($row['name'], $existingTags)) {
                            $rows[] = $row;
                            $existingTags[] = $row['name'];
                        }
                    }
                } else {
                    error_log("MosDNS Forward Search: No rows found in model config");
                }
            } else {
                error_log("MosDNS Forward Search: No forward node found in model");
            }
            
            // Third, parse config.yaml using BaseConfigParser
            // This will now use forward- prefix for forward plugins
            // NOTE: Removed YAML config parsing as per requirement to only use config.xml
            /*
            $yamlConfigPath = '/usr/local/etc/mosdns/config.yaml';
            error_log("MosDNS Forward Search: Checking YAML config at " . $yamlConfigPath);
            if (file_exists($yamlConfigPath)) {
                error_log("MosDNS Forward Search: YAML config file exists, parsing...");
                $yamlContent = file_get_contents($yamlConfigPath);
                if ($yamlContent !== false) {
                    $yamlRows = BaseConfigParser::parseYamlConfig($yamlContent, 'forward', $existingTags);
                    error_log("MosDNS Forward Search: Found " . count($yamlRows) . " entries from YAML config");
                    $rows = array_merge($rows, $yamlRows);
                } else {
                    error_log("MosDNS Forward Search: Failed to read YAML config file");
                }
            } else {
                error_log("MosDNS Forward Search: YAML config file does not exist");
            }
            */
            error_log("MosDNS Forward Search: Total entries found: " . count($rows));
            
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

    public function getForwardAction($uuid = null)
    {
        $this->sessionClose();
        
        if ($uuid === null) {
            // Return default structure for new entries
            return array(
                'forward' => array(
                    'enabled' => '1',
                    'name' => '',
                    'concurrent' => '1',
                    'upstream' => '',
                    'command' => ''
                )
            );
        }
        
        // Check if this is a forward- prefixed UUID (from XML or YAML)
        if (strpos($uuid, 'forward-') === 0) {
            // Handle forward-prefixed entries from XML or YAML
            try {
                $rows = array();
                $existingTags = array();
                
                // First check XML config
                $xmlRows = BaseConfigParser::parseSystemConfigXml('Forward', $existingTags);
                foreach ($xmlRows as $row) {
                    if ($row['uuid'] === $uuid) {
                        return array('forward' => $row);
                    }
                }
                
                // Then check YAML config
                // NOTE: Removed YAML config parsing as per requirement to only use config.xml
                /*
                $yamlConfigPath = '/usr/local/etc/mosdns/config.yaml';
                if (file_exists($yamlConfigPath)) {
                    $yamlContent = file_get_contents($yamlConfigPath);
                    if ($yamlContent !== false) {
                        $yamlRows = BaseConfigParser::parseYamlConfig($yamlContent, 'forward', $existingTags);
                        
                        // Find the specific entry by UUID
                        foreach ($yamlRows as $row) {
                            if ($row['uuid'] === $uuid) {
                                return array('forward' => $row);
                            }
                        }
                    }
                }
                */
                
                // If not found in XML or YAML, return empty
                return array();
                
            } catch (\Exception $e) {
                return array();
            }
        }
        
        // Check if this is a legacy YAML-based UUID (backward compatibility)
        if (strpos($uuid, 'yaml-') === 0) {
            // Handle legacy YAML-based entries
            try {
                $rows = array();
                $existingTags = array();
                
                // Parse config.yaml using BaseConfigParser
                // NOTE: Removed YAML config parsing as per requirement to only use config.xml
                /*
                $yamlConfigPath = '/usr/local/etc/mosdns/config.yaml';
                if (file_exists($yamlConfigPath)) {
                    $yamlContent = file_get_contents($yamlConfigPath);
                    if ($yamlContent !== false) {
                        $yamlRows = BaseConfigParser::parseYamlConfig($yamlContent, 'forward', $existingTags);
                        
                        // Find the specific entry by UUID
                        foreach ($yamlRows as $row) {
                            if ($row['uuid'] === $uuid) {
                                return array('forward' => $row);
                            }
                        }
                    }
                }
                */
                
                // If not found in YAML, return empty
                return array();
                
            } catch (\Exception $e) {
                return array();
            }
        }
        
        // Handle model-based entries using the standard getBase method
        return $this->getBase('forward', 'plugins.forward.forward', $uuid);
    }

    public function setForwardAction($uuid = null)
    {
        return $this->setBase('forward', 'plugins.forward.forward', $uuid);
    }

    public function addForwardAction()
    {
        return $this->addBase('plugins.forward.forward', 'plugins.forward.forward');
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