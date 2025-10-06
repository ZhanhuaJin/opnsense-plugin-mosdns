<?php

/**
 *    Copyright (C) 2023 Deciso B.V.
 *
 *    All rights reserved.
 *
 *    Redistribution and use in source and binary forms, with or without
 *    modification, are permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *    THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 *    AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *    AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 *    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *    POSSIBILITY OF SUCH DAMAGE.
 *
 */

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;

/**
 * Class PluginsRuleController
 * @package OPNsense\MosDNS
 */
class PluginsRuleController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    /**
     * Search rule plugins
     * @return array
     */
    public function searchRuleAction()
    {
        try {
            $rows = array();
            $existingTags = array();
            
            // Debug: Log start of search
            error_log("MosDNS Rule Search: Starting search operation");
            
            // First, get data from system config.xml using BaseConfigParser
            error_log("MosDNS Rule Search: Parsing system config XML");
            $xmlRows = BaseConfigParser::parseSystemConfigXml('Rule', $existingTags);
            error_log("MosDNS Rule Search: Found " . count($xmlRows) . " entries from XML config");
            $rows = array_merge($rows, $xmlRows);
            
            // Second, get data from config.xml (OPNsense model)
            error_log("MosDNS Rule Search: Parsing OPNsense model config");
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.rule.rule');
            if ($node !== null) {
                $modelResult = $this->searchBase('plugins.rule.rule', array('enabled', 'name', 'rule_file'), 'name');
                if (isset($modelResult['rows'])) {
                    error_log("MosDNS Rule Search: Found " . count($modelResult['rows']) . " entries from model config");
                    foreach ($modelResult['rows'] as $row) {
                        if (!in_array($row['name'], $existingTags)) {
                            $rows[] = $row;
                            $existingTags[] = $row['name'];
                        }
                    }
                } else {
                    error_log("MosDNS Rule Search: No rows found in model config");
                }
            } else {
                error_log("MosDNS Rule Search: No rule node found in model");
            }
            
            // Third, parse config.yaml using BaseConfigParser
            $yamlConfigPath = '/usr/local/etc/mosdns/config.yaml';
            error_log("MosDNS Rule Search: Checking YAML config at " . $yamlConfigPath);
            if (file_exists($yamlConfigPath)) {
                error_log("MosDNS Rule Search: YAML config file exists, parsing...");
                $yamlContent = file_get_contents($yamlConfigPath);
                if ($yamlContent !== false) {
                    $yamlRows = BaseConfigParser::parseYamlConfig($yamlContent, 'rule', $existingTags);
                    error_log("MosDNS Rule Search: Found " . count($yamlRows) . " entries from YAML config");
                    $rows = array_merge($rows, $yamlRows);
                } else {
                    error_log("MosDNS Rule Search: Failed to read YAML config file");
                }
            } else {
                error_log("MosDNS Rule Search: YAML config file does not exist");
            }
            
            error_log("MosDNS Rule Search: Total entries found: " . count($rows));
            
            return array(
                'rows' => $rows,
                'rowCount' => count($rows),
                'total' => count($rows),
                'current' => 1
            );
        } catch (\Exception $e) {
            error_log("MosDNS Rule Search: Exception occurred: " . $e->getMessage());
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getRuleAction($uuid = null)
    {
        $this->sessionClose();
        return $this->getBase('rule', 'plugins.rule.rule', $uuid);
    }

    /**
     * Update rule plugin with given properties
     * @param string $uuid item unique id
     * @return array
     */
    public function setRuleAction($uuid = null)
    {
        return $this->setBase('rule', 'plugins.rule.rule', $uuid);
    }

    /**
     * Add new rule plugin and set with given properties
     * @return array
     */
    public function addRuleAction()
    {
        return $this->addBase('rule', 'plugins.rule.rule');
    }

    /**
     * Delete rule plugin by uuid
     * @param string $uuid item unique id
     * @return array
     */
    public function delRuleAction($uuid = null)
    {
        return $this->delBase('plugins.rule.rule', $uuid);
    }

    /**
     * Toggle rule plugin by uuid (enable/disable)
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleRuleAction($uuid = null)
    {
        return $this->toggleBase('plugins.rule.rule', $uuid);
    }
}