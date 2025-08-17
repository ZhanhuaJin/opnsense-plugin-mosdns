<?php

namespace OPNsense\MosDNS\Api;

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Backend;
use OPNsense\MosDNS\PluginTypes;

class ForwardController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'plugintypes';
    protected static $internalModelClass = 'OPNsense\MosDNS\PluginTypes';
    protected static $internalModelUseSafeDelete = true;

    /**
     * Get forward plugin configurations
     * @return array
     */
    public function getAction()
    {
        $result = array();
        if ($this->request->isGet()) {
            $mdl = $this->getModel();
            $result['forward'] = $mdl->forward->getNodes();
        }
        return $result;
    }

    /**
     * Get specific forward plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function getItemAction($uuid = null)
    {
        $mdl = $this->getModel();
        if ($uuid != null) {
            $node = $mdl->getNodeByReference('forward.plugin.' . $uuid);
            if ($node != null) {
                return array('forward' => $node->getNodes());
            }
        }
        return array();
    }

    /**
     * Add new forward plugin
     * @return array
     */
    public function addItemAction()
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost()) {
            $mdl = $this->getModel();
            $node = $mdl->forward->plugin->Add();
            $node->setNodes($this->request->getPost('forward'));
            $valMsgs = $mdl->performValidation();
            if (count($valMsgs) == 0) {
                $mdl->serializeToConfig();
                $result['uuid'] = $node->getAttribute('uuid');
                $result['result'] = 'saved';
            } else {
                $result['validations'] = $valMsgs;
            }
        }
        return $result;
    }

    /**
     * Update forward plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function setItemAction($uuid)
    {
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                $node = $mdl->getNodeByReference('forward.plugin.' . $uuid);
                if ($node != null) {
                    $node->setNodes($this->request->getPost('forward'));
                    $valMsgs = $mdl->performValidation();
                    if (count($valMsgs) == 0) {
                        $mdl->serializeToConfig();
                        return array('result' => 'saved');
                    } else {
                        return array('result' => 'failed', 'validations' => $valMsgs);
                    }
                }
            }
        }
        return array('result' => 'failed');
    }

    /**
     * Delete forward plugin by UUID
     * @param string $uuid item unique id
     * @return array
     */
    public function delItemAction($uuid)
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                if ($mdl->forward->plugin->del($uuid)) {
                    $mdl->serializeToConfig();
                    $result['result'] = 'deleted';
                } else {
                    $result['result'] = 'not found';
                }
            }
        }
        return $result;
    }

    /**
     * Toggle forward plugin enabled/disabled
     * @param string $uuid item unique id
     * @return array
     */
    public function toggleItemAction($uuid)
    {
        $result = array('result' => 'failed');
        if ($this->request->isPost() && $uuid != null) {
            $mdl = $this->getModel();
            if ($uuid != null) {
                $node = $mdl->getNodeByReference('forward.plugin.' . $uuid);
                if ($node != null) {
                    if ($node->enabled->__toString() == '1') {
                        $node->enabled = '0';
                    } else {
                        $node->enabled = '1';
                    }
                    $valMsgs = $mdl->performValidation();
                    if (count($valMsgs) == 0) {
                        $mdl->serializeToConfig();
                        $result['result'] = 'saved';
                    } else {
                        $result['validations'] = $valMsgs;
                    }
                }
            }
        }
        return $result;
    }

    /**
     * Search forward plugins
     * @return array
     */
    public function searchItemAction()
    {
        return $this->searchBase('forward.plugin', array('enabled', 'tag', 'concurrent', 'upstreams'));
    }
}