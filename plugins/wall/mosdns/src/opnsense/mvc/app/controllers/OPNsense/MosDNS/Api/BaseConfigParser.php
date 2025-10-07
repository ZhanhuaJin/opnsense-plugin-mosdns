<?php

/**
 * Copyright (C) 2023 Wall
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

/**
 * Base configuration parser for MosDNS plugins
 * Provides common methods for parsing XML and YAML configurations
 */
class BaseConfigParser
{
    /**
     * Parse system config.xml for MosDNS plugin configurations
     * @param string $pluginType Plugin type (e.g., 'Forward', 'Redirect', 'Hosts', etc.)
     * @param array $existingTags Reference to existing tags array
     * @return array
     */
    public static function parseSystemConfigXml($pluginType, &$existingTags)
    {
        $rows = array();
        
        try {
            $config = \OPNsense\Core\Config::getInstance()->object();
            
            // Check if MosDNS configuration exists in system config
            $configPath = "OPNsense->MosDNS->Plugins->{$pluginType}";
            if (isset($config->OPNsense->MosDNS->Plugins->{$pluginType})) {
                $pluginConfigs = $config->OPNsense->MosDNS->Plugins->{$pluginType};
                
                // Handle both single and multiple plugin configurations
                if (!is_array($pluginConfigs)) {
                    $pluginConfigs = array($pluginConfigs);
                }
                
                foreach ($pluginConfigs as $plugin) {
                    if (isset($plugin->tag) && !empty($plugin->tag)) {
                        $tagName = (string)$plugin->tag;
                        if (!in_array($tagName, $existingTags)) {
                            // Use forward- prefix for forward plugin type, otherwise use xml- prefix
                            $uuidPrefix = (strtolower($pluginType) === 'forward') ? 'forward-' : 'xml-';
                            $row = array(
                                'uuid' => $uuidPrefix . md5($tagName),
                                'enabled' => isset($plugin->enabled) ? (string)$plugin->enabled : '1',
                                'name' => $tagName,
                                'command' => isset($plugin->command) ? (string)$plugin->command : ''
                            );
                            
                            // Add plugin-specific fields based on type
                            $row = array_merge($row, self::getPluginSpecificFields($pluginType, $plugin));
                            
                            $rows[] = $row;
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
     * Parse YAML config file for plugin configurations
     * @param string $yamlContent YAML file content
     * @param string $pluginType Plugin type to filter (e.g., 'forward', 'redirect', 'hosts', etc.)
     * @param array $existingTags Existing tags to avoid duplicates
     * @return array
     */
    public static function parseYamlConfig($yamlContent, $pluginType, $existingTags = array())
    {
        $rows = array();
        
        try {
            // Parse YAML using yaml_parse if available, otherwise use simple parsing
            if (function_exists('yaml_parse')) {
                $yamlData = yaml_parse($yamlContent);
            } else {
                $yamlData = self::parseYamlSimple($yamlContent);
            }
            
            if (!isset($yamlData['plugins']) || !is_array($yamlData['plugins'])) {
                return $rows;
            }
            
            foreach ($yamlData['plugins'] as $plugin) {
                if (!isset($plugin['tag']) || !isset($plugin['type'])) {
                    continue;
                }
                
                if (self::isMatchingPluginType($plugin, $pluginType)) {
                    $tagName = $plugin['tag'];
                    if (!in_array($tagName, $existingTags)) {
                        // Use forward- prefix for forward plugin type, otherwise use yaml- prefix
                        $uuidPrefix = (strtolower($pluginType) === 'forward') ? 'forward-' : 'yaml-';
                        $row = array(
                            'uuid' => $uuidPrefix . md5($tagName),
                            'enabled' => '1',
                            'name' => $tagName,
                            'command' => ''
                        );
                        
                        // Add plugin-specific fields based on type
                        $row = array_merge($row, self::getYamlPluginSpecificFields($pluginType, $plugin));
                        
                        $rows[] = $row;
                    }
                }
            }
            
        } catch (\Exception $e) {
            // If YAML parsing fails, just return empty array
        }
        
        return $rows;
    }

    /**
     * Simple YAML parser for basic structures
     * @param string $yamlContent YAML content
     * @return array
     */
    private static function parseYamlSimple($yamlContent)
    {
        $result = array();
        $lines = explode("\n", $yamlContent);
        $currentPlugin = null;
        $inPlugins = false;
        $inArgs = false;
        $inUpstreams = false;
        $pluginIndent = 0;
        $argsIndent = 0;
        $upstreamsIndent = 0;
        
        error_log("MosDNS YAML Debug: Starting parseYamlSimple");
        
        foreach ($lines as $lineNum => $line) {
            $originalLine = $line;
            $line = rtrim($line);
            
            if (empty($line) || (isset($line[0]) && $line[0] === '#')) {
                continue;
            }
            
            // Count indentation
            $indent = strlen($line) - strlen(ltrim($line));
            $line = ltrim($line);
            
            error_log("MosDNS YAML Debug: Line " . ($lineNum + 1) . ": '$originalLine' (indent: $indent, inPlugins: " . ($inPlugins ? 'true' : 'false') . ", inArgs: " . ($inArgs ? 'true' : 'false') . ", inUpstreams: " . ($inUpstreams ? 'true' : 'false') . ")");
            
            // Handle plugins array
            if ($line === 'plugins:') {
                $result['plugins'] = array();
                $inPlugins = true;
                error_log("MosDNS YAML Debug: Found plugins section");
                continue;
            }
            
            if (!$inPlugins) {
                continue;
            }
            
            // Handle array items with - prefix for upstreams (inside args)
            if (preg_match('/^-\s+(.*)$/', $line, $matches) && $inUpstreams && $indent > $upstreamsIndent) {
                $content = trim($matches[1]);
                if (preg_match('/^addr:\s*(.+)$/', $content, $addrMatches)) {
                    $addr = trim($addrMatches[1]);
                    $currentPlugin['args']['upstreams'][] = array('addr' => $addr);
                    error_log("MosDNS YAML Debug: Added upstream addr: $addr");
                }
                continue;
            }
            
            // Handle new plugin item (starts with - and is at plugin level indentation)
            if (preg_match('/^-\s*(.*)$/', $line, $matches) && $indent == 2) {
                // Save previous plugin
                if ($currentPlugin !== null) {
                    error_log("MosDNS YAML Debug: Saving previous plugin: " . json_encode($currentPlugin));
                    $result['plugins'][] = $currentPlugin;
                }
                
                $currentPlugin = array();
                $inArgs = false;
                $inUpstreams = false;
                $pluginIndent = $indent;
                
                error_log("MosDNS YAML Debug: Starting new plugin at indent $indent");
                
                // Check if there's content after the dash
                $content = trim($matches[1]);
                if (!empty($content)) {
                    // Check if it's "args:" which indicates the start of args section
                    if ($content === 'args:') {
                        $currentPlugin['args'] = array();
                        $inArgs = true;
                        $argsIndent = $indent + 2; // args content will be indented more
                        error_log("MosDNS YAML Debug: Found args section at plugin start");
                    } else if (preg_match('/^([^:]+):\s*(.*)$/', $content, $fieldMatches)) {
                        $key = trim($fieldMatches[1]);
                        $value = trim($fieldMatches[2]);
                        $currentPlugin[$key] = $value;
                        error_log("MosDNS YAML Debug: Set plugin field $key = $value");
                    }
                }
                continue;
            }
            
            // Handle fields within a plugin
            if ($currentPlugin !== null && preg_match('/^([^:]+):\s*(.*)$/', $line, $matches)) {
                $key = trim($matches[1]);
                $value = trim($matches[2]);
                
                error_log("MosDNS YAML Debug: Processing field $key = $value");
                
                // Handle fields inside args
                if ($inArgs && $indent > $argsIndent) {
                    if ($key === 'upstreams') {
                        $currentPlugin['args']['upstreams'] = array();
                        $inUpstreams = true;
                        $upstreamsIndent = $indent;
                        error_log("MosDNS YAML Debug: Found upstreams section");
                    } else if (!empty($value)) {
                        $currentPlugin['args'][$key] = $value;
                        error_log("MosDNS YAML Debug: Set args[$key] = $value");
                    }
                    continue;
                }
                
                // Handle plugin-level fields (tag, type) - these come at plugin level indentation
                if ($indent > $pluginIndent && !$inArgs) {
                    $currentPlugin[$key] = $value;
                    error_log("MosDNS YAML Debug: Set plugin[$key] = $value");
                    
                    // When we encounter args, we enter args section
                    if ($key === 'args' && empty($value)) {
                        $inArgs = true;
                        $argsIndent = $indent;
                        $currentPlugin['args'] = array();
                        error_log("MosDNS YAML Debug: Entering args section");
                    }
                    continue;
                }
            }
        }
        
        // Add last plugin
        if ($currentPlugin !== null) {
            error_log("MosDNS YAML Debug: Saving final plugin: " . json_encode($currentPlugin));
            $result['plugins'][] = $currentPlugin;
        }
        
        // Post-process plugins to handle special cases like forward plugin with addr field
        if (isset($result['plugins'])) {
            $result['plugins'] = self::postProcessPlugins($result['plugins']);
        }
        
        error_log("MosDNS YAML Debug: Final result: " . json_encode($result));
        return $result;
    }

    /**
     * Get plugin-specific fields from XML configuration
     * @param string $pluginType Plugin type
     * @param object $plugin Plugin XML object
     * @return array
     */
    private static function getPluginSpecificFields($pluginType, $plugin)
    {
        $fields = array();
        
        switch (strtolower($pluginType)) {
            case 'forward':
                $fields['upstream'] = isset($plugin->upstream) ? (string)$plugin->upstream : '';
                break;
            case 'redirect':
                $fields['rules'] = isset($plugin->rules) ? (string)$plugin->rules : '';
                break;
            case 'hosts':
                $fields['hosts'] = isset($plugin->hosts) ? (string)$plugin->hosts : '';
                break;
            case 'servers':
                $fields['entry'] = isset($plugin->entry) ? (string)$plugin->entry : '';
                $fields['listen'] = isset($plugin->listen) ? (string)$plugin->listen : '';
                break;
            case 'sequence':
                $fields['exec'] = isset($plugin->exec) ? (string)$plugin->exec : '';
                break;
            case 'rule':
                $fields['rules'] = isset($plugin->rules) ? (string)$plugin->rules : '';
                break;
            case 'fallback':
                $fields['primary'] = isset($plugin->primary) ? (string)$plugin->primary : '';
                $fields['secondary'] = isset($plugin->secondary) ? (string)$plugin->secondary : '';
                break;
            case 'cache':
                $fields['size'] = isset($plugin->size) ? (string)$plugin->size : '1024';
                $fields['lazy_cache_ttl'] = isset($plugin->lazy_cache_ttl) ? (string)$plugin->lazy_cache_ttl : '86400';
                break;
            case 'datasources':
                $fields['file'] = isset($plugin->file) ? (string)$plugin->file : '';
                $fields['format'] = isset($plugin->format) ? (string)$plugin->format : '';
                break;
        }
        
        return $fields;
    }

    /**
     * Post-process plugins to handle special cases
     * @param array $plugins Array of plugins
     * @return array
     */
    private static function postProcessPlugins($plugins)
    {
        $processedPlugins = array();
        
        for ($i = 0; $i < count($plugins); $i++) {
            $plugin = $plugins[$i];
            
            // Handle forward plugin with addr field
            if (isset($plugin['type']) && $plugin['type'] === 'forward' && isset($plugin['addr'])) {
                // Move addr to upstreams array
                if (!isset($plugin['args'])) {
                    $plugin['args'] = array();
                }
                if (!isset($plugin['args']['upstreams'])) {
                    $plugin['args']['upstreams'] = array();
                }
                
                // Add addr to upstreams
                $plugin['args']['upstreams'][] = array('addr' => $plugin['addr']);
                
                // Remove addr from plugin level
                unset($plugin['addr']);
                
                error_log("MosDNS YAML Debug: Moved addr to upstreams for forward plugin: " . json_encode($plugin));
            }
            
            $processedPlugins[] = $plugin;
        }
        
        return $processedPlugins;
    }

    /**
     * Get plugin-specific fields from YAML configuration
     * @param string $pluginType Plugin type
     * @param array $pluginData Plugin data array
     * @return array
     */
    private static function getYamlPluginSpecificFields($pluginType, $pluginData)
    {
        $fields = array();
        
        switch (strtolower($pluginType)) {
            case 'forward':
                // Handle upstreams from args
                if (isset($pluginData['args']['upstreams']) && is_array($pluginData['args']['upstreams'])) {
                    $upstreams = array();
                    foreach ($pluginData['args']['upstreams'] as $upstream) {
                        if (isset($upstream['addr'])) {
                            $upstreams[] = $upstream['addr'];
                        }
                    }
                    $fields['upstream'] = implode('<br>', $upstreams); // Use <br> for HTML line breaks
                } else {
                    $fields['upstream'] = isset($pluginData['upstream']) ? 
                        (is_array($pluginData['upstream']) ? implode('<br>', $pluginData['upstream']) : $pluginData['upstream']) : '';
                }
                break;
            case 'redirect':
                $fields['rules'] = isset($pluginData['rules']) ? 
                    (is_array($pluginData['rules']) ? implode("\n", $pluginData['rules']) : $pluginData['rules']) : '';
                break;
            case 'hosts':
                $fields['hosts'] = isset($pluginData['hosts']) ? 
                    (is_array($pluginData['hosts']) ? implode("\n", $pluginData['hosts']) : $pluginData['hosts']) : '';
                break;
            case 'servers':
                $fields['entry'] = isset($pluginData['entry']) ? $pluginData['entry'] : 
                    (isset($pluginData['args']['entry']) ? $pluginData['args']['entry'] : '');
                $fields['listen'] = isset($pluginData['listen']) ? $pluginData['listen'] : 
                    (isset($pluginData['args']['listen']) ? $pluginData['args']['listen'] : '');
                break;
            case 'sequence':
                $fields['exec'] = isset($pluginData['exec']) ? 
                    (is_array($pluginData['exec']) ? implode("\n", $pluginData['exec']) : $pluginData['exec']) : '';
                break;
            case 'rule':
                $fields['rules'] = isset($pluginData['rules']) ? 
                    (is_array($pluginData['rules']) ? implode("\n", $pluginData['rules']) : $pluginData['rules']) : '';
                break;
            case 'fallback':
                $fields['primary'] = isset($pluginData['primary']) ? $pluginData['primary'] : '';
                $fields['secondary'] = isset($pluginData['secondary']) ? $pluginData['secondary'] : '';
                break;
            case 'cache':
                $fields['size'] = isset($pluginData['size']) ? $pluginData['size'] : '1024';
                $fields['lazy_cache_ttl'] = isset($pluginData['lazy_cache_ttl']) ? $pluginData['lazy_cache_ttl'] : '86400';
                break;
            case 'datasources':
                $fields['file'] = isset($pluginData['file']) ? $pluginData['file'] : '';
                $fields['format'] = isset($pluginData['format']) ? $pluginData['format'] : '';
                break;
        }
        
        return $fields;
    }

    /**
     * Check if plugin data matches the specified plugin type
     * @param array $pluginData Plugin data
     * @param string $targetType Target plugin type
     * @return bool
     */
    private static function isMatchingPluginType($pluginData, $targetType)
    {
        if (!isset($pluginData['type'])) {
            return false;
        }
        
        $pluginType = $pluginData['type'];
        $targetType = strtolower($targetType);
        
        switch ($targetType) {
            case 'forward':
                return $pluginType === 'forward';
            case 'redirect':
                return $pluginType === 'redirect';
            case 'hosts':
                return $pluginType === 'hosts';
            case 'servers':
                return strpos($pluginType, 'server') !== false || 
                       $pluginType === 'udp_server' || 
                       $pluginType === 'tcp_server';
            case 'sequence':
                return $pluginType === 'sequence';
            case 'rule':
                return $pluginType === 'rule';
            case 'fallback':
                return $pluginType === 'fallback';
            case 'cache':
                return $pluginType === 'cache';
            case 'datasources':
                return strpos($pluginType, 'data') !== false || 
                       $pluginType === 'domain_set' || 
                       $pluginType === 'ip_set';
            default:
                return false;
        }
    }
}