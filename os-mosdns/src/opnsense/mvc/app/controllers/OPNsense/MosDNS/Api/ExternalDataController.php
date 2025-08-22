<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Config;
use OPNsense\MosDNS\ExternalData;

class ExternalDataController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'externaldata';
    protected static $internalModelClass = 'OPNsense\MosDNS\ExternalData';

    /**
     * Search external data files
     * @return array search results
     */
    public function searchDataFileAction()
    {
        return $this->searchBase('data_files.data_file', array('name', 'filename', 'url', 'backup_url', 'enabled', 'auto_update', 'status', 'last_updated'), 'name');
    }

    /**
     * Get external data file by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function getDataFileAction($uuid = null)
    {
        return $this->getBase('data_file', 'data_files.data_file', $uuid);
    }

    /**
     * Add new external data file
     * @return array save result
     */
    public function addDataFileAction()
    {
        return $this->addBase('data_file', 'data_files.data_file');
    }

    /**
     * Delete external data file by UUID
     * @param string $uuid item unique id
     * @return array delete result
     */
    public function delDataFileAction($uuid)
    {
        return $this->delBase('data_files.data_file', $uuid);
    }

    /**
     * Update external data file by UUID
     * @param string $uuid item unique id
     * @return array save result
     */
    public function setDataFileAction($uuid)
    {
        return $this->setBase('data_file', 'data_files.data_file', $uuid);
    }

    /**
     * Toggle external data file by UUID (enable/disable)
     * @param string $uuid item unique id
     * @return array toggle result
     */
    public function toggleDataFileAction($uuid)
    {
        return $this->toggleBase('data_files.data_file', $uuid);
    }

    /**
     * Download a specific data file
     * @param string $uuid item unique id
     * @return array download result
     */
    public function downloadDataFileAction($uuid)
    {
        $result = array('result' => 'failed', 'message' => 'Unknown error');
        
        if ($this->request->isPost()) {
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('data_files.data_file.' . $uuid);
            
            if ($node != null) {
                $filename = (string)$node->filename;
                $url = (string)$node->url;
                $backup_url = (string)$node->backup_url;
                
                // Update status to downloading
                $node->status = 'downloading';
                $mdl->serializeToConfig();
                Config::getInstance()->save();
                
                // Execute download script
                $script = '/usr/local/opnsense/scripts/OPNsense/MosDNS/download_data_file.py';
                $command = sprintf('%s %s "%s" "%s" "%s"', 
                    escapeshellcmd($script),
                    escapeshellarg($uuid),
                    escapeshellarg($filename),
                    escapeshellarg($url),
                    escapeshellarg($backup_url)
                );
                
                $output = array();
                $return_code = 0;
                exec($command, $output, $return_code);
                
                if ($return_code === 0) {
                    $result['result'] = 'ok';
                    $result['message'] = 'Download started successfully';
                } else {
                    $result['message'] = 'Failed to start download: ' . implode('\n', $output);
                    
                    // Update status to failed
                    $node->status = 'failed';
                    $mdl->serializeToConfig();
                    Config::getInstance()->save();
                }
            } else {
                $result['message'] = 'Data file not found';
            }
        }
        
        return $result;
    }

    /**
     * Download all enabled data files
     * @return array download result
     */
    public function downloadAllAction()
    {
        $result = array('result' => 'failed', 'message' => 'Unknown error');
        
        if ($this->request->isPost()) {
            $mdl = $this->getModel();
            $data_files = $mdl->data_files->data_file->iterateItems();
            
            $download_count = 0;
            $errors = array();
            
            foreach ($data_files as $uuid => $node) {
                if ((string)$node->enabled === '1') {
                    $filename = (string)$node->filename;
                    $url = (string)$node->url;
                    $backup_url = (string)$node->backup_url;
                    
                    // Update status to downloading
                    $node->status = 'downloading';
                    
                    // Execute download script
                    $script = '/usr/local/opnsense/scripts/OPNsense/MosDNS/download_data_file.py';
                    $command = sprintf('%s %s "%s" "%s" "%s"', 
                        escapeshellcmd($script),
                        escapeshellarg($uuid),
                        escapeshellarg($filename),
                        escapeshellarg($url),
                        escapeshellarg($backup_url)
                    );
                    
                    $output = array();
                    $return_code = 0;
                    exec($command . ' 2>&1', $output, $return_code);
                    
                    if ($return_code === 0) {
                        $download_count++;
                    } else {
                        $errors[] = $filename . ': ' . implode(' ', $output);
                        $node->status = 'failed';
                    }
                }
            }
            
            $mdl->serializeToConfig();
            Config::getInstance()->save();
            
            if ($download_count > 0) {
                $result['result'] = 'ok';
                $result['message'] = sprintf('Started downloading %d files', $download_count);
                if (!empty($errors)) {
                    $result['message'] .= '. Errors: ' . implode('; ', $errors);
                }
            } else {
                $result['message'] = 'No enabled files to download';
                if (!empty($errors)) {
                    $result['message'] .= '. Errors: ' . implode('; ', $errors);
                }
            }
        }
        
        return $result;
    }

    /**
     * Get download status for all files
     * @return array status information
     */
    public function getStatusAction()
    {
        $result = array();
        $mdl = $this->getModel();
        $data_files = $mdl->data_files->data_file->iterateItems();
        
        foreach ($data_files as $uuid => $node) {
            $result[$uuid] = array(
                'name' => (string)$node->name,
                'filename' => (string)$node->filename,
                'status' => (string)$node->status,
                'last_updated' => (string)$node->last_updated,
                'file_size' => (string)$node->file_size
            );
        }
        
        return $result;
    }

    /**
     * Initialize default data files
     * @return array initialization result
     */
    public function initializeDefaultsAction()
    {
        $result = array('result' => 'failed', 'message' => 'Unknown error');
        
        if ($this->request->isPost()) {
            $mdl = $this->getModel();
            
            // Check if data files already exist
            $existing_files = $mdl->data_files->data_file->iterateItems();
            if (count($existing_files) > 0) {
                $result['result'] = 'ok';
                $result['message'] = 'Default data files already exist';
                return $result;
            }
            
            // Default data files configuration
            $default_files = array(
                array(
                    'name' => 'GeoIP Database',
                    'filename' => 'geoip.dat',
                    'url' => 'https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat'
                ),
                array(
                    'name' => 'GeoSite Database',
                    'filename' => 'geosite.dat',
                    'url' => 'https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat'
                ),
                array(
                    'name' => 'Direct Domain List',
                    'filename' => 'direct-list.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/direct-list.txt'
                ),
                array(
                    'name' => 'Proxy Domain List',
                    'filename' => 'proxy-list.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/proxy-list.txt'
                ),
                array(
                    'name' => 'Reject Domain List',
                    'filename' => 'reject-list.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/reject-list.txt'
                ),
                array(
                    'name' => 'China Domain List',
                    'filename' => 'china-list.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/china-list.txt'
                ),
                array(
                    'name' => 'Apple CN Domain List',
                    'filename' => 'apple-cn.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/apple-cn.txt'
                ),
                array(
                    'name' => 'Google CN Domain List',
                    'filename' => 'google-cn.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/google-cn.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/google-cn.txt'
                ),
                array(
                    'name' => 'GFW Domain List',
                    'filename' => 'gfw.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/gfw.txt'
                ),
                array(
                    'name' => 'Windows Spy Domain List',
                    'filename' => 'win-spy.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/win-spy.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/win-spy.txt'
                ),
                array(
                    'name' => 'Windows Update Domain List',
                    'filename' => 'win-update.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/win-update.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/win-update.txt'
                ),
                array(
                    'name' => 'Windows Extra Domain List',
                    'filename' => 'win-extra.txt',
                    'url' => 'https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/win-extra.txt',
                    'backup_url' => 'https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/win-extra.txt'
                )
            );
            
            // Add default files
            foreach ($default_files as $file_data) {
                $node = $mdl->data_files->data_file->Add();
                $node->name = $file_data['name'];
                $node->filename = $file_data['filename'];
                $node->url = $file_data['url'];
                $node->backup_url = $file_data['backup_url'];
                $node->enabled = '1';
                $node->auto_update = '0';
                $node->status = 'pending';
            }
            
            $validation_messages = $mdl->performValidation();
            if (empty($validation_messages)) {
                $mdl->serializeToConfig();
                Config::getInstance()->save();
                $result['result'] = 'ok';
                $result['message'] = 'Default data files initialized successfully';
            } else {
                $result['message'] = 'Validation failed: ' . implode(', ', $validation_messages);
            }
        }
        
        return $result;
    }
}