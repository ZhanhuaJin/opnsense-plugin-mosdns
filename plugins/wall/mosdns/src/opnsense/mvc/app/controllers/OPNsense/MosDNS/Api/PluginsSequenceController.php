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
 * Class PluginsSequenceController
 * @package OPNsense\MosDNS
 */
class PluginsSequenceController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'mosdns';
    protected static $internalModelClass = '\OPNsense\MosDNS\MosDNS';

    /**
     * Search sequence plugins
     * @return array
     */
    public function searchSequenceAction()
    {
        try {
            $rows = array();
            $existingTags = array();
            
            // Debug: Log start of search
            error_log("MosDNS Sequence Search: Starting search operation");
            
            // Get data from config.xml (OPNsense model)
            error_log("MosDNS Sequence Search: Parsing OPNsense model config");
            $mdl = $this->getModel();
            $node = $mdl->getNodeByReference('plugins.sequence.sequence');
            if ($node !== null) {
                $modelResult = $this->searchBase('plugins.sequence.sequence', array('enabled', 'name', 'exec'), 'name');
                if (isset($modelResult['rows'])) {
                    error_log("MosDNS Sequence Search: Found " . count($modelResult['rows']) . " entries from model config");
                    foreach ($modelResult['rows'] as $row) {
                        if (!in_array($row['name'], $existingTags)) {
                            $rows[] = $row;
                            $existingTags[] = $row['name'];
                        }
                    }
                } else {
                    error_log("MosDNS Sequence Search: No rows found in model config");
                }
            } else {
                error_log("MosDNS Sequence Search: plugins.sequence.sequence node not found in model");
            }
            
            // Sort by name
            usort($rows, function($a, $b) {
                return strcmp($a['name'], $b['name']);
            });
            
            error_log("MosDNS Sequence Search: Returning " . count($rows) . " total entries");
            
            return array(
                'rows' => $rows,
                'rowCount' => count($rows),
                'total' => count($rows),
                'current' => 1
            );
        } catch (\Exception $e) {
            error_log("MosDNS Sequence Search: Exception occurred: " . $e->getMessage());
            return array('rows' => array(), 'rowCount' => 0, 'total' => 0, 'current' => 1);
        }
    }

    public function getSequenceAction($uuid = null)
    {
        $this->sessionClose();
        
        // Debug: Log the call
        error_log("MosDNS Sequence: getSequenceAction called with UUID: " . ($uuid ?? 'null'));
        
        // Check if the model node exists before calling getBase
        $mdl = $this->getModel();
        $node = $mdl->getNodeByReference('plugins.sequence.sequence');
        
        if ($node === null) {
            error_log("MosDNS Sequence: plugins.sequence.sequence node not found in model");
            return array(
                'result' => 'failed',
                'validations' => array(),
                'sequence' => array()
            );
        }
        
        error_log("MosDNS Sequence: plugins.sequence.sequence node found, calling getBase");
        return $this->getBase('plugins.sequence.sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Update sequence plugin with given properties
     * @param string $uuid item unique id
     * @return array
     */
    public function setSequenceAction($uuid = null)
    {
        return $this->setBase('plugins.sequence.sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Add new sequence plugin and set with given properties
     * @return array
     */
    public function addSequenceAction()
    {
        return $this->addBase('plugins.sequence.sequence', 'plugins.sequence.sequence');
    }

    /**
     * Delete sequence plugin by uuid
     * @param string $uuid item unique id
     * @return array
     */
    public function delSequenceAction($uuid = null)
    {
        return $this->delBase('plugins.sequence.sequence', 'plugins.sequence.sequence', $uuid);
    }

    /**
     * Toggle sequence plugin by uuid (enable/disable)
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleSequenceAction($uuid = null)
    {
        return $this->toggleBase('plugins.sequence.sequence', 'plugins.sequence.sequence', $uuid);
    }
}